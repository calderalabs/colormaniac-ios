//
//  CMTSoundManager.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 16/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@class AVAudioPlayer;

@interface CMTSoundManager : NSObject {
	NSTimer *_fadeTimer;
	NSDate *_lastFadeDate;
	
	float _backgroundMusicVolume;
	ALfloat _effectsVolume;

	ALuint *_sources;
	NSMutableArray *_effects;
	ALCcontext *_context;
	ALCdevice *_device;

	AVAudioPlayer *_backgroundMusicPlayer;
}

@property (nonatomic, assign) float backgroundMusicVolume;
@property (nonatomic, assign) ALfloat effectsVolume;

+ (CMTSoundManager *)sharedManager;

- (void)setBackgroundMusicVolume:(float)backgroundMusicVolume fadeTime:(NSTimeInterval)fadeTime;

- (void)playBackgroundMusic:(NSString *)filePath fadeTime:(NSTimeInterval)fadeTime;
- (void)stopBackgroundMusicWithFadeTime:(NSTimeInterval)fadeTime;
- (void)pauseBackgroundMusicWithFadeTime:(NSTimeInterval)fadeTime;
- (void)resumeBackgroundMusicWithFadeTime:(NSTimeInterval)fadeTime;

- (void)playBackgroundMusic:(NSString *)filePath;
- (void)stopBackgroundMusic;
- (void)pauseBackgroundMusic;
- (void)resumeBackgroundMusic;

- (void)preloadSoundEffect:(NSString *)effectName;
- (void)unloadSoundEffect:(NSString *)effectName;
- (ALuint)playSoundEffect:(NSString *)effectName;
- (void)stopSoundEffect:(ALuint)effectID;

@end
