//
//  CMTCountdownTimer.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 03/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTCountdownTimer.h"
#import <QuartzCore/QuartzCore.h>

@implementation CMTCountdownTimer

@synthesize remainingTime = _remainingTime;
@synthesize delegate = _delegate;

- (id)initWithTime:(NSTimeInterval)time {
	if((self = [self init])) {
		_remainingTime = time;
	}
	
	return self;
}

- (void)updateTime:(NSTimer *)timer {
	NSTimeInterval previousRemainingTime = _remainingTime;
	
	NSDate *now = [[NSDate alloc] init];
	
	NSTimeInterval duration = [now timeIntervalSinceDate:_lastDate];

	[_lastDate release];
	_lastDate = now;
	
	_remainingTime -= duration;
	
	if(ceil(previousRemainingTime) > ceil(_remainingTime) && [_delegate respondsToSelector:@selector(countdownTimer:didTickSecond:)])
		[_delegate countdownTimer:self didTickSecond:(int)ceil(_remainingTime)];
	
	if(_remainingTime <= 0) {
		[self pause];
		
		if([_delegate respondsToSelector:@selector(countdownTimerDidFinish:)])
			[_delegate countdownTimerDidFinish:self];
	}
}

- (void)start {
	[_timer invalidate];
	[_timer release];
	
	[_lastDate release];
	_lastDate = [[NSDate alloc] init];
	
	_timer = [[NSTimer scheduledTimerWithTimeInterval:0.0
											   target:self
											 selector:@selector(updateTime:)
											 userInfo:nil
											  repeats:YES] retain];
	
	if([_delegate respondsToSelector:@selector(countdownTimer:didTickSecond:)])
		[_delegate countdownTimer:self didTickSecond:(int)ceil(_remainingTime)];
}

- (void)pause {
	[_timer invalidate];
	[_timer release];
	_timer = nil;
}

- (void)stop {
	[self pause];
	
	_remainingTime = 0;
}

- (void)dealloc {
	[_timer invalidate];
	[_timer release];
	[_lastDate release];
	
	[super dealloc];
}

@end
