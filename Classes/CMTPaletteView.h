//
//  CMTPaletteView.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 21/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

@interface CMTPaletteView : UIControl {
	NSArray *_colors;
}

- (id)initWithFrame:(CGRect)frame
			 color1:(int)color1 
			 color2:(int)color2
			 color3:(int)color3
			 color4:(int)color4;

@property (nonatomic, readonly) NSArray *colors;

@end
