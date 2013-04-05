//
//  Quest.m
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "Quest.h"
#import <Parse/PFObject+Subclass.h>


@implementation Quest
@dynamic name, description;

+ (NSString *)parseClassName {
    return @"Quest";
}

@end
