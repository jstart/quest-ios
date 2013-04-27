//
//  QuestTableViewController.h
//  Quest
//
//  Created by Christopher Truman on 18/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Quest;

@interface QuestTableViewController : UITableViewController

@property (nonatomic, strong) Quest * quest;

+(QuestTableViewController *)viewControllerForQuest:(Quest *)quest;

@end
