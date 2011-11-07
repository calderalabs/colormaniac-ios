//
//  CMTPaletteBarViewDelegate.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 23/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMTPaletteBarView;
@class CMTPaletteView;

@protocol CMTPaletteBarViewDelegate <NSObject>

@optional

- (void)paletteBarView:(CMTPaletteBarView *)paletteBarView didChoosePaletteView:(CMTPaletteView *)paletteView;

@end
