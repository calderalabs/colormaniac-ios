//
//  CMTProductRequest.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 31/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMTProductRequestDelegate.h"

@class SKProduct;
@class SKPaymentTransaction;
@class ASINetworkQueue;
@class CMTHTTPRequest;

NSString *CMTPurchasedProductsKey;

@interface CMTProductRequest : NSOperation {
    id<CMTProductRequestDelegate> _delegate;
    
    BOOL _executing;
    BOOL _finished;
    
    SKProduct *_product;
    SKPaymentTransaction *_transaction;
    
    ASINetworkQueue *_downloadQueue;
    CMTHTTPRequest *_detailsRequest;
    NSBlockOperation *_computeOperation;
}

- (id)initWithProduct:(SKProduct *)product transaction:(SKPaymentTransaction *)transaction;

@property (nonatomic, assign) id<CMTProductRequestDelegate> delegate;
@property (nonatomic, readonly) SKProduct *product;

@end
