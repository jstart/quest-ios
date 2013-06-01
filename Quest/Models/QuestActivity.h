//
//  QuestActivity.h
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import <Parse/Parse.h>

@class Quest, Waypoint;

@interface QuestActivity : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) PFUser * user;
@property (nonatomic, strong) Waypoint * waypoint;
@property (nonatomic, strong) PFFile * image;
@property (nonatomic, strong) NSNumber * hasCompleted;

@end
