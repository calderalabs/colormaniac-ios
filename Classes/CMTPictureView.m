//
//  CMTPictureView.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 21/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTPictureView.h"
#import "CMTPainting.h"

#import <QuartzCore/QuartzCore.h>

@implementation CMTPictureView

@synthesize delegate = _delegate;
@synthesize width = _width;
@synthesize height = _height;
@synthesize colorizedPixels = _colorizedPixels;

static const CGFloat kColorizingDuration = 4.0;
static const CGBitmapInfo kBitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
static const size_t kBitsPerComponent = 8;
static const size_t kBitsPerPixel = 8 * 4;

- (id)initWithPainting:(CMTPainting *)painting {
	if(self = [super initWithFrame:CGRectZero]) {
        CGImageRef image = [UIImage imageWithContentsOfFile:painting.fullPicturePath].CGImage;
        
        _width = CGImageGetWidth(image);
        _height = CGImageGetHeight(image);
        
		_originalImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:image]];
		_originalImageView.alpha = 0.0;
		
		[self addSubview:_originalImageView];
		
		_bytesPerRow = _width * 4;
		
		_originalPicture = malloc(_height * _width * sizeof(RGBAColor));
		_grayscalePicture = malloc(_height * _width * sizeof(RGBAColor));
		
		_grayscaleDataProvider = CGDataProviderCreateWithData(NULL,
															  _grayscalePicture,
															  _bytesPerRow * _height,
															  NULL);
		
		_colorSpace = CGColorSpaceCreateDeviceRGB();
		
		CGRect pictureRect = CGRectMake(0, 0, _width, _height);
        
		CGContextRef pictureContext = CGBitmapContextCreate(_originalPicture,
															pictureRect.size.width,
															pictureRect.size.height,
															kBitsPerComponent,
															_bytesPerRow,
															_colorSpace,
															kBitmapInfo);
		
		CGContextDrawImage(pictureContext, pictureRect, image);
		
		CGContextRelease(pictureContext);
		
		for(int i = 0; i < _height * _width; i++) {
			uint8_t average = (_originalPicture[i].red + _originalPicture[i].green + _originalPicture[i].blue) / 3;
			
			_grayscalePicture[i].red = _grayscalePicture[i].green = _grayscalePicture[i].blue = average;
			_grayscalePicture[i].alpha = 0xff;
		}
	}
	
	return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [_originalImageView sizeThatFits:size];
}

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithPainting:nil];
    return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
	CGImageRef grayscaleImage = CGImageCreate(_width,
											  _height,
											  kBitsPerComponent,
											  kBitsPerPixel, 
											  _bytesPerRow,
											  _colorSpace,
											  _bitmapInfo,
											  _grayscaleDataProvider,
											  NULL,
											  true,
											  kCGRenderingIntentDefault);
	
	CGRect imageRect = CGRectMake(0,
								  0,
								  _width,
								  _height);
	
	UIImage *orientationGrayscaleImage = [UIImage imageWithCGImage:grayscaleImage];
	
	[orientationGrayscaleImage drawInRect:imageRect];
	
	CGImageRelease(grayscaleImage);
	
	if(_colorizeLink) {
		CGContextSetStrokeColorWithColor(currentContext, [UIColor whiteColor].CGColor);
		
		CGPoint line[2] = {
			CGPointMake(0, _colorizingRow),
			CGPointMake(_width, _colorizingRow)
		};
		
		CGContextStrokeLineSegments(currentContext, line, 2);
	}
}

- (void)colorizeWithColors:(NSArray *)colors {
	if(!_colorizeLink) {
		_colorizingColors = [colors retain];
		_colorizingRow = 0;
		
        free(_colorizingComponents);
        _colorizingComponents = malloc(sizeof(CGFloat) * 3 * _colorizingColors.count);
        
        for(int i = 0; i < _colorizingColors.count; i++) {
            UIColor *color = [_colorizingColors objectAtIndex:i];
            
            const CGFloat *components = CGColorGetComponents(color.CGColor);
            
            for(int j = 0; j < 3; j++)
                _colorizingComponents[i * 3 + j] = components[j] * 255.0;
        }
        
		_colorizeLink = [[CADisplayLink displayLinkWithTarget:self selector:@selector(colorizeNextRow)] retain];
		_colorizeLink.frameInterval = 2;
		[_colorizeLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	}
}

- (void)colorizeNextRow {
	double numRows = _colorizeLink.frameInterval * (_height / kColorizingDuration) *_colorizeLink.duration;
	
    int rowsPixels = floor(_colorizingRow + numRows) * _width;
    size_t numPixels = _height * _width;
    
    if(rowsPixels > numPixels)
        rowsPixels = numPixels;
    
	for(int j = floor(_colorizingRow) * _width; j < rowsPixels; j++) {
        for(int i = 0; i < _colorizingColors.count * 3; i += 3) {
				RGBAColor originalColor = _originalPicture[j];
				
				if(originalColor.red >= _colorizingComponents[i] && originalColor.red < _colorizingComponents[i] + 64 &&
				   originalColor.green >= _colorizingComponents[i + 1] && originalColor.green < _colorizingComponents[i + 1] + 64 &&
				   originalColor.blue >= _colorizingComponents[i + 2] && originalColor.blue < _colorizingComponents[i + 2] + 64) {
					RGBAColor *destination = &_grayscalePicture[j];
					RGBAColor *source = &originalColor;
					
					memcpy((void *)destination, (void *)source, sizeof(RGBAColor));
					
					_colorizedPixels++;
					
					break;
				}
			}
	}
    
	[self setNeedsDisplay];
	
	_colorizingRow += numRows;
	
	if([_delegate respondsToSelector:@selector(pictureView:didFinishColorizingRowWithColors:)])
		[_delegate pictureView:self didFinishColorizingRowWithColors:_colorizingColors];
	
	if(_colorizingRow >= _height) {
		[_colorizingColors release];
		_colorizingColors = nil;
		[_colorizeLink invalidate];
		[_colorizeLink release];
		_colorizeLink = nil;
		free(_colorizingComponents);
        _colorizingComponents = NULL;
        
		if([_delegate respondsToSelector:@selector(pictureView:didFinishColorizingWithColors:)])
			[_delegate pictureView:self didFinishColorizingWithColors:_colorizingColors];
	}
}

- (void)showOriginalPictureWithDuration:(int)duration {
	[UIView animateWithDuration:1.0 animations:^{_originalImageView.alpha = 1.0;}
					 completion:^(BOOL finished){
						 [NSTimer scheduledTimerWithTimeInterval:duration
														  target:self
														selector:@selector(didFinishShowingOriginalPicture:)
														userInfo:nil
														 repeats:NO];
						 
						 if([_delegate respondsToSelector:@selector(pictureViewDidStartShowingOriginalPicture:)])
							 [_delegate pictureViewDidStartShowingOriginalPicture:self];
					 }];
}

- (void)didFinishShowingOriginalPicture:(NSTimer *)timer {
	[UIView animateWithDuration:1.0 animations:^{_originalImageView.alpha = 0.0;}];
}

- (void)dealloc {
	[_colorizeLink invalidate];
	[_colorizeLink release];
	[_colorizingColors release];
	[_originalImageView release];
	
	CGDataProviderRelease(_grayscaleDataProvider);
	CGColorSpaceRelease(_colorSpace);
	
	free(_originalPicture);
	free(_grayscalePicture);
    free(_colorizingComponents);
    
    [super dealloc];
}


@end
