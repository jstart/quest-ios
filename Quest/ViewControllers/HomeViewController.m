//
//  HomeViewController.m
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "HomeViewController.h"

#import "FacebookSDK.h"
#import <Parse/Parse.h>
#import "UIControl+ALActionBlocks.h"
#import "MYIntroductionView.h"
#import "IntroductionPanelCreator.h"
#import "CreateQuestViewController.h"
#import "SVPullToRefresh.h"
#import "HMSegmentedControl.h"

#import "Quest.h"

@interface HomeViewController () <MYIntroductionDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createButon;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;

- (IBAction)pressedSettings:(id)sender;
- (IBAction)pressedCreate:(id)sender;

@property (nonatomic, strong) UIButton * loginButton;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
	// Do any additional setup after loading the view, typically from a nib.
    if (![PFUser currentUser]) {
        [self createIntroductionView];
    }
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Questing", @"Creating", @"Viewing"]];
    [self.segmentedControl setSelectionLocation:HMSegmentedControlSelectionLocationDown];
    [self.segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleBox];
    [self.segmentedControl setFrame:CGRectMake(0, 44, 320, 50)];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
    [self.tableView addPullToRefreshWithActionHandler:^(){
        PFQuery * query = [Quest query];
        switch (self.segmentedControl.selectedSegmentIndex) {
            case 0:
                [query whereKey:@"owner" equalTo:[PFUser currentUser]];
                break;
            case 1:
                [query whereKey:@"owner" equalTo:[PFUser currentUser]];
                break;
            case 2:
                [query whereKey:@"owner" equalTo:[PFUser currentUser]];
                break;
                
            default:
                break;
        }
        [query setCachePolicy:kPFCachePolicyNetworkOnly];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error){
            int64_t delayInSeconds = 1.0; //SVPullToRefresh doesn't animate properly if task is less than 1.0 secs.
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.quests = [objects mutableCopy];
                [self.tableView.pullToRefreshView stopAnimating];
                [self.tableView reloadData];
            });
        }];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^(){
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    if (![PFUser currentUser]) {
        [self.introductionView showInView:self.view];
    }
    [self.tableView triggerPullToRefresh];
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

-(void)segmentedControlChangedValue:(HMSegmentedControl *) segmentedControl{
    [self.tableView triggerPullToRefresh];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.quests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Quest * quest = [self.quests objectAtIndex:indexPath.row];
    cell.textLabel.text = quest.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedSettings:(id)sender {
    
}

- (IBAction)pressedCreate:(id)sender {
    CreateQuestViewController * createQuestViewController = [[CreateQuestViewController alloc] initWithNibName:@"CreateQuestViewController" bundle:[NSBundle mainBundle]];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:createQuestViewController];

    [self presentViewController:navigationController animated:YES completion:nil];
}
@end
