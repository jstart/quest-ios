//
//  AddWaypointViewController.h
//  Quest
//
//  Created by Christopher Truman on 25/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  Quest;

@interface AddWaypointViewController : UIViewController

@property (nonatomic, strong) Quest * quest;

@property (nonatomic, strong) NSNumber * order;

@end
