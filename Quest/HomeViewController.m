//
//  HomeViewController.m
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "HomeViewController.h"
#import "MYIntroductionView.h"
#import "IntroductionPanelCreator.h"
#import "FacebookSDK.h"
#import <Parse/Parse.h>
#import "UIControl+ALActionBlocks.h"

@interface HomeViewController () <MYIntroductionDelegate>

@property (nonatomic, strong) UIButton * loginButton;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (![PFUser currentUser]) {
        [self createIntroductionView];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    if (![PFUser currentUser]) {
        [self.introductionView showInView:self.view];
    }
}

-(void)createIntroductionView{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Introduction" ofType:@"plist"];
    NSArray * introductionPlistArray = [[NSArray arrayWithContentsOfFile:file] firstObject];
    NSArray * panelArray = [IntroductionPanelCreator createIntroductionPanelsFromArray:introductionPlistArray];
    
    self.introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerText:@"Quest" panels:panelArray languageDirection:MYLanguageDirectionLeftToRight];
    self.introductionView.SkipButton.hidden = YES;
    
    [self.introductionView setBackgroundColor:[UIColor grayColor]];
    
    //Set delegate to self for callbacks (optional)
    self.introductionView.delegate = self;
    
    //STEP 3: Show introduction view
    [self.introductionView showInView:self.view];
}

#pragma mark - MYIntroductionViewDelegate

-(void)introductionDidFinishWithType:(MYFinishType)finishType{
    if (finishType == MYFinishTypeSkipButton) {
        NSLog(@"Did Finish Introduction By Skipping It");
    }
    else if (finishType == MYFinishTypeSwipeOut){
        NSLog(@"Did Finish Introduction By Swiping Out");
    }
}

-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"%@ \nPanelIndex: %d", panel.Description, panelIndex);
    if (panelIndex == 1 && ![[self.introductionView subviews] containsObject:self.loginButton]) {
        self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.loginButton.frame = CGRectMake(self.introductionView.ContentScrollView.contentOffset.x + 320/2 - 200/2, self.introductionView.frame.size.height - 50 - 65 - 36 - 10, 200, 50);
        [self.loginButton setTitle:@"Login With Facebook" forState:UIControlStateNormal];
        [self.loginButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton * button){
            [PFFacebookUtils logInWithPermissions:@[@"email"] block:^(PFUser *user, NSError *error) {
                if (!user) {
                    NSLog(@"Uh oh. The user cancelled the Facebook login.");
                } else if (user.isNew) {
                    NSLog(@"User signed up and logged in through Facebook!");
                    [self.introductionView hideWithFadeOutDuration:0.2];
                } else {
                    NSLog(@"User logged in through Facebook!");
                    [user save];
                    [self.introductionView hideWithFadeOutDuration:0.2];
                }
            }];
        }];
        self.loginButton.alpha = 0.0;
        [self.introductionView.ContentScrollView addSubview:self.loginButton];
        [UIView animateWithDuration:0.2 animations:^() {
            self.loginButton.alpha = 1.0;
        }];
    }
    else{
        [UIView animateWithDuration:0.2 animations:^() {
            self.loginButton.alpha = 0.0;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
