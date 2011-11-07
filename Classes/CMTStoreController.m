//
//  CMTStoreController.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 04/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTPainting.h"
#import "CMTGallery.h"
#import "CMTGalleryManager.h"
#import "CMTStoreController.h"
#import "CMTHTTPRequest.h"
#import "JSON.h"
#import "CMTProductTableViewCell.h"
#import "CMTProductRequest.h"

static const CGFloat kPadding = 15.0;

@interface CMTStoreController (PrivateMethods)

- (void)processTransactions:(NSArray *)transactions;

@end

@implementation CMTStoreController

#pragma mark -
#pragma mark View lifecycle

- (void)showComputing:(BOOL)show {
	[UIView animateWithDuration:0.5 animations:^{
		_computingLabel.alpha = show ? 1.0 : 0;
	}];
}

- (void)showOverlay:(BOOL)show {
	[UIView animateWithDuration:0.5 animations:^{
		_overlayView.alpha = show ? 0.7 : 0;
	}];
}

- (void)showActivity:(BOOL)show {
	show ? [_activityIndicatorView startAnimating] : [_activityIndicatorView stopAnimating];
}

- (void)showProgress:(BOOL)show {
	[UIView animateWithDuration:0.5 animations:^{
		_progressView.alpha = show ? 1.0 : 0;
		_progressLabel.alpha = show ? 1.0 : 0;
	}];
}

- (void)cancel {
    _dismissed = YES;
    
    [_galleriesRequest clearDelegatesAndCancel];
    [_productsRequest cancel];
    
    for(CMTProductRequest *request in _deliveringQueue.operations)
        request.delegate = nil;
    
    [_deliveringQueue cancelAllOperations];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		_deliveringQueue = [[NSOperationQueue alloc] init];
        [_deliveringQueue setMaxConcurrentOperationCount:1];
        
        [_deliveringQueue addObserver:self
                           forKeyPath:@"operationCount"
                              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context:nil];
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
    
	_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
	_tableView.allowsSelection = NO;
	_tableView.alpha = 0.0;
	
	_tableView.delegate = self;
	_tableView.dataSource = self;
    
	_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[_activityIndicatorView sizeToFit];
	_activityIndicatorView.frame = CGRectMake(floor((self.view.frame.size.width - _activityIndicatorView.frame.size.width) / 2),
											  floor((self.view.frame.size.height - _activityIndicatorView.frame.size.height) / 2),
											  _activityIndicatorView.frame.size.width,
											  _activityIndicatorView.frame.size.height);
	
	[_activityIndicatorView startAnimating];
	
	_overlayView = [[UIView alloc] initWithFrame:self.view.frame];
	_overlayView.backgroundColor = [UIColor blackColor];
	
	_overlayView.alpha = 0.7;
	
	_progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	
	_progressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_progressLabel.backgroundColor = [UIColor clearColor];
	_progressLabel.font = [UIFont boldSystemFontOfSize:16.0];
	_progressLabel.textColor = [UIColor whiteColor];
	
	_computingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_computingLabel.backgroundColor = [UIColor clearColor];
	_computingLabel.font = [UIFont boldSystemFontOfSize:16.0];
	_computingLabel.textColor = [UIColor whiteColor];
    
    _computingLabel.alpha = 0.0;
	
	_progressView.frame = CGRectMake(floor((self.view.frame.size.width - _progressView.frame.size.width) / 2),
									 _progressLabel.frame.origin.y + _progressLabel.frame.size.height + kPadding,
									 _progressView.frame.size.width,
									 _progressView.frame.size.height);
	
	_progressView.alpha = 0.0;
	_progressLabel.alpha = 0.0;
	
	[self.view addSubview:_tableView];
	[self.view addSubview:_overlayView];
	[self.view addSubview:_activityIndicatorView];
	[self.view addSubview:_progressView];
	[self.view addSubview:_progressLabel];
	[self.view addSubview:_computingLabel];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [self showActivity:NO];
    [self showOverlay:NO];
    [self showProgress:NO];
    
	[UIView animateWithDuration:1.0
					 animations:^{ _tableView.alpha = 1.0; }];
    
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	
	[_products release];
	_products = [response.products retain];
    
    [_tableView reloadData];
    
    [_productsRequest release];
    _productsRequest = nil;
    
    [self processTransactions:[SKPaymentQueue defaultQueue].transactions];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Gallery Store";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self
                                                                                           action:@selector(cancel)] autorelease];
    
    [_galleriesRequest release];
    _galleriesRequest = [[CMTHTTPRequest requestWithPath:@"galleries"] retain];
    
    [_galleriesRequest setCompletionBlock:^{
        NSArray *galleries = [[_galleriesRequest responseString] JSONValue];
        NSMutableSet *productIdentifiers = [NSMutableSet setWithCapacity:galleries.count];
        
        for(NSDictionary *gallery in galleries)
            [productIdentifiers addObject:[[gallery valueForKey:@"gallery"] valueForKey:@"product_id"]];
        
        _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
        _productsRequest.delegate = self;
        [_productsRequest start];
    }];
    
    [_galleriesRequest setFailedBlock:^{
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Could Not Fetch Galleries"
                                                            message:[_galleriesRequest.error localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        
        [errorView show];
        [errorView release];
    }];
    
	[_galleriesRequest startAsynchronous];
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
	return [CMTProductTableViewCell height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _products.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMTProductTableViewCell *cell = (CMTProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CMTProductTableViewCell identifier]];
	
    if (cell == nil) {
        cell = [[[CMTProductTableViewCell alloc] initWithProduct:nil] autorelease];
		cell.delegate = self;
    }
    
    // Configure the cell...
	
	cell.product = [_products objectAtIndex:indexPath.row];
	
    return cell;
}

- (void)productTableViewCell:(CMTProductTableViewCell *)cell shouldPurchaseProduct:(SKProduct *)product {
	if([SKPaymentQueue canMakePayments]) {
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:product.productIdentifier];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Purchase Gallery"
															message:@"You disabled purchases from your system settings. If you want to purchase this item, you should enable In App Purchases."
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
		
		[alertView show];
		
		[alertView release];
	}
	
}

- (SKProduct *)productForIdentifier:(NSString *)productIdentifier {
	for(SKProduct *product in _products)
		if([product.productIdentifier isEqualToString:productIdentifier])
			return product;
	
	return nil;
}

- (void)deliveryFinished {
    [self showActivity:NO];
    [self showOverlay:NO];
    [self showProgress:NO];
    
    [_tableView reloadData];
    
    [self showComputing:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(object == _deliveringQueue && [keyPath isEqualToString:@"operationCount"]) {
        if(!_dismissed) {
            NSUInteger newOperationCount = [[change valueForKey:NSKeyValueChangeNewKey] unsignedIntegerValue];
            NSUInteger oldOperationCount = [[change valueForKey:NSKeyValueChangeOldKey] unsignedIntegerValue];
            
            if(oldOperationCount != newOperationCount && newOperationCount == 0) {
                [self performSelectorOnMainThread:@selector(deliveryFinished) withObject:nil waitUntilDone:YES];
            }
        }
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)productRequest:(CMTProductRequest *)request didUpdateProgress:(float)progress {
    _progressView.progress = progress;
}

- (void)productRequestDidFail:(CMTProductRequest *)request {
    _dismissed = YES;
    [_deliveringQueue cancelAllOperations];
    
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error Downloading Gallery"
                                                        message:[NSString stringWithFormat:@"A connection error occurred while downloading %@. Please try again.", request.product.localizedTitle]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    errorView.delegate = self;
    
    [errorView show];
    [errorView release];
    
}

- (void)productRequestDidStart:(CMTProductRequest *)request {
    [self showActivity:YES];
    [self showComputing:NO];
    [self showProgress:NO];
    [self showOverlay:YES];
}

- (void)productRequestDidStartDownloading:(CMTProductRequest *)request {
    _progressLabel.text = [NSString stringWithFormat:@"Downloading %@...", request.product.localizedTitle];
    [_progressLabel sizeToFit];
    
    _progressLabel.frame = CGRectMake(floor((self.view.frame.size.width - _progressLabel.frame.size.width) / 2),
									  floor((self.view.frame.size.height - (_progressLabel.frame.size.height + _progressView.frame.size.height + kPadding)) / 2),
									  _progressLabel.frame.size.width,
									  _progressLabel.frame.size.height);
    
	_progressView.frame = CGRectMake(floor((self.view.frame.size.width - _progressView.frame.size.width) / 2),
									 _progressLabel.frame.origin.y + _progressLabel.frame.size.height + kPadding,
									 _progressView.frame.size.width,
									 _progressView.frame.size.height);
    
    [self showProgress:YES];
    [self showActivity:NO];
    [self showComputing:NO];
}

- (void)productRequestDidStartInstalling:(CMTProductRequest *)request {
    _computingLabel.text = [NSString stringWithFormat:@"Installing %@...", request.product.localizedTitle];
    [_computingLabel sizeToFit];
    
    _computingLabel.frame = CGRectMake(floor((self.view.frame.size.width - _computingLabel.frame.size.width) / 2),
                                       floor((self.view.frame.size.height - _computingLabel.frame.size.height) / 2) - _activityIndicatorView.frame.size.height - 5 - kPadding,
                                       _computingLabel.frame.size.width,
                                       _computingLabel.frame.size.height);
    
    [self showActivity:YES];
    [self showProgress:NO];
    [self showComputing:YES];
}

- (void)processTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
			case SKPaymentTransactionStatePurchasing: {
                if(_deliveringQueue.operationCount == 0) {
                    [self showOverlay:YES];
                    [self showActivity:YES];
                }
                
				break;
			}
            case SKPaymentTransactionStateRestored:
            case SKPaymentTransactionStatePurchased: {
                BOOL alreadyProcessing = NO;
                
                for(CMTProductRequest *request in _deliveringQueue.operations)
                    if([request.product.productIdentifier isEqualToString:transaction.payment.productIdentifier])
                        alreadyProcessing = YES;
                
                if([[[NSUserDefaults standardUserDefaults] arrayForKey:CMTPurchasedProductsKey]
                    containsObject:transaction.payment.productIdentifier] || alreadyProcessing) {
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                    
                    break;
                }
                
                CMTProductRequest *request = [[CMTProductRequest alloc] initWithProduct:[self productForIdentifier:transaction.payment.productIdentifier]
                                                                            transaction:transaction];
                request.delegate = self;
                [_deliveringQueue addOperation:request];
                [request release];
                
                break;
			}
            case SKPaymentTransactionStateFailed: {
                if(_deliveringQueue.operationCount == 0) {
                    [self showOverlay:NO];
                    [self showActivity:NO];
                }
                
				if (transaction.error.code != SKErrorPaymentCancelled)
				{
					UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Transaction Failed"
																		message:transaction.error.localizedDescription
																	   delegate:nil
															  cancelButtonTitle:@"OK"
															  otherButtonTitles:nil];
					[alertView show];
					[alertView release];
				}
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                break;
			}
				
            default:
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    [self processTransactions:transactions];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
	 // ...
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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
    
    [_activityIndicatorView release];
    _activityIndicatorView = nil;
	[_tableView release];
    _tableView = nil;
	[_overlayView release];
    _overlayView = nil;
	[_progressView release];
    _progressView = nil;
	[_progressLabel release];
    _progressLabel = nil;
    [_computingLabel release];
    _computingLabel = nil;
}


- (void)dealloc {
    [_deliveringQueue removeObserver:self forKeyPath:@"operationCount"];
    
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
	
	[_activityIndicatorView release];
	[_tableView release];
	[_products release];
	[_overlayView release];
	[_progressView release];
	[_progressLabel release];
	[_deliveringQueue release];
	[_galleriesRequest release];
	[_productsRequest release];
    [_computingLabel release];
    
    [super dealloc];
}


@end

