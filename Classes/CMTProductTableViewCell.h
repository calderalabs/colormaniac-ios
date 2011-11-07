//
//  CMTProductTableViewCell.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 05/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "CMTTableViewCell.h"
#import "CMTProductTableViewCellDelegate.h"

@class CMTPurchaseButton;
@class SKProduct;
@class CAGradientLayer;
@class CMTHTTPRequest;

@interface CMTProductTableViewCell : CMTTableViewCell {
	id<CMTProductTableViewCellDelegate> _delegate;
	
	SKProduct *_product;
	CMTPurchaseButton *_purchaseButton;
	
	UIImageView *_previewImageView;
	UIActivityIndicatorView *_previewImageActivityView;
	UILabel *_nameLabel;
	UILabel *_descriptionLabel;
	UIView *_detailsView;
	CAGradientLayer *_detailsLayer;
	CMTHTTPRequest *_thumbnailRequest;
}

- (id)initWithProduct:(SKProduct *)product;

@property (nonatomic, assign) id<CMTProductTableViewCellDelegate> delegate;
@property (nonatomic, retain) SKProduct *product;

@end
