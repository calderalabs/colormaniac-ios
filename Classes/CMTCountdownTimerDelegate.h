//
//  CMTCountdownTimerDelegate.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 03/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMTCountdownTimer;

@protocol CMTCountdownTimerDelegate <NSObject>

@optional

- (void)countdownTimerDidFinish:(CMTCountdownTimer *)timer;
- (void)countdownTimer:(CMTCountdownTimer *)timer didTickSecond:(int)second;

@end
