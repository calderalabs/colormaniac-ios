//
//  CMTGalleriesController.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 28/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTGalleriesController.h"
#import "CMTGalleryManager.h"
#import "CMTGallery.h"
#import "CMTGalleryTableViewCell.h"
#import "CMTGameController.h"
#import "CMTPaintingsController.h"
#import "CMTGameManagerController.h"
#import "CMTStoreController.h"
#import "CMTStartController.h"
#import "CMTSoundManager.h"

static const CGFloat kBuyButtonHeight = 60.0;

@implementation CMTGalleriesController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Galleries";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Main Menu"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(mainMenu)] autorelease];
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[_tableView reloadData];
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

- (void)loadView {
    [super loadView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [self.view addSubview:_tableView];
    
    _buyMoreButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    
    [_buyMoreButton setTitle:@"BUY MORE GALLERIES!" forState:UIControlStateNormal];
    _buyMoreButton.titleLabel.font = [UIFont labelFontOfSize:30.0];
    _buyMoreButton.titleLabel.shadowColor = [UIColor blackColor];
    _buyMoreButton.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    
    [_buyMoreButton addTarget:self action:@selector(buyMore) forControlEvents:UIControlEventTouchUpInside];
    
    [_buyMoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buyMoreButton setBackgroundImage:[[UIImage imageNamed:@"greenButtonBackground"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];

    _buyMoreButton.frame = CGRectMake(0,
                                      self.view.frame.size.height - kBuyButtonHeight,
                                      self.view.frame.size.width, kBuyButtonHeight);
    
    _tableView.frame = CGRectMake(0,
                                  0,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height - _buyMoreButton.frame.size.height);
    
    [self.view addSubview:_buyMoreButton];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)mainMenu {
    CMTStartController *startController = [[CMTStartController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:startController];
	navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:navigationController animated:YES];
	[startController release];
	[navigationController release];
}

- (void)buyMore {
    [[CMTSoundManager sharedManager] playSoundEffect:@"click"];
    
	CMTStoreController *storeController = [[CMTStoreController alloc] init];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:storeController];
	[storeController release];
	navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	
	[self presentModalViewController:navigationController animated:YES];
	
	[navigationController release];
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [CMTGalleryTableViewCell height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [CMTGalleryManager sharedManager].galleries.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMTGalleryTableViewCell *cell = (CMTGalleryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CMTGalleryTableViewCell identifier]];
	
    if (cell == nil) {
        cell = [[[CMTGalleryTableViewCell alloc] initWithGallery:nil] autorelease];
    }
	
	cell.gallery = [[CMTGalleryManager sharedManager].galleries objectAtIndex:indexPath.row];
	
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[CMTSoundManager sharedManager] playSoundEffect:@"click"];
    
    CMTGalleryTableViewCell *cell = (CMTGalleryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    CMTPaintingsController *paintingsController = [[CMTPaintingsController alloc] initWithPaintings:cell.gallery.paintings];
    paintingsController.navigationItem.title = cell.gallery.name;
	paintingsController.delegate = self;
	
	[self.navigationController pushViewController:paintingsController animated:YES];
	[paintingsController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    [_buyMoreButton release];
    _buyMoreButton = nil;
    [_tableView release];
    _tableView = nil;
}


- (void)dealloc {
    [_buyMoreButton release];
    [_tableView release];
    
    [super dealloc];
}


@end

