//
//  CMTPaletteView.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 21/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTPaletteView.h"
#import "CMTPalette.h"

@implementation CMTPaletteView

@synthesize colors = _colors;

- (void)setEnabled:(BOOL)enabled {
	[super setEnabled:enabled];
	
	[UIView animateWithDuration:1.0
					 animations:^{self.alpha = enabled ? 1.0 : 0.0;}];
}

- (id)initWithFrame:(CGRect)frame
			 color1:(int)color1 
			 color2:(int)color2
			 color3:(int)color3
			 color4:(int)color4 {
    self = [super initWithFrame:frame];
	
	if(self) {
		CMTPalette *palette = [CMTPalette sharedPalette];
		
		_colors = [[NSArray alloc] initWithObjects:
				   [palette colorAtIndex:color1],
				   [palette colorAtIndex:color2],
				   [palette colorAtIndex:color3],
				   [palette colorAtIndex:color4], nil];
		
		self.exclusiveTouch = YES;
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGContextRef currentContext = UIGraphicsGetCurrentContext();

	CGSize colorSize = CGSizeMake(rect.size.width / 2, rect.size.height / 2);
	
	for(int i = 0; i < 4; i++) {
		UIColor *color = [_colors objectAtIndex:i];
		
		CGContextSetFillColorWithColor(currentContext, [color CGColor]);
		
		CGContextFillRect(currentContext, CGRectMake((i % 2) * colorSize.width,
													 (i / 2) * colorSize.height,
													 colorSize.width, colorSize.height));
		
	}
	
	CGColorRef strokeColor = [UIColor blackColor].CGColor;
	
	CGContextSetStrokeColorWithColor(currentContext, strokeColor);
	CGContextStrokeRectWithWidth(currentContext, CGRectMake(1,
												   1,
												   rect.size.width - 1, rect.size.height - 1), 2);
	
	if(self.touchInside) {
		CGColorRef strokeColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
		
		CGContextSetFillColorWithColor(currentContext, strokeColor);
		
		CGContextFillRect(currentContext, CGRectMake(0,
													 0,
													 rect.size.width, rect.size.height));
		
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	[self setNeedsDisplay];
}

- (void)dealloc {
	[_colors release];
	
    [super dealloc];
}


@end
