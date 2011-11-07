//
//  CMTPaintingsControllerDelegate.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 04/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMTPaintingsController;
@class CMTPainting;

@protocol CMTPaintingsControllerDelegate <NSObject>

@optional

- (void)paintingsController:(CMTPaintingsController *)paintingsController didSelectPaintingAtIndex:(NSUInteger)paintingIndex;

@end
