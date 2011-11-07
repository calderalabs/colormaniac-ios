//
//  CMTLabel.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 03/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CMTLabel : UIView {
	UILabel *_label;
	UIColor *_textColor;
	UIImageView *_imageView;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, assign) CGFloat textSize;

- (id)initWithImage:(UIImage *)image;

- (void)setText:(NSString *)text animated:(BOOL)animated color:(UIColor *)color;
- (void)setText:(NSString *)text animated:(BOOL)animated;

@end
