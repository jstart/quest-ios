//
//  HomeViewController.m
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "HomeViewController.h"
#import <Accounts/Accounts.h>
#import <Facebook.h>
#import <Parse/Parse.h>
#import "UIControl+ALActionBlocks.h"
#import "Invite.h"
#import "Quest.h"
#import "MYIntroductionView.h"
#import "IntroductionPanelCreator.h"
#import "CreateQuestViewController.h"
#import "SVPullToRefresh.h"
#import "HMSegmentedControl.h"
#import "QuestStyledTableViewCell.h"
#import <MBAlertView.h>
//#import "Foursquare2.h"
#import "UIBarButtonItem+ImageButton.h"
#import "UIColor+Expanded.h"
#import "RCLocationManager.h"
#import "QuestViewController.h"
#import "ActiveQuestViewController.h"
#import "Quest.h"

@interface HomeViewController () <MYIntroductionDelegate, UITableViewDataSource, UITableViewDelegate, RCLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) NSMutableArray * createdQuests;
@property (nonatomic, strong) NSMutableArray * joinedQuests;
@property (nonatomic, strong) NSMutableArray * viewingQuests;

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
        [self.navigationController setNavigationBarHidden:YES animated:YES];
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
                    [query whereKey:@"questers" equalTo:[PFUser currentUser]];
                    break;
                case 1:
                    [query whereKey:@"owner" equalTo:[PFUser currentUser]];
                    break;
                case 2:
                    [query whereKey:@"viewers" equalTo:[PFUser currentUser]];
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
                    switch (self.segmentedControl.selectedSegmentIndex) {
                        case 0:
                            self.joinedQuests = [objects mutableCopy];
                            break;
                        case 1:
                            self.createdQuests = [objects mutableCopy];
                            break;
                        case 2:
                            self.viewingQuests = [objects mutableCopy];
                            break;
                            
                        default:
                            break;
                    }

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLogin) name:@"FacebookLogin" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foursquareLogin) name:@"FoursquareLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationAuthorization) name:@"LocationRequired" object:nil];
    
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
    self.introductionView.skipButton.hidden = YES;
    
    [self.introductionView setBackgroundColor:[UIColor colorWithHexString:@"8bcfb6"]];
    
    //Set delegate to self for callbacks (optional)
    self.introductionView.delegate = self;
    
    //STEP 3: Show introduction view
    [self.introductionView showInView:self.view];
}

- (void)showCreate {
    CreateQuestViewController * createQuestViewController = [[CreateQuestViewController alloc] init];
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
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2];
//    panel.inputButton.alpha = 1.0;
//    [UIView commitAnimations];
}

-(void)facebookLogin{
    [PFFacebookUtils logInWithPermissions:@[@"email"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            [PFFacebookUtils initializeFacebook];
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self.introductionView hideWithFadeOutDuration:0.2];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [user save];
            [[self tableView] triggerPullToRefresh];
            [self acceptInvites];
        } else {
            NSLog(@"User logged in through Facebook!");
            [self.introductionView hideWithFadeOutDuration:0.2];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [user save];
            [[self tableView] triggerPullToRefresh];
            [self acceptInvites];
        }
    }];
}

-(void)acceptInvites{
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                         id result,
                                                          NSError *error){
        if (error) {
            NSLog(@"%@", error);
        }else{
            NSString * facebookID = [result objectForKey:@"id"];
            PFQuery * query = [PFQuery queryWithClassName:@"Invite"];
            [query whereKey:@"inviteeFacebookID" equalTo:facebookID];
            [query includeKey:@"inviter"];
            [query includeKey:@"quest"];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * invite, NSError * error) {
                if (error) {
                    NSLog(@"%@", error);
                }
                else if (![[(Invite *)invite hasAccepted] boolValue]) {
                    PFQuery * query = [PFUser query];
                    [query whereKey:@"username" equalTo:[(Invite *)invite inviter].username];
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject * object, NSError * error) {
                        NSString * formattedAlertText = [NSString stringWithFormat:@"You have been invited to join the quest named: %@ ", [(Invite *)invite quest].name];
                        MBAlertView * alert = [MBAlertView alertWithBody:formattedAlertText cancelTitle:@"Ok" cancelBlock:^(){
                            [(Invite*) invite setHasAccepted:[NSNumber numberWithBool:YES]];
                            [invite save];
                            [[[(Invite *)invite quest] relationforKey:@"questers"] addObject:[PFUser currentUser]];
                            [[(Invite *)invite quest] save];
                            [self.tableView triggerPullToRefresh];
                        }];
                        [alert addToDisplayQueue];
                    }];
                }
            }];
        }
    }];
}

//-(void)foursquareLogin{
//    [Foursquare2 authorizeWithCallback:^(BOOL success, NSError * error){
//        if (error) {
//            NSLog(@"Uh oh. The user cancelled the Foursquare login. %@", error);
//        } else if (success) {
//            NSLog(@"New User logged in with foursquare.");
//            [self.introductionView continueToNextPanel];
//        }
//    } fromViewController:self];
//}

-(void)locationAuthorization{
    [[RCLocationManager sharedManager] setPurpose:@"Quest would like to help guide you and your friends based on location."];
    [[RCLocationManager sharedManager] setRegionDesiredAccuracy:50.0];
    [[RCLocationManager sharedManager] startUpdatingLocationWithBlock:^(CLLocationManager * manager, CLLocation * newLocation, CLLocation * oldLocation){
        [self.introductionView continueToNextPanel];
        [[RCLocationManager sharedManager] stopUpdatingLocation];
    } errorBlock:^(CLLocationManager * manager, NSError * error){
    }];
}


-(void)segmentedControlChangedValue:(HMSegmentedControl *) segmentedControl{
    [self.tableView reloadData];
    [self.tableView triggerPullToRefresh];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            return self.joinedQuests.count;
            break;
        case 1:
            return self.createdQuests.count;
            break;
        case 2:
            return self.viewingQuests.count;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cellIdentifier";
    QuestStyledTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[QuestStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        [cell setSelectedBackgroundViewGradientColors:[NSArray arrayWithObjects:[UIColor colorWithHexString:@"57b6ad"].CGColor, [UIColor colorWithHexString:@"29d4be"].CGColor, nil]];
//        [cell setSelectionGradientDirection:StyledTableViewCellSelectionGradientDirectionVertical];
    }
    
    Quest * quest = [self questAtIndex:indexPath.row];
    cell.textLabel.text = quest.name;
    
    return cell;
}

-(Quest *)questAtIndex:(int)index{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            return [self.joinedQuests objectAtIndex:index];
            break;
        case 1:
            return [self.createdQuests objectAtIndex:index];
            break;
        case 2:
//            return [self.viewingQuests objectAtIndex:index];
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showQuestWithIndex:indexPath.row];
}

-(void)showQuestWithIndex:(int)index{
    Quest * quest = [self questAtIndex:index];
    UIViewController * nextViewController = nil;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            nextViewController = [ActiveQuestViewController viewControllerForQuest:quest];
            break;
        case 1:
            nextViewController = [QuestViewController viewControllerForQuest:quest withActionType:QuestViewControllerActionTypeDismiss];
            break;
        case 2:
//            return [self.viewingQuests objectAtIndex:index];
            break;
            
        default:
            break;
    }
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:nextViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.0f;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
