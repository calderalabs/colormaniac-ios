//
//  CMTPalette.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 21/02/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTPalette.h"

@implementation CMTPalette

@synthesize components = _components;

static CMTPalette *palette = nil;

static const int kIndexTable[] = {
	16, 48, 32, 33,
	50, 54, 49, 55,
	52, 36, 37, 53,
	57, 40, 41, 56,
	5, 21, 20, 4,
	8, 25, 9, 24,
	12, 13, 29, 28,
	60, 45, 44, 61,
    
	0, 2, 1, 18,
	35, 17, 51, 34,
	58, 39, 38, 59,
	7, 22, 19, 3,
	27, 23, 6, 11,
	42, 26, 10, 43,
	15, 30, 14, 31,
	46, 47, 62, 63
};


- (UIColor *)colorAtIndex:(int)index {
	return [_colors objectAtIndex:kIndexTable[index]];
}

+ (CMTPalette*)sharedPalette
{
    if (palette == nil) {
        palette = [[super allocWithZone:NULL] init];
    }
    return palette;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedPalette] retain];
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
        _components = malloc(sizeof(CGFloat) * kNumColors * 3);
        
		_colors = [[NSMutableArray alloc] initWithCapacity:kNumColors];
		
		int i = 0;
		
		uint32_t step = cbrt(kNumColors);
		step = pow(step, 3);
		
		for (uint32_t red = 0; red <= 255; red += step) {
			for (uint32_t green = 0; green <= 255; green += step) {
				for (uint32_t blue = 0; blue <= 255; blue += step) {
					[_colors addObject:[UIColor colorWithRed:red / 255.0
													   green:green / 255.0
														blue:blue / 255.0
													   alpha:1.0]];
					
					i++;
				}
			}
		}
        
        for(int i = 0; i < kNumColors; i++) {
            UIColor *color = [_colors objectAtIndex:kIndexTable[i]];
            const CGFloat *components = CGColorGetComponents(color.CGColor);
            
            for(int j = 0; j < 3; j++)
                _components[i * 3 + j] = components[j] * 255.0;
        }
	}
	
	return self;
}

- (void)dealloc {
	[_colors release];
	
    free(_components);
    
	[super dealloc];
}

@end
