//
//  Quest.h
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import <Parse/Parse.h>

@interface Quest : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * description;
@property (nonatomic, strong) PFUser * owner;
@property (nonatomic, strong) PFRelation * viewers;
@property (nonatomic, strong) PFRelation * questers;
@property (nonatomic, strong) PFRelation * waypoints;

@end
