//
//  CMTSound.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 18/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>

@interface CMTSound : NSObject {
	ALuint _buffer;
	NSString *_filePath;
}

+ (CMTSound *)soundWithContentsOfFile:(NSString *)filePath;
- (id)initWithContentsOfFile:(NSString *)filePath;

@property (nonatomic, readonly) NSString *filePath;
@property (nonatomic, readonly) ALuint buffer;

@end
