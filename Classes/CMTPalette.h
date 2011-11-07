//
//  CMTPalette.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 21/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int kNumColors = 64;

@interface CMTPalette : NSObject {
	NSMutableArray *_colors;
    CGFloat *_components;
}

+ (CMTPalette *)sharedPalette;

- (UIColor *)colorAtIndex:(int)index;

@property (nonatomic, readonly) CGFloat *components;

@end
