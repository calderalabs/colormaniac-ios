//
//  CMTGalleryTableViewCell.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 28/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CMTTableViewCell.h"

@class CMTGallery;
@class CMTActionListView;

@interface CMTGalleryTableViewCell : CMTTableViewCell {
	CMTGallery *_gallery;
	UIView *_detailsView;
	CAGradientLayer *_detailsLayer;
	UILabel *_nameLabel;
    UILabel *_descriptionLabel;
	UIImageView *_previewImageView;
}

@property (nonatomic, retain) CMTGallery *gallery;

- (id)initWithGallery:(CMTGallery *)gallery;

@end
