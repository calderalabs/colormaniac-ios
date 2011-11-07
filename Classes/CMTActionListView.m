//
//  CMTActionListView.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 03/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTActionListView.h"
#import "CMTButton.h"

static const CGFloat kPadding = 8.0;

@implementation CMTActionListView

- (id)initWithButtons:(NSArray *)buttons {
	if(self = [super initWithFrame:CGRectZero]) {
		_buttons = [[NSMutableArray alloc] initWithCapacity:buttons.count];
		
		for(CMTButton *button in buttons)
			[self addButton:button];
	}
	
	return self;
}

- (void)addButton:(CMTButton *)button {
	[_buttons addObject:button];
	[self addSubview:button];
	
	[self setNeedsLayout];
}

- (void)removeButton:(CMTButton *)button {
	[_buttons removeObject:button];
	[button removeFromSuperview];
	
	[self setNeedsLayout];
}

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithButtons:nil];
	
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGSize size = CGSizeMake(self.frame.size.width, (self.frame.size.height - (kPadding * (_buttons.count - 1))) / _buttons.count);
    
	CGFloat y = 0;
	
	for(CMTButton *button in _buttons) {
		button.frame = CGRectMake(0, floor(y), size.width, size.height);
        [button setNeedsLayout];
		y += size.height + kPadding;
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[_buttons release];
	
    [super dealloc];
}


@end
