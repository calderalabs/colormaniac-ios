//
//  CMTProductTableViewCell.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 05/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTProductTableViewCell.h"
#import "CMTPurchaseButton.h"
#import "CMTHTTPRequest.h"
#import "ASIDownloadCache.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kPadding = 10.0;
static const CGFloat kPreviewImageSize = 130.0;

@implementation CMTProductTableViewCell

@synthesize delegate = _delegate;
@synthesize product = _product;

+ (CGFloat)height {
	return 150.0;
}

- (void)setProduct:(SKProduct *)product {
	[_product autorelease];
	_product = [product retain];
	
	_purchaseButton.product = product;
	
	_nameLabel.text = product.localizedTitle;

	_descriptionLabel.text = product.localizedDescription;

	[_previewImageActivityView startAnimating];
	
	_previewImageView.image = nil;
	
	[_thumbnailRequest release];
	_thumbnailRequest = [[CMTHTTPRequest requestWithPath:[NSString stringWithFormat:@"galleries/%d/thumbnail",
																		[product.productIdentifier integerValue]]] retain];
	[_thumbnailRequest setDownloadCache:[ASIDownloadCache sharedCache]];
	[_thumbnailRequest setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
	
	[_thumbnailRequest setCompletionBlock:^{
		_previewImageView.image = [UIImage imageWithData:[_thumbnailRequest responseData]];
		
		[_previewImageActivityView stopAnimating];
	}];
	[_thumbnailRequest setFailedBlock:^{
		[_previewImageActivityView stopAnimating];
	}];
	
	[_thumbnailRequest startAsynchronous];
	
	[self setNeedsLayout];
}

- (id)initWithProduct:(SKProduct *)product {
    self = [super initWithStyle:UITableViewCellStyleDefault	reuseIdentifier:[self.class identifier]];
    if (self) {
		_detailsView = [[UIView alloc] initWithFrame:CGRectZero];
		_detailsLayer = [[CAGradientLayer layer] retain];
		
		_detailsLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
		[_detailsView.layer insertSublayer:_detailsLayer atIndex:0];
		
		_nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_nameLabel.backgroundColor = [UIColor clearColor];
		_nameLabel.textColor = [UIColor blackColor];
		_nameLabel.font = [UIFont boldSystemFontOfSize:30.0];
		_nameLabel.numberOfLines = 0;
		
		_previewImageView = [[UIImageView alloc] initWithImage:nil];
		_previewImageView.contentMode = UIViewContentModeScaleAspectFit;
		_previewImageView.backgroundColor = [UIColor blackColor];
		_previewImageView.layer.borderColor = [UIColor whiteColor].CGColor;
		_previewImageView.layer.borderWidth = 1.0;
		
		[_detailsView addSubview:_nameLabel];
		[_detailsView addSubview:_previewImageView];
		
		_purchaseButton = [[CMTPurchaseButton alloc] initWithProduct:_product];
		_purchaseButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
		_purchaseButton.frame = CGRectMake(0, 0, 160, 30);
		_purchaseButton.target = self;
		_purchaseButton.action = @selector(purchase:);
		[_detailsView addSubview:_purchaseButton];
		
		_previewImageActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[_detailsView addSubview:_previewImageActivityView];
		
		_descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
		_descriptionLabel.font = [UIFont italicSystemFontOfSize:14.0];
		
		[_detailsView addSubview:_descriptionLabel];
		
		[self.contentView addSubview:_detailsView];
		
		self.product = product;
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
	
	_previewImageActivityView.frame = CGRectMake(_previewImageView.frame.origin.x + floor((kPreviewImageSize - _previewImageActivityView.frame.size.width) / 2),
												 _previewImageView.frame.origin.y + floor((kPreviewImageSize - _previewImageActivityView.frame.size.height) / 2),
												 _previewImageActivityView.frame.size.width,
												 _previewImageActivityView.frame.size.height);
	
	_purchaseButton.frame = CGRectMake(self.frame.size.width - _purchaseButton.frame.size.width - 20,
									   floor((self.frame.size.height - _purchaseButton.frame.size.height) / 2),
									   _purchaseButton.frame.size.width,
									   _purchaseButton.frame.size.height);
	
	CGSize nameSize = _nameLabel.text ? [_nameLabel.text sizeWithFont:_nameLabel.font
                                                             forWidth:_detailsView.frame.size.width - _purchaseButton.frame.size.width - _previewImageView.frame.size.width - _previewImageView.frame.origin.x - kPadding * 2
                                         lineBreakMode:UILineBreakModeWordWrap] : CGSizeZero;
	
	_nameLabel.frame = CGRectMake(_previewImageView.frame.size.width + _previewImageView.frame.origin.x + kPadding,
								  _previewImageView.frame.origin.y,
								  nameSize.width,
								  nameSize.height);
	
	CGSize descriptionSize = _descriptionLabel.text ? [_descriptionLabel.text sizeWithFont:_descriptionLabel.font
                                                            constrainedToSize:CGSizeMake(_detailsView.frame.size.width - _purchaseButton.frame.size.width - kPadding * 2 - 90 - _previewImageView.frame.size.width, _detailsView.frame.size.height - _nameLabel.frame.origin.y - _nameLabel.frame.size.height - kPadding)
                                                        lineBreakMode:UILineBreakModeWordWrap] : CGSizeZero;
    
	_descriptionLabel.frame = CGRectMake(_nameLabel.frame.origin.x,
										 _nameLabel.frame.origin.y + _nameLabel.frame.size.height + kPadding,
										 descriptionSize.width,
										 descriptionSize.height);
}

- (void)purchase:(CMTPurchaseButton *)purchaseButton {
	if([_delegate respondsToSelector:@selector(productTableViewCell:shouldPurchaseProduct:)])
		[_delegate productTableViewCell:self shouldPurchaseProduct:_product];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	[_purchaseButton setConfirm:NO animated:YES];
	
	[self setNeedsLayout];
}

- (void)dealloc {
	[_product release];
	[_purchaseButton release];
	
	[_previewImageView release];
	[_previewImageActivityView release];
	[_nameLabel release];
    [_descriptionLabel release];
	[_detailsView release];
	[_detailsLayer release];
	
	[_thumbnailRequest clearDelegatesAndCancel];
	[_thumbnailRequest release];
	
    [super dealloc];
}


@end
