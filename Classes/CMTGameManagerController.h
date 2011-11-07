//
//  CMTGameManagerController.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 02/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMTGameController;
@class CMTPainting;

@interface CMTGameManagerController : UIViewController {
	CMTGameController *_currentGameController;
	
	NSArray *_paintings;
}

- (id)initWithPaintings:(NSArray *)paintings startingIndex:(NSUInteger)index;

- (void)playPainting:(CMTPainting *)painting;
- (CMTPainting *)nextPainting;

@end
