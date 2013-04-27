//
//  UIBarButtonItem+ImageButton.h
//  Quest
//
//  Created by Christopher Truman on 16/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ImageButton)

+ (UIBarButtonItem*)itemWithImage:(UIImage*)image forState:(UIControlState)controlState target:(id)target action:(SEL)action;

@end
