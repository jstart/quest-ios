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
#import "QuestStyledTableViewCell.h"
#import "Foursquare2.h"
#import "UIBarButtonItem+ImageButton.h"
#import "UIColor+Expanded.h"

#import "Quest.h"

@interface HomeViewController () <MYIntroductionDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) UIButton * loginButton;
@property (nonatomic, strong) UIButton * foursquareLoginButton;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Quest";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorColor:[UIColor colorWithHexString:@"606a76"]];
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"navbarShadow"];

    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"agsquare"]]];
    self.tableView.backgroundView = backgroundView;
    
	// Do any additional setup after loading the view, typically from a nib.
    if (![PFUser currentUser]) {
        [self createIntroductionView];
    }
        
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Joined", @"Created", @"Viewing"]];
    [self.segmentedControl setSelectionLocation:HMSegmentedControlSelectionLocationUp];
    [self.segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleBox];
    [self.segmentedControl setFrame:CGRectMake(0, 0, 320, 50)];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.segmentedControl.layer setShadowOffset:CGSizeMake(1, 1)];
    [self.segmentedControl.layer setShadowOpacity:0.5];
    [self.segmentedControl.layer setShadowRadius:1.0];
    [self.view addSubview:self.segmentedControl];
        
    [self.tableView addPullToRefreshWithActionHandler:^(){
        PFQuery * query = [Quest query];
        if ([PFUser currentUser]) {
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
        } else{
            [self.tableView.pullToRefreshView stopAnimating];
        }

    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^(){
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
    
    [self.tableView.pullToRefreshView setBackgroundColor:[UIColor colorWithHexString:@"4d5967"]];
    [self.tableView.pullToRefreshView setTextColor:[UIColor whiteColor]];
    [self.tableView.pullToRefreshView setArrowColor:[UIColor whiteColor]];
    
    UIBarButtonItem * settingsButton = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"Settings"] forState:UIControlStateNormal target:self action:@selector(showSettings)];
    self.navigationItem.leftBarButtonItem = settingsButton;
    
    UIBarButtonItem * createButton = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal target:self action:@selector(showCreate)];
    self.navigationItem.rightBarButtonItem = createButton;
    
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


- (void)showCreate {
    CreateQuestViewController * createQuestViewController = [[CreateQuestViewController alloc] initWithNibName:@"CreateQuestViewController" bundle:[NSBundle mainBundle]];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:createQuestViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)showSettings{
    
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
        self.loginButton.frame = CGRectMake(self.introductionView.ContentScrollView.contentOffset.x + 320/2 - 200/2, self.introductionView.frame.size.height - 50 - 65 - 36 - 100, 200, 50);
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
    if (panelIndex == 2 && ![[self.introductionView subviews] containsObject:self.loginButton]) {
        self.foursquareLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.foursquareLoginButton.frame = CGRectMake(self.introductionView.ContentScrollView.contentOffset.x + 320/2 - 200/2, self.introductionView.frame.size.height - 50 - 65 - 36 - 100, 200, 50);
        [self.foursquareLoginButton setTitle:@"Login With Foursquare" forState:UIControlStateNormal];
        [self.foursquareLoginButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton * button){
            [self.introductionView hideWithFadeOutDuration:0.2];
            [Foursquare2 authorizeWithCallback:^(BOOL success, NSError * error){
                if (!error) {
                    NSLog(@"Uh oh. The user cancelled the Foursquare login. %@", error);
                } else if (success) {
                    NSLog(@"New User logged in with foursquare.");
                }
            } fromViewController:self];
        }];
        self.foursquareLoginButton.alpha = 0.0;
        [self.introductionView.ContentScrollView addSubview:self.foursquareLoginButton];
        [UIView animateWithDuration:0.2 animations:^() {
            self.foursquareLoginButton.alpha = 1.0;
        }];
    }
    else{
        [UIView animateWithDuration:0.2 animations:^() {
            self.foursquareLoginButton.alpha = 0.0;
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
    QuestStyledTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[QuestStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        [cell setSelectedBackgroundViewGradientColors:[NSArray arrayWithObjects:[UIColor colorWithHexString:@"57b6ad"].CGColor, [UIColor colorWithHexString:@"29d4be"].CGColor, nil]];
//        [cell setSelectionGradientDirection:StyledTableViewCellSelectionGradientDirectionVertical];
    }
    Quest * quest = [self.quests objectAtIndex:indexPath.row];
    cell.textLabel.text = quest.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
