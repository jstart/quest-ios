//
//  RegisterSubclasses.m
//  Quest
//
//  Created by Christopher Truman on 05/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "RegisterSubclasses.h"
#import "Quest.h"
#import "Waypoint.h"

@implementation RegisterSubclasses

+(void)registerSubclasses{
    [Quest registerSubclass];
    [Waypoint registerSubclass];
}

@end
