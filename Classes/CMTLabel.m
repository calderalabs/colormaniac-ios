//
//  CMTLabel.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 03/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTLabel.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kPadding = 10.0;

@implementation CMTLabel

@synthesize textColor = _textColor;

- (void)setTextColor:(UIColor *)textColor {
	_label.textColor = textColor;
	
	_textColor = textColor;
}

- (void)setTextSize:(CGFloat)textSize {
	_label.font = [UIFont labelFontOfSize:textSize];
}

- (CGFloat)textSize {
	return _label.font.lineHeight;
}

- (NSString *)text {
	return _label.text;
}

- (id)initWithImage:(UIImage *)image {
	if(self = [super initWithFrame:CGRectZero]) {
		_imageView = [[UIImageView alloc] initWithImage:image];
		[_imageView sizeToFit];
		
		_label = [[UILabel alloc] initWithFrame:CGRectZero];
		_label.backgroundColor = [UIColor clearColor];
		
		self.textColor = [UIColor whiteColor];

		_label.layer.shadowOpacity = 1.0;   
		_label.layer.shadowRadius = 2.0;
		_label.layer.shadowColor = [UIColor blackColor].CGColor;
		_label.layer.shadowOffset = CGSizeMake(0.0, 0.0);

		[self addSubview:_imageView];
		[self addSubview:_label];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithImage:nil];
    
	return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize labelSize = [_label sizeThatFits:size];
    
    labelSize.width += 4;
    labelSize.height += 4;
    
	return _imageView.image ? CGSizeMake(_imageView.frame.size.width + kPadding + labelSize.width,
                                         fmax(labelSize.height, _imageView.frame.size.height)) : labelSize;
}

- (void)setText:(NSString *)text animated:(BOOL)animated color:(UIColor *)color {
	[_label setText:text];

	if(animated) {
		CGAffineTransform transform = CGAffineTransformMakeScale(2.0, 2.0);
		
		_label.layer.affineTransform = transform;
		_label.textColor = color;
		
		[UIView animateWithDuration:1.0
							  delay:0
							options:UIViewAnimationOptionAllowUserInteraction
						 animations:^{
							 _label.layer.affineTransform = CGAffineTransformIdentity;
						 }
						 completion:^(BOOL finished) {
							 if(finished)
								 _label.textColor = _textColor;
						 }];
		
	}
}

- (void)setText:(NSString *)text animated:(BOOL)animated {
	[self setText:text animated:animated color:_label.textColor];
}

- (void)setText:(NSString *)text {
	[self setText:text animated:NO];
}	

- (void)layoutSubviews {
	[super layoutSubviews];
	
	_imageView.frame = CGRectMake(0,
								  floor((self.frame.size.height - _imageView.frame.size.height) / 2),
								  _imageView.frame.size.width,
								  _imageView.frame.size.height);
	
	_label.frame = CGRectMake(_imageView.image ? (_imageView.frame.size.width + kPadding + _imageView.frame.origin.x) : 0,
							  0,
							  self.frame.size.width - (_imageView.image ? (_imageView.frame.size.width - kPadding - _imageView.frame.origin.x) : 0),
							  self.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[_imageView release];
	[_label release];
	
    [super dealloc];
}


@end
