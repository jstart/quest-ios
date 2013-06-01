//
//  WaypointDetailViewController.h
//  Quest
//
//  Created by Christopher Truman on 25/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Waypoint, QuestActivity;

@interface WaypointDetailViewController : UIViewController

@property (nonatomic, strong) Waypoint * waypoint;

@property (nonatomic, strong) QuestActivity * activity;

@end
