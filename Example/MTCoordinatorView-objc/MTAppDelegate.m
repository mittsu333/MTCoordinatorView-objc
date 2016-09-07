//
//  MTAppDelegate.m
//  MTCoordinatorView-objc
//
//  Created by mittsu on 09/07/2016.
//  Copyright (c) 2016 mittsu. All rights reserved.
//

#import "MTAppDelegate.h"
#import "MTViewController.h"

@implementation MTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MTViewController *vc = [[MTViewController alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
