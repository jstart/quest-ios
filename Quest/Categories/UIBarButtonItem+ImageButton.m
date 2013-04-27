//
//  UIBarButtonItem+ImageButton.m
//  Quest
//
//  Created by Christopher Truman on 16/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "UIBarButtonItem+ImageButton.h"

@implementation UIBarButtonItem (ImageButton)

+ (UIBarButtonItem*)itemWithImage:(UIImage*)image forState:(UIControlState)controlState target:(id)target action:(SEL)action{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:controlState];
    
    button.frame= CGRectMake(0.0, 0.0, 44, 44);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44, 44) ];
    [v addSubview:button];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
