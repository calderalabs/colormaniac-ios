//
//  CMTSound.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 18/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTSound.h"
#import "MyOpenALSupport.h"
#import "CMTSoundManager.h"

@implementation CMTSound

@synthesize filePath = _filePath;
@synthesize buffer = _buffer;

+ (CMTSound *)soundWithContentsOfFile:(NSString *)filePath {
	return [[[CMTSound alloc] initWithContentsOfFile:filePath] autorelease];
}

- (id)initWithContentsOfFile:(NSString *)filePath {
	if(self = [super init]) {
		[CMTSoundManager sharedManager];
		
		_filePath = [filePath retain];
		
		alGenBuffers(1, &_buffer);
		
		CFURLRef fileURL = (CFURLRef)[[NSURL fileURLWithPath:filePath] retain];
		
		if (fileURL)
		{	
			ALenum format;
			ALsizei size;
			ALsizei freq;
			
			void *data = MyGetOpenALAudioData(fileURL, &size, &format, &freq);
			CFRelease(fileURL);
			
			alBufferData(_buffer, format, data, size, freq);
			
			free(data);
		}
	}
	
	return self;
}

- (void)dealloc {
	[_filePath release];
	
    alDeleteBuffers(1, &_buffer);
	
	[super dealloc];
}

@end
