//
//  CMTPictureView.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 21/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGBAColor.h"

#import "CMTPictureViewDelegate.h"

@class CMTPainting;

@interface CMTPictureView : UIView {
	RGBAColor *_originalPicture;
	RGBAColor *_grayscalePicture;
	
	UIImageView *_originalImageView;
	
	size_t _width;
	size_t _height;
	CGBitmapInfo _bitmapInfo;
	size_t _bytesPerRow;
	
	BOOL _shouldShowOriginalPicture;
	
	CADisplayLink *_colorizeLink;
	
    CGFloat *_colorizingComponents;
	NSArray *_colorizingColors;
	double _colorizingRow;
	unsigned int _colorizedPixels;
	
	id<CMTPictureViewDelegate> _delegate;
	
	CGDataProviderRef _grayscaleDataProvider;
	CGColorSpaceRef _colorSpace;
}

@property (nonatomic, assign) id<CMTPictureViewDelegate> delegate;
@property (nonatomic, readonly) size_t width;
@property (nonatomic, readonly) size_t height;
@property (nonatomic, readonly) unsigned int colorizedPixels;

- (id)initWithPainting:(CMTPainting *)painting;

- (void)colorizeWithColors:(NSArray *)colors;
- (void)showOriginalPictureWithDuration:(int)duration;

@end
