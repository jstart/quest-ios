//
//  ActiveQuestViewController.h
//  Quest
//
//  Created by Christopher Truman on 18/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Quest;

@interface ActiveQuestViewController : UIViewController

@property (nonatomic, strong) Quest * quest;

+(ActiveQuestViewController *)viewControllerForQuest:(Quest *)quest;

@end
