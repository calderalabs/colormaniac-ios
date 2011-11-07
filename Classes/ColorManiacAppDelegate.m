//
//  ColorManiacAppDelegate.m
//  ColorManiac
//
//  Created by Eugenio Depalo on 21/02/11.
//  Copyright 2011 - Lucido, Inc. All rights reserved.
//

#import "ColorManiacAppDelegate.h"
#import "CMTStartController.h"
#import "CMTSoundManager.h"

@implementation ColorManiacAppDelegate

@synthesize window;

+ (NSString *)documentsPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self.window makeKeyAndVisible];
    
	CMTStartController *startController = [[CMTStartController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:startController];
	navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self.window.rootViewController presentModalViewController:navigationController animated:NO];
	[startController release];
	[navigationController release];
    
    [[CMTSoundManager sharedManager] preloadSoundEffect:@"click"];
    [[CMTSoundManager sharedManager] preloadSoundEffect:@"clock"];
    [[CMTSoundManager sharedManager] preloadSoundEffect:@"medal"];
    [[CMTSoundManager sharedManager] preloadSoundEffect:@"colorizing"];
    
	[[CMTSoundManager sharedManager] playBackgroundMusic:
	 [[NSBundle mainBundle] pathForResource:@"ColorManiacTheme" ofType:@"mp3"]];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
    [window release];

    [super dealloc];
}

@end
