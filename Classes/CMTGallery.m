//
//  CMTGallery.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 28/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTGallery.h"
#import "CMTPainting.h"

@implementation CMTGallery

@synthesize name = _name;
@synthesize paintings = _paintings;
@synthesize description = _description;

+ (CMTGallery *)galleryWithName:(NSString *)name
                    description:(NSString *)description
					  paintings:(NSArray *)paintings {
	CMTGallery *gallery = [[CMTGallery alloc] init];
	
	gallery.name = name;
    gallery.description = description;
	gallery.paintings = [NSMutableArray arrayWithArray:paintings];
    
	return [gallery autorelease];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if((self = [self init])) {
		_name = [[aDecoder decodeObjectForKey:@"name"] retain];
        _description = [[aDecoder decodeObjectForKey:@"description"] retain];
		_paintings = [[aDecoder decodeObjectForKey:@"paintings"] retain];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_description forKey:@"description"];
	[aCoder encodeObject:_paintings forKey:@"paintings"];
}

- (void)computeColorsSynchronously {
    for(CMTPainting *painting in _paintings) {
        [painting computeColors];
    }
    
    [_paintings sortUsingComparator:^(id a, id b) {
        CMTPainting *aPainting = a;
        CMTPainting *bPainting = b;
        
        if(aPainting.difficulty > bPainting.difficulty)
            return NSOrderedDescending;
        if(aPainting.difficulty < bPainting.difficulty)
            return NSOrderedAscending;
        
        return NSOrderedSame;
    }];
    
    CMTPainting *painting = [_paintings objectAtIndex:0];
    painting.locked = NO;
}

- (NSBlockOperation *)computeColorsWithCompletion:(void (^)(void))completion {
    void (^completionBlock)(void) = [[completion copy] autorelease];
    
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    NSBlockOperation *computeOperation = [[[NSBlockOperation alloc] init] autorelease];
    
    [computeOperation setCompletionBlock:^{
        if(!computeOperation.isCancelled)
            completionBlock();
    }];
    
    [computeOperation addExecutionBlock:^{
        [self computeColorsSynchronously];
    }];
    
    [queue addOperation:computeOperation];
    
    return computeOperation;
}

- (void)dealloc {
	[_name release];
	[_paintings release];
	[_description release];
    
	[super dealloc];
}

@end
