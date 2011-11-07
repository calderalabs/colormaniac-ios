//
//  CMTProductRequestDelegate.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 31/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMTProductRequest;

@protocol CMTProductRequestDelegate <NSObject>

- (void)productRequestDidStart:(CMTProductRequest *)request;
- (void)productRequestDidStartDownloading:(CMTProductRequest *)request;
- (void)productRequestDidStartInstalling:(CMTProductRequest *)request;
- (void)productRequestDidFail:(CMTProductRequest *)request;
- (void)productRequest:(CMTProductRequest *)request didUpdateProgress:(float)progress;

@end
