    //
//  CMTStartController.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 10/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTStartController.h"
#import "CMTButton.h"
#import "CMTActionListView.h"
#import "CMTSettingsController.h"
#import "CMTCreditsController.h"

@implementation CMTStartController

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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle].resourcePath
																								 stringByAppendingPathComponent:@"startBackground.png"]]];

    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = @"ColorManiac";
    titleLabel.font = [UIFont labelFontOfSize:110.0];
    titleLabel.textColor = [UIColor labelColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    
    titleLabel.frame = CGRectMake(floor((self.view.frame.size.width - titleLabel.frame.size.width) / 2),
                                  70,
                                  titleLabel.frame.size.width,
                                  titleLabel.frame.size.height);
    
    CMTButton *startButton = [CMTButton buttonWithTitle:@"New Game" target:self action:@selector(start)];
    startButton.textSize = 40.0;
    CMTButton *settingsButton = [CMTButton buttonWithTitle:@"Settings" target:self action:@selector(settings)];
    settingsButton.textSize = 35.0;
    CMTButton *creditsButton = [CMTButton buttonWithTitle:@"Credits" target:self action:@selector(credits)];
    creditsButton.textSize = 35.0;
    
    CMTActionListView *actionView = [[CMTActionListView alloc] initWithButtons:[NSArray arrayWithObjects:
                                                                                startButton,
                                                                                settingsButton,
                                                                                creditsButton,
                                                                                nil]];
	
    CGSize actionViewSize = CGSizeMake(250, 250);
    
	actionView.frame = CGRectMake(floor((self.view.frame.size.width - actionViewSize.width) / 2),
								   self.view.frame.size.height - actionViewSize.height - 100,
								   actionViewSize.width,
								   actionViewSize.height);

	[self.view addSubview:actionView];
    [self.view addSubview:titleLabel];
    
    [titleLabel release];
    [actionView release];
}

- (void)start {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)settings {
    CMTSettingsController *settingsController = [[CMTSettingsController alloc] init];
    
    [self.navigationController pushViewController:settingsController animated:YES];
    
    [settingsController release];
}

- (void)credits {
    CMTCreditsController *creditsController = [[CMTCreditsController alloc] init];
    
    [self.navigationController pushViewController:creditsController animated:YES];
    
    [creditsController release];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

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
}


- (void)dealloc {
    [super dealloc];
}


@end
