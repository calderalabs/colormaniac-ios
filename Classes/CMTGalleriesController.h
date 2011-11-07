//
//  CMTGalleriesController.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 28/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTViewController.h"
#import "CMTPaintingsControllerDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface CMTGalleriesController : CMTViewController <UIPopoverControllerDelegate, CMTPaintingsControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
    UIButton *_buyMoreButton;
    UITableView *_tableView;
}

@end
