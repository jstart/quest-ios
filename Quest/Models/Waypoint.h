//
//  Waypoint.h
//  Quest
//
//  Created by Christopher Truman on 11/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import <Parse/Parse.h>

@interface Waypoint : PFObject <PFSubclassing>
+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * foursquareVenueID;
@property (nonatomic, strong) NSString * youtubeURLString;
@property (nonatomic, strong) PFRelation * peopleAtPoint;

@end
