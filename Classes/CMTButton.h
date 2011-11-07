//
//  CMTButton.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 18/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CMTButton : UIView {
	UIButton *_button;
}

@property (nonatomic, assign) CGFloat textSize;
@property (nonatomic, retain) UIColor *textColor;

+ (CMTButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
