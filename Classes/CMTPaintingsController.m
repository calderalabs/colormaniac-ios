//
//  CMTPaintingsController.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 02/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTPaintingsController.h"
#import "CMTPaintingTableViewCell.h"
#import "CMTGameManagerController.h"
#import "CMTPainting.h"
#import "CMTSoundManager.h"
#import "CMTGameManagerController.h"

@implementation CMTPaintingsController

@synthesize delegate = _delegate;
@synthesize paintings = _paintings;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithPaintings:(NSArray *)paintings {
	if(self = [self initWithStyle:UITableViewStylePlain]) {
		_paintings = [paintings retain];
	}
	
	return self;
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.tableView reloadData];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [CMTPaintingTableViewCell height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _paintings.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMTPaintingTableViewCell *cell = (CMTPaintingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CMTPaintingTableViewCell identifier]];
    if (cell == nil) {
        cell = [[[CMTPaintingTableViewCell alloc] initWithPainting:[_paintings objectAtIndex:indexPath.row]] autorelease];
    }
    
    cell.painting = [_paintings objectAtIndex:indexPath.row];
    
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
    CMTPainting *painting = [_paintings objectAtIndex:indexPath.row];
    
    CMTPaintingTableViewCell *cell = (CMTPaintingTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
	if(!painting.isLocked && !cell.saving) {
        [[CMTSoundManager sharedManager] playSoundEffect:@"click"];
        
        CMTGameManagerController *managerController = [[CMTGameManagerController alloc] initWithPaintings:_paintings startingIndex:indexPath.row];
        managerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentModalViewController:managerController animated:YES];
        
        [managerController release];
    }
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
}


- (void)dealloc {
	[_paintings release];
	
    [super dealloc];
}


@end

