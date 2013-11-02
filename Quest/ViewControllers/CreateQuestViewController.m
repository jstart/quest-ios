//
//  CreateQuestViewController.m
//  Quest
//
//  Created by Truman, Christopher on 9/11/12.
//  Copyright (c) 2012 Truman. All rights reserved.
//

#import "CreateQuestViewController.h"
#import <UIColor+Expanded.h>
#import <SSToolkit.h>
#import <QuartzCore/QuartzCore.h>
#import <XCDFormInputAccessoryView.h>
#import "QuestViewController.h"
#import "UIBarButtonItem+ImageButton.h"

#import "Quest.h"

@interface CreateQuestViewController () <UITextFieldDelegate>{
    BOOL cancelled;
}

@property (nonatomic, strong) XCDFormInputAccessoryView * inputAccessoryView;

@end

@implementation CreateQuestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Create a Quest";
        self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];

        UIBarButtonItem * cancelButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"Cancel"] forState:UIControlStateNormal target:self action:@selector(close)];
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
        
        
        [self.titleTextField setFont:[UIFont fontWithName:@"Avenir-Black" size:17]];
        [self.titleTextField addTarget:self action:@selector(titleTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
        [self.titleTextField setTextEdgeInsets:UIEdgeInsetsMake(15, 15, 0, 0)];
        [self.titleTextField setClearButtonEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        self.titleTextField.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        self.titleTextField.layer.borderWidth = 1;
        [self.titleTextField setDelegate:self];
        
        [self.descriptionTextField setFont:[UIFont fontWithName:@"Avenir-Black" size:14]];
        [self.descriptionTextField setTextEdgeInsets:UIEdgeInsetsMake(15, 15, 0, 0)];
        self.descriptionTextField.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
        self.descriptionTextField.layer.borderWidth = 1;
        [self.descriptionTextField setDelegate:self];
        cancelled = NO;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.inputAccessoryView = [[XCDFormInputAccessoryView alloc] init];
    [self.inputAccessoryView setHasDoneButton:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.titleTextField becomeFirstResponder];
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
        [self.inputAccessoryView setHasDoneButton:YES animated:YES];
    } else if(((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]).isSelected && self.titleTextField.text.length < 1){
        [((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]) setEnabled:NO];
        [((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]) setSelected:NO];
        [self.inputAccessoryView setHasDoneButton:NO animated:YES];
    }
}

-(void)close{
    cancelled = YES;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)next{
    cancelled = YES;
    QuestViewController * questTableViewController = [QuestViewController viewControllerForQuest:self.quest withActionType:QuestViewControllerActionTypeCancel];
    [self.navigationController pushViewController:questTableViewController animated:YES];
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    if (cancelled) {
        return;
    }
    [self done];
}

-(void)done{
    SSHUDView *hud = [[SSHUDView alloc] initWithTitle:@"Creating Quest..." loading:YES];
	[hud show];
    self.quest = [Quest object];
    self.quest.name = self.titleTextField.text;
    self.quest.description = self.descriptionTextField.text;
    self.quest.owner = [PFUser currentUser];
    [self.quest saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
        [self.quest registerOwnerForPushNotifications];
        [hud completeAndDismissWithTitle:@"Created!"];
        [self next];
    }];
}

- (void)viewDidUnload {
    [self setTitleTextField:nil];
    [self setDescriptionTextField:nil];
    [super viewDidUnload];
}

@end
