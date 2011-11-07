//
//  CMTGalleryTableViewCell.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 28/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTGalleryTableViewCell.h"
#import "CMTGallery.h"
#import "CMTPainting.h"
#import "CMTActionListView.h"
#import "CMTButton.h"

static const CGFloat kPadding = 15.0;
static const CGFloat kPreviewImageSize = 130.0;

@implementation CMTGalleryTableViewCell

@synthesize gallery = _gallery;

+ (CGFloat)height {
	return 150.0;
}

- (void)setGallery:(CMTGallery *)gallery {
	[_gallery autorelease];
	
	_gallery = [gallery retain];
	
	_nameLabel.text = _gallery.name;
	[_nameLabel sizeToFit];
	
    _descriptionLabel.text = _gallery.description;
    [_descriptionLabel sizeToFit];
    
	CMTPainting *firstPainting = [gallery.paintings objectAtIndex:0];
	
	_previewImageView.image = [UIImage imageWithContentsOfFile:firstPainting.fullThumbnailPath];
	[_previewImageView sizeToFit];
	
	[self setNeedsLayout];
}

- (id)initWithGallery:(CMTGallery *)gallery {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self.class identifier]];
	
    if (self) {
		_detailsView = [[UIView alloc] initWithFrame:CGRectZero];
		_detailsLayer = [[CAGradientLayer layer] retain];
		
		[_detailsView.layer insertSublayer:_detailsLayer atIndex:0];
		
		_nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_nameLabel.backgroundColor = [UIColor clearColor];
		_nameLabel.font = [UIFont boldSystemFontOfSize:30.0];
		_nameLabel.numberOfLines = 0;
        
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.font = [UIFont italicSystemFontOfSize:16.0];
        _descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
        _descriptionLabel.numberOfLines = 0;
		
		_previewImageView = [[UIImageView alloc] initWithImage:nil];
		_previewImageView.backgroundColor = [UIColor blackColor];
		_previewImageView.contentMode = UIViewContentModeScaleAspectFit;
		_previewImageView.layer.borderColor = [UIColor whiteColor].CGColor;
		_previewImageView.layer.borderWidth = 1.0;
		
		[_detailsView addSubview:_nameLabel];
		[_detailsView addSubview:_previewImageView];
        [_detailsView addSubview:_descriptionLabel];
        
		[self.contentView addSubview:_detailsView];
		
		self.gallery = gallery;
    }
	
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	_detailsView.frame = CGRectMake(0,
									0,
									self.contentView.frame.size.width,
									self.contentView.frame.size.height);
	
	_detailsLayer.frame = _detailsView.bounds;
	
	_previewImageView.frame = CGRectMake(kPadding,
										 floor((_detailsView.frame.size.height - kPreviewImageSize) / 2),
										 kPreviewImageSize,
										 kPreviewImageSize);
	
	CGSize nameSize = _nameLabel.text ? [_nameLabel.text sizeWithFont:_nameLabel.font
                                                    constrainedToSize:CGSizeMake(_detailsView.frame.size.width - _previewImageView.frame.size.width - _previewImageView.frame.origin.x - kPadding * 2,
                                                                                 FLT_MAX)] : CGSizeZero;
	
	_nameLabel.frame = CGRectMake(_previewImageView.frame.size.width + _previewImageView.frame.origin.x + kPadding,
								  _previewImageView.frame.origin.y,
								  nameSize.width,
								  nameSize.height);
	
	CGSize descriptionSize = _descriptionLabel.text ? [_descriptionLabel.text sizeWithFont:_descriptionLabel.font
                                                                         constrainedToSize:CGSizeMake(_detailsView.frame.size.width - _previewImageView.frame.size.width - _previewImageView.frame.origin.x - kPadding * 2,
                                                                                                      _detailsView.frame.size.height - _nameLabel.frame.origin.y - _nameLabel.frame.size.height - kPadding)] : CGSizeZero;
	
	_descriptionLabel.frame = CGRectMake(_nameLabel.frame.origin.x,
                                         _nameLabel.frame.origin.y + _nameLabel.frame.size.height + kPadding,
                                         descriptionSize.width,
                                         descriptionSize.height);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    NSArray *colors = [NSArray arrayWithObjects:(highlighted ? (id)[[UIColor lightGrayColor] CGColor] : (id)[[UIColor whiteColor] CGColor]), (highlighted ? (id)[[UIColor grayColor] CGColor] : (id)[[UIColor lightGrayColor] CGColor]), nil];
    
    UIColor *textColor = highlighted ? [UIColor whiteColor] : [UIColor blackColor];
    
    if(animated)
        [UIView animateWithDuration:0.3 animations:^{
            _detailsLayer.colors = colors;
            _nameLabel.textColor = textColor;
            _descriptionLabel.textColor = textColor;
        }];
    else {
        _detailsLayer.colors = colors;
        _nameLabel.textColor = textColor;
        _descriptionLabel.textColor = textColor;
    }
}

- (void)dealloc {
	[_gallery release];
	[_detailsView release];
	[_detailsLayer release];
	[_nameLabel release];
    [_descriptionLabel release];
	[_previewImageView release];
	
    [super dealloc];
}


@end
