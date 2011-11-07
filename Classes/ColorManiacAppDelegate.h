//
//  ColorManiacAppDelegate.h
//  ColorManiac
//
//  Created by Eugenio Depalo on 21/02/11.
//  Copyright 2011 - Lucido, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorManiacAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
+ (NSString *)documentsPath;

@end

