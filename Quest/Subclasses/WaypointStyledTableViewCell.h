//
//  WaypointStyledTableViewCell.h
//  Quest
//
//  Created by Christopher Truman on 22/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "QuestStyledTableViewCell.h"

@class Waypoint;

@interface WaypointStyledTableViewCell : QuestStyledTableViewCell

@property (nonatomic, strong) Waypoint * waypoint;

-(void)setupWithWaypoint:(Waypoint *)waypoint;

@end
