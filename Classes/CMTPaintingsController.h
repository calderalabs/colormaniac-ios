//
//  CMTPaintingsController.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 02/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTPaintingsControllerDelegate.h"

@interface CMTPaintingsController : UITableViewController {
	id<CMTPaintingsControllerDelegate> _delegate;
	NSArray *_paintings;
}

@property (nonatomic, assign) id<CMTPaintingsControllerDelegate> delegate;
@property (nonatomic, readonly, retain) NSArray *paintings;

- (id)initWithPaintings:(NSArray *)paintings;

@end
