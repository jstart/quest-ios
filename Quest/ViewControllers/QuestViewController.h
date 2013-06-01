//
//  QuestViewController.h
//  Quest
//
//  Created by Christopher Truman on 18/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    QuestViewControllerActionTypeDismiss,
    QuestViewControllerActionTypeCancel
    } QuestViewControllerActionType;

@class Quest;

@interface QuestViewController : UIViewController

@property (nonatomic, strong) Quest * quest;

+(QuestViewController *)viewControllerForQuest:(Quest *)quest withActionType:(QuestViewControllerActionType) actionType;

@end
