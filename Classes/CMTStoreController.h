//
//  CMTStoreController.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 04/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "CMTProductTableViewCellDelegate.h"
#import "CMTViewController.h"
#import "CMTProductRequestDelegate.h"

@class CMTGallery;
@class SKProductsRequest;
@class CMTHTTPRequest;

@interface CMTStoreController : CMTViewController
<
UIAlertViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
SKProductsRequestDelegate,
CMTProductTableViewCellDelegate,
SKPaymentTransactionObserver,
CMTProductRequestDelegate
>
{
    BOOL _dismissed;
    
	UITableView *_tableView;
	UIActivityIndicatorView *_activityIndicatorView;
	UIView *_overlayView;
	
	NSArray *_products;
	UIProgressView *_progressView;
	UILabel *_progressLabel;

    CMTHTTPRequest *_galleriesRequest;
	SKProductsRequest *_productsRequest;
    
    UILabel *_computingLabel;
    
    NSOperationQueue *_deliveringQueue;
}

@end
