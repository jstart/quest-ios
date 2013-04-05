//
//  IPICreatePageInitialViewController.h
//  InsiderPages_iOS
//
//  Created by Truman, Christopher on 9/11/12.
//  Copyright (c) 2012 InisderPages. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SSTextField;

@interface CreateQuestViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet SSTextField *titleTextField;
@property (strong, nonatomic) IBOutlet SSTextField *descriptionTextField;

@end
