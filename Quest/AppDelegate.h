//
//  AppDelegate.h
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController * navigationController;

@property (strong, nonatomic) HomeViewController *viewController;

@end
