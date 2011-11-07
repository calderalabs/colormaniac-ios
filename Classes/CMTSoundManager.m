//
//  CMTSoundManager.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 16/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTSoundManager.h"
#import <AVFoundation/AVFoundation.h>
#import "CMTSound.h"

static const int kNumSources = 12;
static NSString *kBackgroundMusicVolumeKey = @"kBackgroundMusicVolume";
static NSString *kEffectsVolumeKey = @"kEffectsVolume";

@implementation CMTSoundManager

@synthesize backgroundMusicVolume = _backgroundMusicVolume;
@synthesize effectsVolume = _effectsVolume;

static CMTSoundManager *sharedManager = nil;

+ (CMTSoundManager*)sharedManager
{
    if (sharedManager == nil) {
       sharedManager = [[super allocWithZone:NULL] init];
    }
    return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (void)release
{
	
}

- (id)autorelease
{
    return self;
}

- (void)fadeTimerTicked:(NSTimer *)timer {
	NSDictionary *fadeInfo = timer.userInfo;
	
	float toVolume = [[fadeInfo valueForKey:@"toVolume"] floatValue];
	float fromVolume = [[fadeInfo valueForKey:@"fromVolume"] floatValue];
	NSTimeInterval time = [[fadeInfo valueForKey:@"time"] doubleValue];
	
	if(time == 0.0 ||
	   ((toVolume > fromVolume) && (_backgroundMusicPlayer.volume > toVolume)) ||
	   ((toVolume < fromVolume) && (_backgroundMusicPlayer.volume < toVolume))) {
		_backgroundMusicPlayer.volume = toVolume;
		
		[_fadeTimer invalidate];
		[_fadeTimer release];
		_fadeTimer = nil;
		
		void (^completionBlock)(void) = [fadeInfo valueForKey:@"completionBlock"];
		
		if(![completionBlock isEqual:[NSNull null]])
			completionBlock();
        
        return;
	}
	
	_backgroundMusicPlayer.volume += ((toVolume - fromVolume) * [[NSDate date] timeIntervalSinceDate:_lastFadeDate]) / time;
	
	[_lastFadeDate release];
	_lastFadeDate = [[NSDate date] retain];
}

- (void)fadeBackgroundMusicPlayerToVolume:(float)volume time:(NSTimeInterval)time completion:(void (^)(void))completionBlock {
	[_fadeTimer invalidate];
	[_fadeTimer release];
	
	
	_fadeTimer = [[NSTimer scheduledTimerWithTimeInterval:0.0
												   target:self
												 selector:@selector(fadeTimerTicked:)
												 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
														   [NSNumber numberWithFloat:_backgroundMusicPlayer.volume], @"fromVolume",
														   [NSNumber numberWithFloat:volume], @"toVolume",
														   [NSNumber numberWithDouble:time], @"time",
														   completionBlock ? [[completionBlock copy] autorelease] : [NSNull null], @"completionBlock",
														   nil]
												  repeats:YES] retain];
	
	[_lastFadeDate release];
	_lastFadeDate = [[NSDate date] retain];
	
	[_fadeTimer fire];
}

- (void)setEffectsVolume:(ALfloat)effectsVolume {
    _effectsVolume = effectsVolume;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:_effectsVolume] forKey:kEffectsVolumeKey];
}

- (void)setBackgroundMusicVolume:(float)backgroundMusicVolume {
	[self setBackgroundMusicVolume:backgroundMusicVolume fadeTime:0.0];
}

- (void)setBackgroundMusicVolume:(float)backgroundMusicVolume fadeTime:(NSTimeInterval)fadeTime {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:_backgroundMusicVolume] forKey:kBackgroundMusicVolumeKey];

    _backgroundMusicVolume = backgroundMusicVolume;
    
    [self fadeBackgroundMusicPlayerToVolume:backgroundMusicVolume time:fadeTime completion:nil];
}

- (id)init {
	if(self = [super init]) {
        NSNumber *backgroundMusicVolumeNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kBackgroundMusicVolumeKey];
        _backgroundMusicVolume = backgroundMusicVolumeNumber ? [backgroundMusicVolumeNumber floatValue] : 0.5;

        NSNumber *effectsVolumeNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kEffectsVolumeKey];
        _effectsVolume = effectsVolumeNumber ? [effectsVolumeNumber floatValue] : 0.5;
		
		_effects = [[NSMutableArray alloc] init];
		
		_device = alcOpenDevice(NULL);
		
		if (_device != NULL)
		{
			_context = alcCreateContext(_device, 0);
			
			if (_context != NULL) {
				alcMakeContextCurrent(_context);
				
				_sources = malloc(sizeof(ALuint) * kNumSources);
				
				alGenSources(kNumSources, _sources);
				
				float sourcePos[] = { 0.0, 0.0, 0.0 };
				
				for(int i = 0; i < kNumSources; i++) {
					alSourcefv(_sources[i], AL_POSITION, sourcePos);
					alSourcef(_sources[i], AL_REFERENCE_DISTANCE, 0.0f);
				}
			}
		}
	}
	
	return self;
}

- (void)dealloc {
	[_backgroundMusicPlayer release];
	[_fadeTimer release];
	[_lastFadeDate release];
	[_effects release];
	
	alDeleteSources(kNumSources, _sources);
    alcDestroyContext(_context);
    alcCloseDevice(_device);
	
	free(_sources);
	
	[super dealloc];
}

- (void)playBackgroundMusic:(NSString *)filePath fadeTime:(NSTimeInterval)fadeTime {
	[_backgroundMusicPlayer release];
	_backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:filePath] error:nil];
	_backgroundMusicPlayer.numberOfLoops = -1;
	_backgroundMusicPlayer.volume = _backgroundMusicVolume;
	
	[_backgroundMusicPlayer play];
}

- (void)stopBackgroundMusicWithFadeTime:(NSTimeInterval)fadeTime {
	[self fadeBackgroundMusicPlayerToVolume:0.0 time:fadeTime completion:^{
		[_backgroundMusicPlayer stop];
	}];
}

- (void)pauseBackgroundMusicWithFadeTime:(NSTimeInterval)fadeTime {
	[self fadeBackgroundMusicPlayerToVolume:0.0 time:fadeTime completion:^{
		[_backgroundMusicPlayer pause];
	}];
}

- (void)resumeBackgroundMusicWithFadeTime:(NSTimeInterval)fadeTime {
	[_backgroundMusicPlayer play];
	
	[self fadeBackgroundMusicPlayerToVolume:_backgroundMusicVolume time:fadeTime completion:nil];
}

- (void)playBackgroundMusic:(NSString *)filePath {
	[self playBackgroundMusic:filePath fadeTime:0.0];
}

- (void)stopBackgroundMusic {
	[self stopBackgroundMusicWithFadeTime:0.0];
}

- (void)pauseBackgroundMusic {
	[self pauseBackgroundMusicWithFadeTime:0.0];
}

- (void)resumeBackgroundMusic {
	[self resumeBackgroundMusicWithFadeTime:0.0];
}

- (NSString *)soundEffectPathForName:(NSString *)effectName {
	return [[NSBundle mainBundle] pathForResource:effectName ofType:@"caf"];
}

- (CMTSound *)soundEffectWithName:(NSString *)effectName {
	for(CMTSound *effect in _effects)
		if([effect.filePath isEqualToString:[self soundEffectPathForName:effectName]])
			return effect;
	
	return nil;
}

- (void)preloadSoundEffect:(NSString *)effectName {
	if([self soundEffectWithName:effectName] != nil)
		return;
	
	CMTSound *effect = [CMTSound soundWithContentsOfFile:[self soundEffectPathForName:effectName]];
	[_effects addObject:effect];
}

- (void)unloadSoundEffect:(NSString *)effectName {
	CMTSound *effect = [self soundEffectWithName:effectName];
	[_effects removeObject:effect];
}

- (ALuint)nextSource {
	ALenum state;
	
	for(int i = 0; i < kNumSources; i++) {
		alGetSourcei(_sources[i], AL_SOURCE_STATE, &state);
		
		if(state != AL_PLAYING)
			return _sources[i];
	}
	
	return _sources[0];
}

- (ALuint)playSoundEffect:(NSString *)effectName {
	[self preloadSoundEffect:effectName];
	
	CMTSound *effect = [self soundEffectWithName:effectName];
	
	ALuint source = [self nextSource];
	
	alSourcei(source, AL_BUFFER, effect.buffer);
    alSourcef(source, AL_GAIN, _effectsVolume);
	alSourcePlay(source);
    
    return source;
}

- (void)stopSoundEffect:(ALuint)effectID {
    alSourceStop(effectID);
}

@end
