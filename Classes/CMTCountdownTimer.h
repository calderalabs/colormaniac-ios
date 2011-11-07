//
//  CMTCountdownTimer.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 03/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMTCountdownTimerDelegate.h"

@interface CMTCountdownTimer : NSObject {
	id<CMTCountdownTimerDelegate> _delegate;
	NSTimer *_timer;
	NSDate *_lastDate;
	
	NSTimeInterval _remainingTime;
}

- (id)initWithTime:(NSTimeInterval)time;
- (void)pause;
- (void)start;
- (void)stop;

@property (nonatomic, assign) id<CMTCountdownTimerDelegate> delegate;
@property (nonatomic, readonly) NSTimeInterval remainingTime;

@end
