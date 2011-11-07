//
//  CMTPaletteBarView.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 23/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTPaletteBarView.h"
#import "CMTPaletteView.h"
#import "CMTSoundManager.h"
#import "CMTPalette.h"

static const int kNumPalettes = 8;
static const CGFloat kPaletteSize = 96.0;

@implementation CMTPaletteBarView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
	self = [self initWithType:CMTPaletteBarViewTypeFirst];
	
	return self;
}

- (id)initWithType:(CMTPaletteBarViewType)type {
    self = [super initWithFrame:CGRectMake(self.frame.origin.x,
										   self.frame.origin.y,
										   kPaletteSize,
										   kPaletteSize * kNumPalettes)];
    if (self) {
		int offset = (type == CMTPaletteBarViewTypeFirst) ? 0 : 32;
		
		for(int i = 0; i < kNumPalettes; i++) {
			int firstIndex = i * 4 + offset;
			
			CMTPaletteView *paletteView = [[CMTPaletteView alloc] initWithFrame:CGRectZero
																		 color1:firstIndex
																		 color2:firstIndex + 1
																		 color3:firstIndex + 2
																		 color4:firstIndex + 3];
			
			[paletteView addTarget:self action:@selector(paletteTapped:) forControlEvents:UIControlEventTouchUpInside];
			
			[self addSubview:paletteView];
			[paletteView release];
		}
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	for(int i = 0; i < self.subviews.count; i++) {
		CMTPaletteView *paletteView = [self.subviews objectAtIndex:i];
		
		paletteView.frame = CGRectMake(0,
									   i * kPaletteSize,
									   kPaletteSize,
									   kPaletteSize);
		
	}
}

- (void)paletteTapped:(CMTPaletteView *)sender {
	sender.enabled = NO;
	
	[[CMTSoundManager sharedManager] playSoundEffect:@"click"];
	
	if([_delegate respondsToSelector:@selector(paletteBarView:didChoosePaletteView:)])
		[_delegate paletteBarView:self didChoosePaletteView:sender];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc {
    [super dealloc];
}


@end
