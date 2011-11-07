//
//  CMTButton.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 18/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTButton.h"
#import "CMTSoundManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation CMTButton

- (void)setTextSize:(CGFloat)textSize {
    _button.titleLabel.font = [UIFont labelFontOfSize:textSize];
}

- (CGFloat)textSize {
	return _button.titleLabel.font.pointSize;
}

- (void)setTextColor:(UIColor *)color {
    [_button setTitleColor:color forState:UIControlStateNormal];
}

- (UIColor *)textColor {
    return [_button titleColorForState:UIControlStateNormal];
}

+ (CMTButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
	return [[[self alloc] initWithTitle:title target:target action:action] autorelease];
}

- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action {
	if(self = [self initWithFrame:CGRectZero]) {
		_button = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        
		[_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_button.titleLabel.font = [UIFont labelFontOfSize:30];
        
		[_button setTitle:title forState:UIControlStateNormal];
		[_button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
		
		[_button addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:_button];
	}
	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	_button.frame = self.bounds;
}

- (CGSize)sizeThatFits:(CGSize)size {
	return [_button sizeThatFits:size];
}

- (void)touchUpInside {
	[[CMTSoundManager sharedManager] playSoundEffect:@"click"];
}

- (void)dealloc {
	[_button release];
	
	[super dealloc];
}

@end
