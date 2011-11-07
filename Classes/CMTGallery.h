//
//  CMTGallery.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 28/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMTGallery : NSObject <NSCoding> {
	NSMutableArray *_paintings;
	NSString *_name;
    NSString *_description;
}

@property (nonatomic, retain) NSMutableArray *paintings;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;

+ (CMTGallery *)galleryWithName:(NSString *)name
                    description:(NSString *)description
					  paintings:(NSArray *)paintings;

- (void)computeColorsSynchronously;
- (NSBlockOperation *)computeColorsWithCompletion:(void (^)(void))completionBlock;

@end
