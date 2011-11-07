//
//  CMTGalleryManager.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 28/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMTGallery;

@interface CMTGalleryManager : NSObject {
	NSMutableArray *_galleries;
}

+ (CMTGalleryManager *)sharedManager;

- (NSBlockOperation *)addGallery:(CMTGallery *)gallery completion:(void (^)(void))completion;

- (void)reloadFromDisk;
- (BOOL)saveToDisk;

@property (nonatomic, readonly) NSString *archivePath;
@property (nonatomic, readonly) NSString *resourcePath;
@property (nonatomic, readonly) NSArray *galleries;

@end
