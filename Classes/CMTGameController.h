//
//  CMTGameController.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 21/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTPictureViewDelegate.h"
#import "CMTPaletteBarViewDelegate.h"
#import "CMTCountdownTimerDelegate.h"
#import "CMTViewController.h"
#import "CMTButton.h"
#import <OpenAL/al.h>

@class CMTPictureView;
@class CMTPaletteBarView;
@class CMTPainting;
@class CMTGallery;
@class CMTLabel;
@class CMTCountdownTimer;
@class CMTGameManagerController;

@interface CMTGameController : CMTViewController <CMTPictureViewDelegate, CMTPaletteBarViewDelegate, CMTCountdownTimerDelegate> {
	CMTGameManagerController *_managerController;
	
	CMTPictureView *_pictureView;
	CMTLabel *_startTimeLabel;
	UIView *_paletteBars;
	CMTPaletteBarView *_leftPaletteBarView;
	CMTPaletteBarView *_rightPaletteBarView;
	CMTPainting *_painting;
    UIView *_detailsView;
	CMTLabel *_brushesLabel;
	CMTLabel *_timeLabel;
    CMTLabel *_scoreLabel;
    UIView *_overlayView;
    
	CMTCountdownTimer *_gameTimer;
	CMTCountdownTimer *_startTimer;
	
	int _brushes;
	int _score;
    
    ALuint _medalSound;
}

@property (nonatomic, assign) int brushes;
@property (nonatomic, assign) int score;
@property (nonatomic, readonly) CMTPainting *painting;

- (void)setBrushes:(int)brushes animated:(BOOL)animated;
- (void)setScore:(int)score animated:(BOOL)animated;

- (void)startGameInSeconds:(int)seconds;

- (id)initWithPainting:(CMTPainting *)painting managerController:(CMTGameManagerController *)managerController;

@end
