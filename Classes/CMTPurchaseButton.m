//
//  CMTPurchaseButton.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 05/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTPurchaseButton.h"
#import "CMTProductRequest.h"
#import <StoreKit/StoreKit.h>

static const CGFloat kPadding = 10.0;
static NSString *kConfirmTitle = @"PURCHASE";
static NSString *kDisabledTitle = @"PURCHASED";

@implementation CMTPurchaseButton

@synthesize product = _product;
@synthesize action = _action;
@synthesize target = _target;

- (UIImage *)confirmBackgroundImage {
	return [[UIImage imageNamed:@"purchaseButtonGreen.png"] stretchableImageWithLeftCapWidth:3
																				topCapHeight:3];
}

- (UIImage *)priceBackgroundImage {
	return [[UIImage imageNamed:@"purchaseButtonGray.png"] stretchableImageWithLeftCapWidth:3
																			   topCapHeight:3];
}

- (id)initWithProduct:(SKProduct *)product {
	if(self = [self initWithFrame:CGRectZero]) {
		self.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
		self.exclusiveTouch = YES;
		
		[self setTitle:kDisabledTitle forState:UIControlStateDisabled];
		[self setBackgroundImage:[self priceBackgroundImage] forState:UIControlStateDisabled];
		
		[self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
		
		self.product = product;
	}
	
	return self;
}

- (NSString *)priceTitle {
	NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:_product.priceLocale];
	
	return [numberFormatter stringFromNumber:_product.price];
}

@synthesize confirm = _confirm;

- (void)setProduct:(SKProduct *)product {
	[_product autorelease];
	_product = [product retain];
	
	if([[[NSUserDefaults standardUserDefaults] arrayForKey:CMTPurchasedProductsKey]
		containsObject:product.productIdentifier])
		self.enabled = NO;
	else
        self.enabled = YES;
    
	self.confirm = NO;
}

- (void)setConfirm:(BOOL)confirm {
	[self setConfirm:confirm animated:NO];
}

- (void)setConfirm:(BOOL)confirm animated:(BOOL)animated {
	NSString *oldTitle = _confirm ? [NSString stringWithString:kConfirmTitle] : [self priceTitle];
	NSString *newTitle = confirm ? [NSString stringWithString:kConfirmTitle] : [self priceTitle];
	UIImage *newImage = confirm ? [self confirmBackgroundImage] : [self priceBackgroundImage];
	
	CGFloat oldWidth = [oldTitle sizeWithFont:self.titleLabel.font].width + kPadding * 2;
	
	[self setTitle:newTitle forState:UIControlStateNormal];
	[self setBackgroundImage:newImage forState:UIControlStateNormal];
	
	CGFloat width = newTitle ? [newTitle sizeWithFont:self.titleLabel.font].width + kPadding * 2 : 0;
	CGFloat difference = width - oldWidth;
	
	CGRect frame = CGRectMake(self.frame.origin.x - difference,
							  self.frame.origin.y,
							  self.frame.size.width + difference,
							  self.frame.size.height);
	
	if(animated)
		[UIView animateWithDuration:0.5
							  delay:0
							options:UIViewAnimationOptionLayoutSubviews
						 animations:^{
							 self.frame = frame;
						 }
						 completion:nil];
	else
		self.frame = frame;
	
	_confirm = confirm;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)touchUpInside {
	if(_confirm) {
		if([_target respondsToSelector:_action])
			[_target performSelector:_action withObject:self];
	}
	else
		[self setConfirm:YES animated:YES];
}

- (CGSize)sizeThatFits:(CGSize)size {
	NSString *currentTitle = _confirm ? kConfirmTitle : [self priceTitle];
	
	CGSize fitSize = [currentTitle sizeWithFont:self.titleLabel.font];
	fitSize.width += kPadding * 2;
	fitSize.height = 25.0;
	
	return fitSize;
}

- (void)dealloc {
	[_product release];
	
    [super dealloc];
}


@end
