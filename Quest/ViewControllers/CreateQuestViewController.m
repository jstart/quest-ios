//
//  CreateQuestViewController.m
//  Quest
//
//  Created by Truman, Christopher on 9/11/12.
//  Copyright (c) 2012 Truman. All rights reserved.
//

#import "CreateQuestViewController.h"
#import "UIColor+Expanded.h"
#import "SSToolkit.h"
#import <QuartzCore/QuartzCore.h>

#import "Quest.h"

@interface CreateQuestViewController ()

@end

@implementation CreateQuestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Create a Page";
        self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        
        UIView * cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIButton * cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [cancelButton setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [cancelView addSubview:cancelButton];
        UIBarButtonItem * cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelView];
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
        
        UIView * checkmarkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIButton * checkmarkButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [checkmarkButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [checkmarkButton setImage:[UIImage imageNamed:@"checkmark_inactive"] forState:UIControlStateNormal];
        [checkmarkButton setImage:[UIImage imageNamed:@"checkmark_active"] forState:UIControlStateSelected];
        [checkmarkButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [checkmarkButton setEnabled:NO];
        [checkmarkView addSubview:checkmarkButton];
        UIBarButtonItem * checkmarkButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkmarkView];
        self.navigationItem.rightBarButtonItem = checkmarkButtonItem;
        
        [self.titleTextField setFont:[UIFont fontWithName:@"Myriad Web Pro" size:17]];
        [self.titleTextField addTarget:self action:@selector(titleTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
        [self.titleTextField setTextEdgeInsets:UIEdgeInsetsMake(15, 15, 0, 0)];
        [self.titleTextField setClearButtonEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        self.titleTextField.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        self.titleTextField.layer.borderWidth = 1;
        
        [self.descriptionTextField setFont:[UIFont fontWithName:@"Myriad Web Pro" size:14]];
        [self.descriptionTextField setTextEdgeInsets:UIEdgeInsetsMake(15, 15, 0, 0)];
        self.descriptionTextField.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        self.descriptionTextField.layer.borderWidth = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)titleTextFieldChanged{
    if (!((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]).isSelected && self.titleTextField.text.length > 0) {
        [((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]) setEnabled:YES];
        [((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]) setSelected:YES];
    } else if(((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]).isSelected && self.titleTextField.text.length < 1){
        [((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]) setEnabled:NO];
        [((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]) setSelected:NO];
    }
}

-(void)close{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)done{
    SSHUDView *hud = [[SSHUDView alloc] initWithTitle:@"Creating Quest..." loading:YES];
	[hud show];
    [Quest registerSubclass];
    Quest * newQuest = [Quest object];
    newQuest.name = self.titleTextField.text;
    newQuest.description = self.descriptionTextField.text;
    [newQuest saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
        [hud completeAndDismissWithTitle:@"Created!"];
        [self close];
    }];
}

- (void)viewDidUnload {
    [self setTitleTextField:nil];
    [self setDescriptionTextField:nil];
//    [self setPageOrPollSegmentedControl:nil];
//    [self setThereCanOnlyBeOneImage:nil];
    [super viewDidUnload];
}

@end
