//
//  CMTPaintingTableViewCell.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 02/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTPaintingTableViewCell.h"
#import "CMTPainting.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CMTSoundManager.h"

static const CGFloat kPadding = 10.0;
static const CGFloat kPreviewImageSize = 100.0;
static const CGFloat kMedalViewSize = 50.0;
static const CGFloat kSaveButtonHeight = 40.0;

@implementation CMTPaintingTableViewCell

@synthesize painting = _painting;
@synthesize saving = _saving;

+ (CGFloat)height {
	return 120.0;
}

- (void)setPainting:(CMTPainting *)painting {
	[_painting autorelease];
	_painting = [painting retain];
	
	_previewImageView.image = [UIImage imageWithContentsOfFile:painting.fullThumbnailPath];
    
	_titleLabel.text = painting.title;
	_authorLabel.text = painting.author;
	[_authorLabel sizeToFit];
	_scoreLabel.text = [NSString stringWithFormat:@"Score: %d", painting.score];
	[_scoreLabel sizeToFit];
    
	_difficultyLabel.text = _painting.difficultyTitle;
    [_difficultyLabel sizeToFit];
    
    NSString *imageName;
    
    switch (painting.medal) {
        case CMTPaintingMedalBronze:
            imageName = @"BronzeBrushSmall";
            break;
        case CMTPaintingMedalSilver:
            imageName = @"SilverBrushSmall";
            break;
        case CMTPaintingMedalGold:
            imageName = @"GoldBrushSmall";
            break;
        case CMTPaintingMedalDiamond:
            imageName = @"DiamondBrushSmall";
            break;
        case CMTPaintingMedalNone:
            imageName = @"";
            break;
    }
    
    _medalView.image = [UIImage imageNamed:imageName];
    
    _saveButton.hidden = (painting.medal != CMTPaintingMedalDiamond);
    _overlayButton.hidden = _saveButton.hidden;
    
    if(painting.isLocked) {
        self.contentView.alpha = 0.5;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _scoreLabel.hidden = YES;
    }
    else {
        self.contentView.alpha = 1.0;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        _scoreLabel.hidden = NO;
    }
    
	[self setNeedsLayout];
}

- (id)initWithPainting:(CMTPainting *)painting {
    
    self = [super initWithStyle:UITableViewCellStyleDefault	reuseIdentifier:[self.class identifier]];
    if (self) {
		_previewImageView = [[UIImageView alloc] initWithImage:nil];
		_previewImageView.contentMode = UIViewContentModeScaleAspectFit;
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.font = [UIFont boldSystemFontOfSize:25.0];
        
		_authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_authorLabel.backgroundColor = [UIColor clearColor];
		_authorLabel.font = [UIFont italicSystemFontOfSize:20.0];
		
		_scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_scoreLabel.backgroundColor = [UIColor clearColor];
		_scoreLabel.font = [UIFont boldSystemFontOfSize:30.0];
		
        _difficultyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _difficultyLabel.backgroundColor = [UIColor clearColor];
        _difficultyLabel.font = [UIFont systemFontOfSize:20.0];
        
        _medalView = [[UIImageView alloc] initWithImage:nil];
        
        _saveButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        [_saveButton setTitle:@"Save to Photo Album" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [_saveButton sizeToFit];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityView sizeToFit];
        
        _overlayButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        
		[self.contentView addSubview:_previewImageView];
		[self.contentView addSubview:_titleLabel];
		[self.contentView addSubview:_authorLabel];
		[self.contentView addSubview:_scoreLabel];
		[self.contentView addSubview:_difficultyLabel];
        [self.contentView addSubview:_overlayButton];
        [self.contentView addSubview:_medalView];
        [self.contentView addSubview:_saveButton];
        [self.contentView addSubview:_activityView];

		self.painting = painting;
    }
    return self;
}

- (void)save {
    [[CMTSoundManager sharedManager] playSoundEffect:@"click"];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    UIImage *image = [UIImage imageWithContentsOfFile:_painting.fullPicturePath];
    
    _saveButton.enabled = NO;
    _saving = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _activityView.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        _activityView.alpha = 1.0;
    }];
    
    [_activityView startAnimating];
    
    [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)[image imageOrientation]
                          completionBlock:^(NSURL *assetURL, NSError *error){
                              if(error) {
                                  UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error Saving Painting"
                                                                                      message:error.localizedDescription
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"OK"
                                                                            otherButtonTitles:nil];
                                  [errorView show];
                                  [errorView release];
                              }
                              
                              _saveButton.enabled = YES;
                              
                              [UIView animateWithDuration:0.5
                                               animations:^{
                                                   _activityView.alpha = 0.0;
                                               }
                                               completion:^(BOOL finished){
                                                   [_activityView stopAnimating];
                                                   _saving = NO;
                                                   self.selectionStyle = UITableViewCellSelectionStyleBlue;
                                               }];
                          }];
    
    [library release];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
    CGFloat top =  floor((self.contentView.frame.size.height - (_titleLabel.frame.size.height +
                                                                _authorLabel.frame.size.height +
                                                                _difficultyLabel.frame.size.height +
                                                                kPadding * 1.5)) / 2);
    
	_previewImageView.frame = CGRectMake(kPadding, floor((self.contentView.frame.size.height - kPreviewImageSize) / 2), kPreviewImageSize, kPreviewImageSize);
    
    _medalView.frame = CGRectMake(self.contentView.frame.size.width - _medalView.frame.size.width - kPadding * 2, floor((self.contentView.frame.size.height - _medalView.frame.size.height) / 2), kMedalViewSize, kMedalViewSize);
    
    CGRect scoreFrame = CGRectMake(0, 0, _saveButton.hidden ? _scoreLabel.frame.size.width : fmax(_saveButton.frame.size.width, _scoreLabel.frame.size.width),
                                   _scoreLabel.frame.size.height + kPadding + (_saveButton.hidden ? 0 : kSaveButtonHeight));
    scoreFrame.origin.x = _medalView.frame.origin.x - kPadding - scoreFrame.size.width;
    scoreFrame.origin.y = floor((self.frame.size.height - scoreFrame.size.height) / 2);
    
    _overlayButton.frame = CGRectMake(scoreFrame.origin.x - kPadding,
                                      0,
                                      self.contentView.frame.size.width - (scoreFrame.origin.x - kPadding),
                                      self.contentView.frame.size.height);
    
    CGPoint titleOrigin = CGPointMake(_previewImageView.frame.size.width + _previewImageView.frame.origin.x + kPadding, top);
    CGSize titleSize = _titleLabel.text ? [_titleLabel.text sizeWithFont:_titleLabel.font forWidth:scoreFrame.origin.x - kPadding - titleOrigin.x lineBreakMode:UILineBreakModeTailTruncation] : CGSizeZero;
    
	_titleLabel.frame = CGRectMake(titleOrigin.x, titleOrigin.y, titleSize.width, titleSize.height);
	_authorLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + kPadding / 2, _authorLabel.frame.size.width, _authorLabel.frame.size.height);
    _difficultyLabel.frame = CGRectMake(_authorLabel.frame.origin.x, _authorLabel.frame.origin.y + _authorLabel.frame.size.height + kPadding / 2, _difficultyLabel.frame.size.width, _difficultyLabel.frame.size.height);
    
    _scoreLabel.frame = CGRectMake(scoreFrame.origin.x + floor((scoreFrame.size.width - _scoreLabel.frame.size.width) / 2), scoreFrame.origin.y, _scoreLabel.frame.size.width, _scoreLabel.frame.size.height);
    _saveButton.frame = CGRectMake(scoreFrame.origin.x + floor((scoreFrame.size.width - _saveButton.frame.size.width) / 2), scoreFrame.origin.y + _scoreLabel.frame.size.height + kPadding, _saveButton.frame.size.width, kSaveButtonHeight);
    
    _activityView.frame = CGRectMake(scoreFrame.origin.x - _activityView.frame.size.width - kPadding * 2, floor((self.contentView.frame.size.height - _activityView.frame.size.height) / 2), _activityView.frame.size.width, _activityView.frame.size.height);
}

- (void)dealloc {
	[_painting release];
	[_previewImageView release];
	[_titleLabel release];
	[_authorLabel release];
	[_scoreLabel release];
	[_difficultyLabel release];
    [_medalView release];
    [_activityView release];
    [_saveButton release];
    [_overlayButton release];
    
    [super dealloc];
}


@end
