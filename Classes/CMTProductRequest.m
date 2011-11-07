//
//  CMTProductRequest.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 31/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTProductRequest.h"
#import "CMTHTTPRequest.h"
#import "CMTPainting.h"
#import "CMTGallery.h"
#import "ASINetworkQueue.h"
#import "CMTGalleryManager.h"
#import "JSON.h"

#import <StoreKit/StoreKit.h>

NSString *CMTPurchasedProductsKey = @"kPurchasedProductsKey";

@implementation CMTProductRequest

@synthesize delegate = _delegate;
@synthesize  product = _product;

- (void)setProgress:(float)progress {
    if([_delegate respondsToSelector:@selector(productRequest:didUpdateProgress:)])
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate productRequest:self didUpdateProgress:progress];
        });
    
}

- (id)initWithProduct:(SKProduct *)product transaction:(SKPaymentTransaction *)transaction {
    self = [super init];
    
    if (self) {
        _product = [product retain];
        _transaction = [transaction retain];
        _downloadQueue = [[ASINetworkQueue alloc] init];
        _downloadQueue.delegate = self;
        _downloadQueue.requestDidFailSelector = @selector(didFailRequest:);
        [_downloadQueue setDownloadProgressDelegate:self];
        [_downloadQueue setQueueDidFinishSelector:@selector(didDownloadProduct:)];
    }
    
    return self;
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (void)start {
    if ([self isCancelled])
    {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)main {
    @try {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
        _detailsRequest = [[CMTHTTPRequest requestWithPath:[NSString stringWithFormat:@"galleries/%d/paintings",
                                                            [_product.productIdentifier integerValue]]] retain];
        
        [_detailsRequest setCompletionBlock:^{
            NSArray *paintings = [[_detailsRequest responseString] JSONValue];
            
            NSMutableArray *galleryPaintings = [NSMutableArray arrayWithCapacity:paintings.count];
            
            for(NSDictionary *painting in paintings) {
                NSDictionary *paintingAttributes = [painting valueForKey:@"painting"];
                
                NSString *paintingId = [[paintingAttributes valueForKey:@"id"] stringValue];
                NSString *downloadPath = [NSString stringWithFormat:@"paintings/%@/download", paintingId];
                
                NSString *picturePath = [NSString stringWithString:paintingId];
                NSString *thumbnailPath = [picturePath stringByAppendingPathExtension:@"thumb"];
                
                CMTPainting *galleryPainting = [CMTPainting paintingWithTitle:[paintingAttributes valueForKey:@"title"]
                                                                       author:[paintingAttributes valueForKey:@"author"]
                                                                      bundled:NO
                                                                  picturePath:picturePath
                                                                thumbnailPath:thumbnailPath];
                
                CMTHTTPRequest *pictureRequest = [CMTHTTPRequest requestWithPath:downloadPath parameters:@"style=normal" format:nil];
                pictureRequest.allowResumeForFileDownloads = YES;
                
                [pictureRequest setDownloadDestinationPath:galleryPainting.fullPicturePath];
                
                CMTHTTPRequest *thumbnailRequest = [CMTHTTPRequest requestWithPath:downloadPath parameters:@"style=thumb" format:nil];
                thumbnailRequest.allowResumeForFileDownloads = YES;
                [thumbnailRequest setDownloadDestinationPath:galleryPainting.fullThumbnailPath];
                
                [_downloadQueue addOperation:pictureRequest];
                [_downloadQueue addOperation:thumbnailRequest];
                
                [galleryPaintings addObject:galleryPainting];
                
                _downloadQueue.userInfo = [NSDictionary dictionaryWithObject:[CMTGallery galleryWithName:_product.localizedTitle
                                                                                             description:_product.localizedDescription
                                                                                               paintings:galleryPaintings] forKey:@"gallery"];
            }
            
            if([_delegate respondsToSelector:@selector(productRequest:didUpdateProgress:)])
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate productRequest:self didUpdateProgress:0.0];
                });
            
            
            [_downloadQueue go];
            
            if([_delegate respondsToSelector:@selector(productRequestDidStartDownloading:)])
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate productRequestDidStartDownloading:self];
                });
        }];
        
        _detailsRequest.didFailSelector = @selector(didFailRequest:);
        
        if([_delegate respondsToSelector:@selector(productRequestDidStart:)])
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate productRequestDidStart:self];
            });
        
        [_detailsRequest startAsynchronous];
        
        while(!_finished)
            if([self isCancelled]) {
                [_downloadQueue reset];
                [_detailsRequest clearDelegatesAndCancel];
                [_computeOperation cancel];
                
                [self completeOperation];
            }
        
        [pool release];
    }
    @catch(...) {
        
    }
}

- (void)didFailRequest:(CMTHTTPRequest *)request {
    [_downloadQueue reset];
    [self completeOperation];
    
    if([_delegate respondsToSelector:@selector(productRequestDidFail:)])
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate productRequestDidFail:self];
        });
}

- (void)didDownloadProduct:(ASINetworkQueue *)queue {
    CMTGallery *gallery = [queue.userInfo objectForKey:@"gallery"];
    
    if([_delegate respondsToSelector:@selector(productRequestDidStartInstalling:)])
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate productRequestDidStartInstalling:self];
        });
    
    _computeOperation = [[[CMTGalleryManager sharedManager] addGallery:gallery completion:^{
        NSMutableArray *purchasedProducts = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:CMTPurchasedProductsKey]];
        [purchasedProducts addObject:_transaction.payment.productIdentifier];
        
        [[NSUserDefaults standardUserDefaults] setObject:purchasedProducts forKey:CMTPurchasedProductsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self completeOperation];
        
        [[SKPaymentQueue defaultQueue] finishTransaction:_transaction];
    }] retain];
}

- (void)dealloc {
    [_product release];
    [_transaction release];
    [_detailsRequest release];
    [_downloadQueue release];
    [_computeOperation release];
    
    [super dealloc];
}

@end
