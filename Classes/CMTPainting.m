//
//  CMTPainting.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 27/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTPainting.h"
#import "ColorManiacAppDelegate.h"
#import "CMTPalette.h"
#import "RGBAColor.h"
#import "ColorManiacAppDelegate.h"

int sortColorizedPixels(const void *a, const void *b) {
    return (int)(*(unsigned int *)b - *(unsigned int *)a);
}

@implementation CMTPainting

@synthesize title = _title;
@synthesize author = _author;
@synthesize picturePath = _picturePath;
@synthesize thumbnailPath = _thumbnailPath;
@synthesize score = _score;
@synthesize locked = _locked;
@synthesize difficulty = _difficulty;
@synthesize bundled = _bundled;

- (NSString *)basePath {
    return _bundled ? [NSBundle mainBundle].resourcePath : [ColorManiacAppDelegate documentsPath];
}

- (NSString *)fullThumbnailPath {
    return [[self basePath] stringByAppendingFormat:@"/%@", _thumbnailPath];
}

- (NSString *)fullPicturePath {
    return [[self basePath] stringByAppendingFormat:@"/%@", _picturePath];
}

- (BOOL)isCompleted {
    return self.medal != CMTPaintingMedalNone;
}

- (NSString *)medalTitleForMedal:(CMTPaintingMedal)medal {
    switch (medal) {
        case CMTPaintingMedalBronze:
            return @"Bronze Brush";
            break;
        case CMTPaintingMedalSilver:
            return @"Silver Brush";
            break;
        case CMTPaintingMedalGold:
            return @"Gold Brush";
            break;
        case CMTPaintingMedalDiamond:
            return @"Diamond Brush";
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)medalTitle {
    return [self medalTitleForMedal:self.medal];
}

- (NSString *)difficultyTitle {
    switch (self.difficulty) {
        case CMTPaintingDifficultyEasy:
            return @"Easy";
            break;
        case CMTPaintingDifficultyMedium:
            return @"Medium";
            break;
        case CMTPaintingDifficultyHard:
            return @"Hard";
            break;
        case CMTPaintingDifficultyExtreme:
            return @"Extreme";
            break;
        default:
            return @"";
            break;
    }
}

- (CMTPaintingMedal)medalForScore:(int)score {
    float ratio = ((float) score / _maximumScore);
    
    if(ratio < 0.5)
        return CMTPaintingMedalNone;
    else if(ratio < 0.7)
        return CMTPaintingMedalBronze;
    else if(ratio < 0.9)
        return CMTPaintingMedalSilver;
    else if(ratio < 1.0)
        return CMTPaintingMedalGold;
    else
        return CMTPaintingMedalDiamond;
}

- (CMTPaintingMedal)medal {
    return [self medalForScore:_score];
}

+ (CMTPainting *)paintingWithTitle:(NSString *)title
							author:(NSString *)author
                           bundled:(BOOL)bundled
					   picturePath:(NSString *)picturePath
					 thumbnailPath:(NSString *)thumbnailPath {
	CMTPainting *painting = [[self alloc] init];
	
	painting.title = title;
	painting.author = author;
	painting.picturePath = picturePath;
	painting.thumbnailPath = thumbnailPath;
	painting.score = 0;
	painting.locked = YES;
    painting.bundled = bundled;
    
	return [painting autorelease];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if(self = [self init]) {
		_title = [[aDecoder decodeObjectForKey:@"title"] retain];
		_author = [[aDecoder decodeObjectForKey:@"author"] retain];
		_picturePath = [[aDecoder decodeObjectForKey:@"picturePath"] retain];
		_thumbnailPath = [[aDecoder decodeObjectForKey:@"thumbnailPath"] retain];
		_score = [aDecoder decodeIntForKey:@"score"];
        _locked = [aDecoder decodeBoolForKey:@"locked"];
        _maximumScore = [aDecoder decodeIntForKey:@"maximumScore"];
        _difficulty = [aDecoder decodeIntForKey:@"difficulty"];
        _bundled = [aDecoder decodeBoolForKey:@"bundled"];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_title forKey:@"title"];
	[aCoder encodeObject:_author forKey:@"author"];
	[aCoder encodeObject:_picturePath forKey:@"picturePath"];
	[aCoder encodeObject:_thumbnailPath forKey:@"thumbnailPath"];
	[aCoder encodeInt:_score forKey:@"score"];
    [aCoder encodeBool:_locked forKey:@"locked"];
    [aCoder encodeInt:_maximumScore forKey:@"maximumScore"];
    [aCoder encodeInt:_difficulty forKey:@"difficulty"];
    [aCoder encodeBool:_bundled forKey:@"bundled"];
}

- (void)computeColors {
    unsigned int colorizedPixels[16];
    
    memset(colorizedPixels, 0, sizeof(colorizedPixels));
    
	CGImageRef image = [UIImage imageWithContentsOfFile:self.fullPicturePath].CGImage;
    
	size_t width = CGImageGetWidth(image);
	size_t height = CGImageGetHeight(image);
    
    size_t numPixels = width * height;
    
	RGBAColor *picture = malloc(numPixels * sizeof(RGBAColor));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGRect pictureRect = CGRectMake(0, 0, width, height);
    
    CGContextRef pictureContext = CGBitmapContextCreate(picture,
                                                        pictureRect.size.width,
                                                        pictureRect.size.height,
                                                        8,
                                                        pictureRect.size.width * 4,
                                                        colorSpace,
                                                        kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(pictureContext, pictureRect, image);
    
    CGContextRelease(pictureContext);
    
    CGFloat *components = [CMTPalette sharedPalette].components;
    
    int i, j;
    RGBAColor originalColor;
    
    for(i = 0; i < numPixels; i++) {
        for(j = 0; j < 64 * 3; j+= 3) {
            originalColor = picture[i];
            
            if(originalColor.red >= components[j] && originalColor.red < components[j] + 64 &&
               originalColor.green >=  components[j + 1] && originalColor.green <  components[j + 1] + 64 &&
               originalColor.blue >=  components[j + 2] && originalColor.blue <  components[j + 2] + 64) {
                colorizedPixels[j / (4 * 3)]++;
                break;
            }
        }
    }
    
    qsort(colorizedPixels, 16, sizeof(unsigned int), &sortColorizedPixels);
    
    _maximumScore = 0;
    
    for(int i = 0; i < 5; i++)
        _maximumScore += colorizedPixels[i];
    
    free(picture);
    
    float ratio = ((float) _maximumScore / numPixels);
    
    if(ratio < 0.7)
        _difficulty = CMTPaintingDifficultyExtreme;
    else if(ratio < 0.8)
        _difficulty = CMTPaintingDifficultyHard;
    else if(ratio < 0.9)
        _difficulty = CMTPaintingDifficultyMedium;
    else
        _difficulty = CMTPaintingDifficultyEasy;
    
}

- (void)dealloc {
    [_title release];
    [_author release];
    [_picturePath release];
    [_thumbnailPath release];
    
    [super dealloc];
}

@end
