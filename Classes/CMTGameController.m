//
//  CMTGameController.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 21/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTGameController.h"
#import "CMTPictureView.h"
#import "CMTPaletteView.h"
#import "CMTPaletteBarView.h"
#import "CMTGallery.h"
#import "CMTLabel.h"
#import "CMTPainting.h"
#import "CMTGalleryManager.h"
#import "CMTCountdownTimer.h"
#import "CMTActionListView.h"
#import "CMTGameManagerController.h"
#import "CMTSoundManager.h"

#import <QuartzCore/QuartzCore.h>

static const CGFloat kPadding = 20.0;
static const NSTimeInterval kGameTime = 45;

@implementation CMTGameController

@synthesize painting = _painting;
@synthesize brushes = _brushes;
@synthesize score = _score;

- (void)setBrushes:(int)brushes {
	[self setBrushes:brushes animated:NO];
}

- (void)setBrushes:(int)brushes animated:(BOOL)animated {
    [_brushesLabel setText:[NSString stringWithFormat:@"%d", brushes]
                  animated:animated
                     color:(_brushes > brushes) ? [UIColor redColor] : [UIColor whiteColor]];
    
    [_brushesLabel sizeToFit];
    
    _brushesLabel.frame = CGRectMake(self.view.frame.size.width - _rightPaletteBarView.frame.size.width - _brushesLabel.frame.size.width - kPadding,
                                     0,
                                     _brushesLabel.frame.size.width,
                                     _brushesLabel.frame.size.height);
    
    _brushes = brushes;
}

- (void)setScore:(int)score {
	[self setScore:score animated:NO];
}

- (void)setScore:(int)score animated:(BOOL)animated {
	[_scoreLabel setText:[NSString stringWithFormat:@"%d", score]
                animated:animated];
	
	[_scoreLabel sizeToFit];
	
	_scoreLabel.frame = CGRectMake(_leftPaletteBarView.frame.size.width + kPadding, 
                                   0,
                                   _scoreLabel.frame.size.width,
                                   _scoreLabel.frame.size.height);
	
	_score = score;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

- (id)initWithPainting:(CMTPainting *)painting managerController:(CMTGameManagerController *)managerController {
	if((self = [self initWithNibName:nil bundle:nil])) {
		_painting = [painting retain];
		_managerController = [managerController retain];
	}
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[CMTSoundManager sharedManager] stopSoundEffect:_medalSound];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor blackColor];
	
	_paletteBars = [[UIView alloc] initWithFrame:self.view.frame];
	_paletteBars.alpha = 0.0;
	
	_leftPaletteBarView = [[CMTPaletteBarView alloc] initWithType:CMTPaletteBarViewTypeFirst];
	_leftPaletteBarView.delegate = self;
	
	_rightPaletteBarView = [[CMTPaletteBarView alloc] initWithType:CMTPaletteBarViewTypeSecond];
	_rightPaletteBarView.delegate = self;
	
	_rightPaletteBarView.frame = CGRectMake(self.view.frame.size.width - _rightPaletteBarView.frame.size.width,
											0,
											_rightPaletteBarView.frame.size.width,
											_rightPaletteBarView.frame.size.height);
	
	[_paletteBars addSubview:_leftPaletteBarView];
	[_paletteBars addSubview:_rightPaletteBarView];
	
	_pictureView = [[CMTPictureView alloc] initWithPainting:_painting];
    [_pictureView sizeToFit];
	
	_pictureView.delegate = self;
	
    _detailsView = [[UIView alloc] initWithFrame:self.view.frame];
    
	CMTButton *startButton = [CMTButton buttonWithTitle:@"Ready!" target:self action:@selector(ready:)];
	startButton.textSize = 50.0;
	[startButton sizeToFit];
	
	startButton.frame = CGRectMake(floor((_detailsView.frame.size.width - startButton.frame.size.width) / 2),
                                   floor((_detailsView.frame.size.height - startButton.frame.size.height) / 2),
                                   startButton.frame.size.width,
                                   startButton.frame.size.height);
	startButton.textColor = [UIColor colorWithRed:0 green:180/255.0 blue:0 alpha:1.0];
    
    [_detailsView addSubview:startButton];
    
    UIView *topDetailsView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _detailsView.frame.size.width, startButton.frame.origin.y)] autorelease];
    [_detailsView addSubview:topDetailsView];
    
    UIView *topDetailsLabelsView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    titleLabel.text = _painting.title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor labelColor];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    titleLabel.font = [UIFont labelFontOfSize:80.0];
    
    UILabel *authorLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    authorLabel.text = _painting.author;
    authorLabel.backgroundColor = [UIColor clearColor];
    authorLabel.textColor = [UIColor labelColor];
    authorLabel.font = [UIFont labelFontOfSize:60.0];
    
    [authorLabel sizeToFit];
    
    CGSize titleSize = titleLabel.text ? [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(self.view.frame.size.width - kPadding * 2, topDetailsView.frame.size.height - authorLabel.frame.size.height - kPadding) lineBreakMode:UILineBreakModeWordWrap] : CGSizeZero;
    
    CGSize topDetailsLabelsViewSize = CGSizeMake(topDetailsView.frame.size.width,
                                                 titleSize.height + kPadding + authorLabel.frame.size.height);
    
    topDetailsLabelsView.frame = CGRectMake(floor((topDetailsView.frame.size.width - topDetailsLabelsViewSize.width) / 2),
                                            floor((topDetailsView.frame.size.height - topDetailsLabelsViewSize.height) / 2),
                                            topDetailsLabelsViewSize.width,
                                            topDetailsLabelsViewSize.height);
    
    titleLabel.frame = CGRectMake(floor((topDetailsLabelsViewSize.width - titleSize.width) / 2),
                                  0,
                                  titleSize.width,
                                  titleSize.height);
    
    authorLabel.frame = CGRectMake(floor((topDetailsLabelsViewSize.width - authorLabel.frame.size.width) / 2),
                                   titleLabel.frame.size.height + kPadding,
                                   authorLabel.frame.size.width,
                                   authorLabel.frame.size.height);
    
    [topDetailsLabelsView addSubview:titleLabel];
    [topDetailsLabelsView addSubview:authorLabel];
    
    [topDetailsView addSubview:topDetailsLabelsView];
    
    UIView *bottomDetailsView = [[[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          startButton.frame.origin.y + startButton.frame.size.height,
                                                                          _detailsView.frame.size.width,
                                                                          startButton.frame.origin.y)] autorelease];
    
    [_detailsView addSubview:bottomDetailsView];
    
    UIView *bottomDetailsLabelsView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    
    UILabel *difficultyLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    difficultyLabel.text = [NSString stringWithFormat:@"Difficulty: %@", _painting.difficultyTitle];
    difficultyLabel.backgroundColor = [UIColor clearColor];
    difficultyLabel.textColor = [UIColor whiteColor];
    difficultyLabel.font = [UIFont labelFontOfSize:60.0];
    
    [difficultyLabel sizeToFit];
    
    [bottomDetailsLabelsView addSubview:difficultyLabel];
    
    CGSize bottomDetailsLabelsViewSize = CGSizeMake(bottomDetailsView.frame.size.width,
                                                    difficultyLabel.frame.size.height);
    
    bottomDetailsLabelsView.frame = CGRectMake(floor((bottomDetailsView.frame.size.width - bottomDetailsLabelsViewSize.width) / 2),
                                               floor((bottomDetailsView.frame.size.height - bottomDetailsLabelsViewSize.height) / 2),
                                               bottomDetailsLabelsViewSize.width,
                                               bottomDetailsLabelsViewSize.height);
    
    difficultyLabel.frame = CGRectMake(floor((bottomDetailsLabelsViewSize.width - difficultyLabel.frame.size.width) / 2),
                                       0,
                                       difficultyLabel.frame.size.width,
                                       difficultyLabel.frame.size.height);
    
    [bottomDetailsLabelsView addSubview:difficultyLabel];
    
    [bottomDetailsView addSubview:bottomDetailsLabelsView];
    
    topDetailsView.frame = CGRectMake(0, 0, _detailsView.frame.size.width, startButton.frame.origin.y);
    bottomDetailsView.frame = CGRectMake(0,
                                         startButton.frame.origin.y + startButton.frame.size.height,
                                         _detailsView.frame.size.width,
                                         startButton.frame.origin.y);
    
    _pictureView.frame = CGRectMake(floor((self.view.frame.size.width - _pictureView.frame.size.width) / 2),
									floor((self.view.frame.size.height - _pictureView.frame.size.height) / 2),
									_pictureView.frame.size.width,
									_pictureView.frame.size.height);
    
	_brushesLabel = [[CMTLabel alloc] initWithImage:[UIImage imageNamed:@"brush.png"]];
	_brushesLabel.textSize = 60.0;
	_brushesLabel.alpha = 0.0;
	
	_timeLabel = [[CMTLabel alloc] initWithImage:nil];
	_timeLabel.textSize = 60.0;
	_timeLabel.alpha = 0.0;
	
	_scoreLabel = [[CMTLabel alloc] initWithImage:nil];
	_scoreLabel.textSize = 60.0;
	_scoreLabel.alpha = 0.0;
    
	[self.view addSubview:_pictureView];
	[self.view addSubview:_paletteBars];
	[self.view addSubview:_brushesLabel];
	[self.view addSubview:_timeLabel];
	[self.view addSubview:_scoreLabel];
    
    _overlayView = [[UIView alloc] initWithFrame:self.view.frame];
	_overlayView.backgroundColor = [UIColor blackColor];
	_overlayView.alpha = 0.7;
    
	[self.view addSubview:_overlayView];
    [self.view addSubview:_detailsView];
    
	self.brushes = 5;
	self.score = 0;
}

- (void)ready:(CMTButton *)sender {
	[UIView animateWithDuration:0.5 animations:^{_detailsView.alpha = 0.0;_overlayView.alpha = 0.0;}
					 completion:^(BOOL finished){
						 [_detailsView release];
						 _detailsView = nil;
                         
						 [self startGameInSeconds:5];
					 }];
}

- (void)startGameInSeconds:(int)seconds {
	[_pictureView showOriginalPictureWithDuration:seconds];
	
	if(!_startTimeLabel) {
		_startTimeLabel = [[CMTLabel alloc] initWithImage:nil];
		_startTimeLabel.textSize = 90.0;
		
		[self.view addSubview:_startTimeLabel];
	}
}

- (void)showGameOver {
	if(_gameTimer)
		[_gameTimer pause];
    
    CMTPaintingMedal medal = [_painting medalForScore:_score];
    
    if(medal > _painting.medal)
        _medalSound = [[CMTSoundManager sharedManager] playSoundEffect:@"medal"];
    
    if(_score > _painting.score) {
		_painting.score = _score;

        if(_painting.isCompleted)
            [_managerController nextPainting].locked = NO;
        
        [[CMTGalleryManager sharedManager] saveToDisk];
    }
	
	UIView *gameOverView = [[UIView alloc] initWithFrame:CGRectZero];
	gameOverView.alpha = 0.0;
	
	UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	messageLabel.font = [UIFont labelFontOfSize:60.0];
	messageLabel.backgroundColor = [UIColor clearColor];
	messageLabel.textColor = [UIColor labelColor];
    messageLabel.text = @"Game Over";
	
	[messageLabel sizeToFit];
	
	[gameOverView addSubview:messageLabel];
	
	[messageLabel release];
	
    if(medal != CMTPaintingMedalNone) {
        NSString *imageName = nil;
        
        switch (medal) {
            case CMTPaintingMedalBronze:
                imageName = @"BronzeBrush";
                break;
            case CMTPaintingMedalSilver:
                imageName = @"SilverBrush";
                break;
            case CMTPaintingMedalGold:
                imageName = @"GoldBrush";
                break;
            case CMTPaintingMedalDiamond:
                imageName = @"DiamondBrush";
                break;
            default:
                break;
        }
        
        UILabel *medalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        medalLabel.font = [UIFont labelFontOfSize:40.0];
        medalLabel.backgroundColor = [UIColor clearColor];
        medalLabel.textColor = [UIColor labelColor];
        medalLabel.numberOfLines = 2;
        medalLabel.textAlignment = UITextAlignmentCenter;
        medalLabel.text = [NSString stringWithFormat:@"You gained a:\n%@", [_painting medalTitleForMedal:medal]];
        
        [medalLabel sizeToFit];
        
        [gameOverView addSubview:medalLabel];
        
        [medalLabel release];
        
        UIImageView *medalView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        
        [gameOverView addSubview:medalView];
        
        [medalView release];
    }
    
	NSMutableArray *buttons = [NSMutableArray array];
	
	if(!![_managerController nextPainting] && ![_managerController nextPainting].isLocked) {
		CMTButton *playNextButton = [CMTButton buttonWithTitle:@"Play Next" target:self action:@selector(playNext)];
		[buttons addObject:playNextButton];
	}
	
	CMTButton *playAgainButton = [CMTButton buttonWithTitle:@"Play Again" target:self action:@selector(playAgain)];
	[buttons addObject:playAgainButton];
	
	CMTButton *backButton = [CMTButton buttonWithTitle:@"Back to Galleries" target:self action:@selector(backToMainMenu)];
	[buttons addObject:backButton];
	
	CMTActionListView *actionListView = [[[CMTActionListView alloc] initWithButtons:buttons] autorelease];
	actionListView.frame = CGRectMake(0, 0, 300, buttons.count * 70);
	
	[gameOverView addSubview:actionListView];
	
	CGSize size = CGSizeMake(0, 0);
	
	for(UIView *subview in gameOverView.subviews)
		if(subview.frame.size.width > size.width)
			size.width = subview.frame.size.width;
	
	for(UIView *subview in gameOverView.subviews) {
		subview.frame = CGRectMake(floor((size.width - subview.frame.size.width) / 2),
								   size.height,
								   subview.frame.size.width,
								   subview.frame.size.height);
		
		size.height += subview.frame.size.height + kPadding;
	}
	
	size.height -= kPadding;
	
	gameOverView.frame = CGRectMake(floor((self.view.frame.size.width - size.width) / 2),
									floor((self.view.frame.size.height - size.height) / 2),
									size.width,
									size.height);
	
	[self.view addSubview:gameOverView];
	
	[UIView animateWithDuration:1.0
					 animations:^{
						 _overlayView.alpha = 0.7;
						 gameOverView.alpha = 1.0;
					 }
					 completion:^(BOOL finished){
						 self.view.userInteractionEnabled = YES;
					 }];
}

- (void)playNext {
	[_managerController playPainting:[_managerController nextPainting]];
}

- (void)playAgain {
	[_managerController playPainting:_painting];
}

- (void)backToMainMenu {
	[_managerController dismissModalViewControllerAnimated:YES];
}

- (void)countdownTimerDidFinish:(CMTCountdownTimer *)timer {
	if(timer == _gameTimer) {
		[_gameTimer stop];
		[_gameTimer release];
		_gameTimer = nil;
		
		self.view.userInteractionEnabled = NO;
		
		[NSTimer scheduledTimerWithTimeInterval:1.0
										 target:self
									   selector:@selector(showGameOver)
									   userInfo:nil
										repeats:NO];
	}
	else if(timer == _startTimer) {
		[_startTimer stop];
		[_startTimer release];
		_startTimer = nil;
		
		[_gameTimer stop];
		[_gameTimer release];
		_gameTimer = [[CMTCountdownTimer alloc] initWithTime:kGameTime];
		_gameTimer.delegate = self;
		[_gameTimer start];
		[_gameTimer pause];
		
		[UIView animateWithDuration:1.0
						 animations:^{
							 _paletteBars.alpha = 1.0;
							 _brushesLabel.alpha = 1.0;
							 _timeLabel.alpha = 1.0;
							 _scoreLabel.alpha = 1.0;
						 }
						 completion:^(BOOL finished){
							 [_startTimeLabel release];
							 _startTimeLabel = nil;
							 
							 [_gameTimer start];
						 }];
	}
}

- (void)countdownTimer:(CMTCountdownTimer *)timer didTickSecond:(int)second {
	if(timer == _gameTimer) {
        if(second == 5)
            [[CMTSoundManager sharedManager] playSoundEffect:@"clock"];
        
		[_timeLabel setText:[NSString stringWithFormat:@"%02d:%02d", second / 60, second % 60] animated:second <= 5
					  color:second <= 5 ? [UIColor redColor] : [UIColor whiteColor]];
		
		[_timeLabel sizeToFit];
		
		_timeLabel.frame = CGRectMake(floor((self.view.frame.size.width - _timeLabel.frame.size.width) / 2),
									  0,
									  _timeLabel.frame.size.width,
									  _timeLabel.frame.size.height);
	}
	else if(timer == _startTimer && second != 0) {
		_startTimeLabel.text = [NSString stringWithFormat:@"%d", second];
		[_startTimeLabel sizeToFit];
		
		_startTimeLabel.frame = CGRectMake(floor((self.view.frame.size.width - _startTimeLabel.frame.size.width) / 2),
										   floor((self.view.frame.size.height - _startTimeLabel.frame.size.height) / 2),
										   _startTimeLabel.frame.size.width,
										   _startTimeLabel.frame.size.height);
		
		_startTimeLabel.alpha = 1.0;
		
		[UIView animateWithDuration:1.0 animations:^{_startTimeLabel.alpha = 0.0;}];
	}
}

- (void)paletteBarView:(CMTPaletteBarView *)paletteBarView didChoosePaletteView:(CMTPaletteView *)paletteView {
	[_gameTimer pause];
	
	[[CMTSoundManager sharedManager] playSoundEffect:@"colorizing"];
	[_pictureView colorizeWithColors:paletteView.colors];
    
	self.view.userInteractionEnabled = NO;
	[self setBrushes:_brushes - 1 animated:YES];
}

- (void)pictureView:(CMTPictureView *)pictureView didFinishColorizingRowWithColors:(NSArray *)colors {
	
    self.score = pictureView.colorizedPixels;
}

- (void)pictureView:(CMTPictureView *)pictureView didFinishColorizingWithColors:(NSArray *)colors {
	self.view.userInteractionEnabled = YES;
	
	[_gameTimer start];
    
	if(_brushes == 0)
		[self showGameOver];
}

- (void)pictureViewDidStartShowingOriginalPicture:(CMTPictureView *)pictureView {
	[_startTimer stop];
	[_startTimer release];
	_startTimer = [[CMTCountdownTimer alloc] initWithTime:5];
	_startTimer.delegate = self;
	[_startTimer start];
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
	[_pictureView release];
    _pictureView = nil;
	[_startTimeLabel release];
    _startTimeLabel = nil;
	[_paletteBars release];
    _paletteBars = nil;
	[_leftPaletteBarView release];
    _leftPaletteBarView = nil;
	[_rightPaletteBarView release];
    _rightPaletteBarView = nil;
	[_brushesLabel release];
    _brushesLabel = nil;
	[_timeLabel release];
    _timeLabel = nil;
	[_scoreLabel release];
    _scoreLabel = nil;
    [_overlayView release];
    _overlayView = nil;
}


- (void)dealloc {
	[_pictureView release];
	[_startTimeLabel release];
	[_paletteBars release];
	[_leftPaletteBarView release];
	[_rightPaletteBarView release];
	[_painting release];
	[_managerController release];
	[_brushesLabel release];
	[_timeLabel release];
	[_gameTimer release];
	[_startTimer release];
	[_scoreLabel release];
    [_overlayView release];
    
    [super dealloc];
}


@end
