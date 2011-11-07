//
//  CMTGalleryManager.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 28/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTGalleryManager.h"
#import "ColorManiacAppDelegate.h"
#import "CMTGallery.h"
#import "CMTPainting.h"

static NSString *kArchiveFileName = @"galleries.data";

@implementation CMTGalleryManager

@synthesize galleries = _galleries;

static CMTGalleryManager *manager = nil;

+ (CMTGalleryManager*)sharedManager
{
    if (manager == nil) {
        manager = [[super allocWithZone:NULL] init];
    }
    return manager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (void)release
{
	
}

- (id)autorelease
{
    return self;
}

- (id)init {
	self = [super init];
	
	if(self) {
        if(![[NSFileManager defaultManager] fileExistsAtPath:self.archivePath] && [[NSFileManager defaultManager] fileExistsAtPath:self.resourcePath])
            [[NSFileManager defaultManager] copyItemAtPath:self.resourcePath toPath:self.archivePath error:nil];
        
        _galleries = [[NSMutableArray alloc] init];
        
#ifdef DEBUG
        if(![[NSFileManager defaultManager] fileExistsAtPath:self.archivePath]) {
            NSArray *galleries = [NSArray arrayWithObjects:
                                  [CMTGallery galleryWithName:@"Starting Gallery 1"
                                                  description:@"Claude Monet, Edouard Manet, Sandro Botticelli, Edgar Degas, Henri Manguin"
                                                    paintings:[NSArray arrayWithObjects:
                                                               [CMTPainting paintingWithTitle:@"Promenade"
                                                                                       author:@"Claude Monet"
                                                                                      bundled:YES
                                                                                  picturePath:@"9.png"
                                                                                thumbnailPath:@"9.thumb.png"],
                                                               [CMTPainting paintingWithTitle:@"In the Conservatory"
                                                                                       author:@"Edouard Manet"
                                                                                      bundled:YES
                                                                                  picturePath:@"7.png"
                                                                                thumbnailPath:@"7.thumb.png"],
                                                               [CMTPainting paintingWithTitle:@"The Birth of Venus"
                                                                                       author:@"Sandro Botticelli"
                                                                                      bundled:YES
                                                                                  picturePath:@"54.png"
                                                                                thumbnailPath:@"54.thumb.png"],
                                                               [CMTPainting paintingWithTitle:@"The Dance Class"
                                                                                       author:@"Edgar Degas"
                                                                                      bundled:YES
                                                                                  picturePath:@"5.png"
                                                                                thumbnailPath:@"5.thumb.png"],
                                                               [CMTPainting paintingWithTitle:@"Morning at Cavaliere"
                                                                                       author:@"Henri Manguin"
                                                                                      bundled:YES
                                                                                  picturePath:@"10.png"
                                                                                thumbnailPath:@"10.thumb.png"],
                                                               nil]],
                                  [CMTGallery galleryWithName:@"Starting Gallery 2"
                                                  description:@"Henri Rousseau, Pieter Bruegel the Elder, Edward Hopper, Henri Matisse, Wassily Kandisky"
                                                    paintings:[NSArray arrayWithObjects:
                                                               [CMTPainting paintingWithTitle:@"The Dream"
                                                                                       author:@"Henri Rousseau"
                                                                                      bundled:YES
                                                                                  picturePath:@"13.png"
                                                                                thumbnailPath:@"13.thumb.png"],
                                                               [CMTPainting paintingWithTitle:@"The Dutch Proverbs"
                                                                                       author:@"Pieter Bruegel the Elder"
                                                                                      bundled:YES
                                                                                  picturePath:@"14.png"
                                                                                thumbnailPath:@"14.thumb.png"],
                                                               [CMTPainting paintingWithTitle:@"Hotel Room"
                                                                                       author:@"Edward Hopper"
                                                                                      bundled:YES
                                                                                  picturePath:@"6.png"
                                                                                thumbnailPath:@"6.thumb.png"],
                                                               [CMTPainting paintingWithTitle:@"The Red Room"
                                                                                       author:@"Henri Matisse"
                                                                                      bundled:YES
                                                                                  picturePath:@"15.png"
                                                                                thumbnailPath:@"15.thumb.png"],
                                                               [CMTPainting paintingWithTitle:@"Red Oval"
                                                                                       author:@"Wassily Kandisky"
                                                                                      bundled:YES
                                                                                  picturePath:@"11.png"
                                                                                thumbnailPath:@"11.thumb.png"], nil]],
                                  [CMTGallery galleryWithName:@"Starting Gallery 3"
                                                  description:@"Franz Marc, Carl Blechen, Johannes Vermeer, Vincent van Gogh, Pierre-Auguste Renoir"
                                                    paintings:[NSArray arrayWithObjects:
                                                               [CMTPainting paintingWithTitle:@"The Dream"
                                                                                       author:@"Franz Marc"
                                                                                      bundled:YES
                                                                                  picturePath:@"12.png"
                                                                                thumbnailPath:@"12.thumb.png"],
                                                               
                                                               
                                                               [CMTPainting paintingWithTitle:@"The Interior of the Palm House"
                                                                                       author:@"Carl Blechen"
                                                                                      bundled:YES
                                                                                  picturePath:@"16.png"
                                                                                thumbnailPath:@"16.thumb.png"],
                                                               [CMTPainting paintingWithTitle:@"The Milkmaid"
                                                                                       author:@"Johannes Vermeer"
                                                                                      bundled:YES
                                                                                  picturePath:@"17.png"
                                                                                thumbnailPath:@"17.thumb.png"],
                                                               [CMTPainting paintingWithTitle:@"The Starry Night"
                                                                                       author:@"Vincent van Gogh"
                                                                                      bundled:YES
                                                                                  picturePath:@"18.png"
                                                                                thumbnailPath:@"18.thumb.png"],
                                                               [CMTPainting paintingWithTitle:@"Woman with a Parasol in a Garden"
                                                                                       author:@"Pierre-Auguste Renoir"
                                                                                      bundled:YES
                                                                                  picturePath:@"19.png"
                                                                                thumbnailPath:@"19.thumb.png"], nil]], nil];
            
            for(CMTGallery *gallery in galleries)
                [gallery computeColorsSynchronously];
            
            [_galleries addObjectsFromArray:galleries];
            [self saveToDisk];
        }
#endif
        
        [self reloadFromDisk];
	}
    
	return self;
}

- (NSBlockOperation *)addGallery:(CMTGallery *)gallery completion:(void (^)(void))completion {
    void (^completionBlock)(void) = [[completion copy] autorelease];
    
    return [gallery computeColorsWithCompletion:^{
        [_galleries addObject:gallery];
        
        [self performSelectorOnMainThread:@selector(saveToDisk) withObject:nil waitUntilDone:YES];
        
        if(completionBlock)
            completionBlock();
    }];
}

- (NSString *)resourcePath {
	return [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:kArchiveFileName];
}

- (NSString *)archivePath {
	return [[ColorManiacAppDelegate documentsPath] stringByAppendingPathComponent:kArchiveFileName];
}

- (void)reloadFromDisk {
    [_galleries release];
	_galleries = [[NSKeyedUnarchiver unarchiveObjectWithFile:self.archivePath] retain];
}

- (BOOL)saveToDisk {
	return [NSKeyedArchiver archiveRootObject:_galleries toFile:self.archivePath];
}

- (void)dealloc {
	[_galleries release];
	
	[super dealloc];
}

@end
