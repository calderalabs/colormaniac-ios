//
//  CMTSettingsController.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 27/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTSettingsController.h"
#import "CMTSoundManager.h"

@implementation CMTSettingsController

- (id)init
{
    self = [self initWithNibName:@"CMTSettingsController" bundle:nil];
    if (self) {

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Settings";
    
    _backgroundMusicVolumeSlider.value = [CMTSoundManager sharedManager].backgroundMusicVolume;
    _effectsVolumeSlider.value = [CMTSoundManager sharedManager].effectsVolume;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [_backgroundMusicVolumeSlider release];
    _backgroundMusicVolumeSlider = nil;
    [_effectsVolumeSlider release];
    _effectsVolumeSlider = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)effectsVolumeChanged:(UISlider *)sender {
    [CMTSoundManager sharedManager].effectsVolume = sender.value;
}

- (IBAction)backgroundMusicVolumeChanged:(UISlider *)sender {
    [CMTSoundManager sharedManager].backgroundMusicVolume = sender.value;
}

@end
