//
//  CMTPaletteBarView.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 23/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTPaletteBarViewDelegate.h"

typedef enum {
	CMTPaletteBarViewTypeFirst,
	CMTPaletteBarViewTypeSecond
} CMTPaletteBarViewType;

@interface CMTPaletteBarView : UIView {
	id<CMTPaletteBarViewDelegate> _delegate;
}

@property (nonatomic, assign) id<CMTPaletteBarViewDelegate> delegate;

- (id)initWithType:(CMTPaletteBarViewType)type;

@end
