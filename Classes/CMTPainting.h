//
//  CMTPainting.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 27/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CMTPaintingMedalNone,
    CMTPaintingMedalBronze,
    CMTPaintingMedalSilver,
    CMTPaintingMedalGold,
    CMTPaintingMedalDiamond
} CMTPaintingMedal;

typedef enum {
    CMTPaintingDifficultyEasy,
    CMTPaintingDifficultyMedium,
    CMTPaintingDifficultyHard,
    CMTPaintingDifficultyExtreme
} CMTPaintingDifficulty;

@interface CMTPainting : NSObject <NSCoding> {
	NSString *_title;
	NSString *_author;
	NSString *_picturePath;
	NSString *_thumbnailPath;
    
    int _score;
    int _maximumScore;
    
    BOOL _locked;
    BOOL _bundled;
    
    CMTPaintingDifficulty _difficulty;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *picturePath;
@property (nonatomic, readonly) NSString *fullPicturePath;
@property (nonatomic, retain) NSString *thumbnailPath;
@property (nonatomic, readonly) NSString *fullThumbnailPath;
@property (nonatomic, assign) int score;
@property (nonatomic, getter=isLocked) BOOL locked;
@property (nonatomic, getter=isBundled) BOOL bundled;
@property (nonatomic, readonly, getter=isCompleted) BOOL completed;
@property (nonatomic, readonly) CMTPaintingMedal medal;
@property (nonatomic, readonly) CMTPaintingDifficulty difficulty;
@property (nonatomic, readonly) NSString *medalTitle;
@property (nonatomic, readonly) NSString *difficultyTitle;

+ (CMTPainting *)paintingWithTitle:(NSString *)title
							author:(NSString *)author
                           bundled:(BOOL)bundled
					   picturePath:(NSString *)picturePath
					 thumbnailPath:(NSString *)thumbnailPath;

- (void)computeColors;

- (CMTPaintingMedal)medalForScore:(int)score;
- (NSString *)medalTitleForMedal:(CMTPaintingMedal)medal;

@end
