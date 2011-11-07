//
//  CMTPaintingTableViewCell.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 02/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTTableViewCell.h"

@class CMTPainting;

@interface CMTPaintingTableViewCell : CMTTableViewCell {
	CMTPainting *_painting;
	UIImageView *_previewImageView;
	UILabel *_titleLabel;
	UILabel *_authorLabel;
	UILabel *_scoreLabel;
    UILabel *_difficultyLabel;
    UIImageView *_medalView;
    UIButton *_saveButton;
    UIActivityIndicatorView *_activityView;
    UIButton *_overlayButton;
    
    BOOL _saving;
}

- (id)initWithPainting:(CMTPainting *)painting;

@property (nonatomic, retain) CMTPainting *painting;
@property (nonatomic, assign) BOOL saving;

@end
