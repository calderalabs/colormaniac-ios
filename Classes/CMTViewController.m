//
//  CMTViewController.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 29/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTViewController.h"


@implementation CMTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    self.view.frame = CGRectMake(0, 0,
                                 self.view.frame.size.height,
                                 self.view.frame.size.width -
                                 (self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.frame.size.height));
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
