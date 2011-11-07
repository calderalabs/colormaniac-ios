//
//  CMTPictureViewDelegate.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 22/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMTPictureView;

@protocol CMTPictureViewDelegate <NSObject>

@optional

- (void)pictureView:(CMTPictureView *)pictureView didFinishColorizingWithColors:(NSArray *)colors;
- (void)pictureView:(CMTPictureView *)pictureView didFinishColorizingRowWithColors:(NSArray *)colors;
- (void)pictureViewDidStartShowingOriginalPicture:(CMTPictureView *)pictureView;

@end
