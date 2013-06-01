//
//  Waypoint.h
//  Quest
//
//  Created by Christopher Truman on 11/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import <Parse/Parse.h>

@class Quest;

@interface Waypoint : PFObject <PFSubclassing>
+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * order;
@property (nonatomic, strong) NSString * youtubeURLString;
@property (nonatomic, strong) Quest * quest;

@end
