//
//  AppDelegate.m
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "AppDelegate.h"
#import "DCIntrospect.h"
#import "UIResponder+KeyboardCache.h"
#import <Parse/Parse.h>
#import "RegisterSubclasses.h"
#import "UISS.h"
#ifdef DEBUG
    #import "PonyDebugger.h"
#endif

#import "HomeViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"GuK8T7ww0O8n3436UJuscxvbC64b39FdvtKe7K0W" clientKey:@"E2hE67txdeet624MrJRmpGowlh6WhdyrJ0B94IVJ"];
    [PFFacebookUtils initializeFacebook];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [RegisterSubclasses registerSubclasses];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController_iPad" bundle:nil];
    }
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
#if TARGET_IPHONE_SIMULATOR
    self.userInterfaceStyleSheets = [UISS configureWithURL:[NSURL URLWithString:@"http://localhost/~christophertruman/uiss.json"]];
    [[DCIntrospect sharedIntrospector] start];
//    PDDebugger *debugger = [PDDebugger defaultInstance];
//    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
//    [debugger enableNetworkTrafficDebugging];
//    [debugger forwardAllNetworkTraffic];
//    [debugger enableViewHierarchyDebugging];
//    [debugger enableRemoteLogging];
#else
    self.userInterfaceStyleSheets = [UISS configureWithURL:[NSURL URLWithString:@"http://starcarcentral.com/uiss.json"]];
#endif
    self.userInterfaceStyleSheets.autoReloadEnabled = YES;
    self.userInterfaceStyleSheets.autoReloadTimeInterval = 1;
    self.userInterfaceStyleSheets.statusWindowEnabled = NO;
    [UIResponder cacheKeyboard:YES];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];

    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
        NSString * channelName = [NSString stringWithFormat:@"installation-%@", [PFInstallation currentInstallation].objectId];
        [currentInstallation addUniqueObject:channelName forKey:@"channels"];
        [currentInstallation saveInBackground];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsContinue" object:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsContinue" object:nil];
}

@end
