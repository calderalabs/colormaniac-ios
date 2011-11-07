//
//  CMTTableViewCell.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 02/03/11.
//  Copyright 2011 Lucido, Inc. All rights reserved.
//

#import "CMTTableViewCell.h"


@implementation CMTTableViewCell

+ (NSString *)identifier {
	return NSStringFromClass(self);
}

+ (CGFloat)height {
	return 44.0;
}

@end
