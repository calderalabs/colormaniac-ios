//
//  CMTGameManagerController.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 02/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTGameManagerController.h"
#import "CMTPainting.h"
#import "CMTGameController.h"
#import "CMTSoundManager.h"

@implementation CMTGameManagerController

- (CMTPainting *)nextPainting {
	NSUInteger currentPaintingIndex = [_paintings indexOfObject:_currentGameController.painting];
	
	return currentPaintingIndex + 1 >= _paintings.count ? nil : [_paintings objectAtIndex:currentPaintingIndex + 1];
}

- (id)initWithPaintings:(NSArray *)paintings startingIndex:(NSUInteger)index {
	if(self = [self initWithNibName:nil bundle:nil]) {
		_paintings = [paintings retain];
		
		_currentGameController = [[CMTGameController alloc] initWithPainting:[paintings objectAtIndex:index] managerController:self];

		[_currentGameController viewWillAppear:NO];
		[self.view addSubview:_currentGameController.view];
		[_currentGameController viewDidAppear:NO];
	}
	
	return self;
}

- (void)playPainting:(CMTPainting *)painting {
	CMTGameController *newGameController = [[CMTGameController alloc] initWithPainting:painting managerController:self];

	[newGameController viewWillAppear:YES];
	[_currentGameController viewWillDisappear:YES];

	[self.view insertSubview:newGameController.view atIndex:0];
	
	[UIView animateWithDuration:1.5
					 animations:^{
						 _currentGameController.view.alpha = 0.0;
					 }
					 completion:^(BOOL finished) {
						 [_currentGameController viewDidDisappear:YES];
						 [_currentGameController.view removeFromSuperview];
						 [_currentGameController release];
						 
						 [newGameController viewDidAppear:YES];
						 _currentGameController = newGameController;
					 }
	 ];

}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[CMTSoundManager sharedManager] pauseBackgroundMusicWithFadeTime:1.0];
    [_currentGameController viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[CMTSoundManager sharedManager] resumeBackgroundMusicWithFadeTime:1.0];
    [_currentGameController viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    if([_currentGameController shouldAutorotateToInterfaceOrientation:self.interfaceOrientation])
        [_currentGameController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
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
}


- (void)dealloc {
	[_paintings release];
	[_currentGameController release];
	
    [super dealloc];
}


@end
