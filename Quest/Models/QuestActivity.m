//
//  QuestActivity.m
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "QuestActivity.h"
#import <Parse/PFObject+Subclass.h>


@implementation QuestActivity
@dynamic user, waypoint, image, hasCompleted;

+ (NSString *)parseClassName {
    return @"QuestActivity";
}

@end
