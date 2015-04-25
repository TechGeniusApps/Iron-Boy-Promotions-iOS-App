//
//  AppDelegate.m
//  Iron Boy Promotions
//
//  Created by Victor Ilisei on 3/25/15.
//  Copyright (c) 2015 Tech Genius. All rights reserved.
//

#import <Parse/Parse.h>

#import "FeaturedPosters.h"
#import "VideoList.h"

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.tintColor = [UIColor redColor];
    // Override point for customization after application launch.
    
    [Parse setApplicationId:@"KJfmGKTJvdwcTyMUE4l1iCXGLffWTHUay6IaBEaM" clientKey:@"t6HEa7FTgjJ26FRGxxHdxtJLJLc8NfRHRcKmi3Sk"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
    
    @autoreleasepool {
        FeaturedPosters *featured = [[FeaturedPosters alloc] init];
        VideoList *videoList = [[VideoList alloc] init];
        
        self.tabBarController.viewControllers = @[featured, [[UINavigationController alloc] initWithRootViewController:videoList]];
    }
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end