//
//  UINavigationController+Orientation.m
//  Quest
//
//  Created by Christopher Truman on 30/05/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "UINavigationController+Orientation.h"

@implementation UINavigationController (Orientation)

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
