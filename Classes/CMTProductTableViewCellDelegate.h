//
//  CMTProductTableViewCellDelegate.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 06/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMTProductTableViewCell;
@class SKProduct;

@protocol CMTProductTableViewCellDelegate <NSObject>

@optional
- (void)productTableViewCell:(CMTProductTableViewCell *)cell shouldPurchaseProduct:(SKProduct *)product;

@end
