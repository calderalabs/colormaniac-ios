//
//  CMTActionListView.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 03/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMTButton;

@interface CMTActionListView : UIView {
	NSMutableArray *_buttons;
}

- (id)initWithButtons:(NSArray *)buttons;
- (void)addButton:(CMTButton *)button;
- (void)removeButton:(CMTButton *)button;

@end
