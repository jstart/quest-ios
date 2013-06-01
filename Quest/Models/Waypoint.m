//
//  Waypoint.m
//  Quest
//
//  Created by Christopher Truman on 11/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "Waypoint.h"
#import <Parse/PFObject+Subclass.h>

@implementation Waypoint
@dynamic name, youtubeURLString, order, quest;

+ (NSString *)parseClassName {
    return @"Waypoint";
}

@end
