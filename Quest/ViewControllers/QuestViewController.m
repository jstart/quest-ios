//
//  QuestViewController.m
//  Quest
//
//  Created by Christopher Truman on 18/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "QuestViewController.h"
#import "UIBarButtonItem+ImageButton.h"
#import "Quest.h"
#import "QuestStyledTableViewCell.h"
#import "UIColor+Expanded.h"
#import "AddWaypointViewController.h"
#import "Waypoint.h"
#import "Invite.h"
#import "WaypointStyledTableViewCell.h"
#import <SSHUDView.h>
#import <FacebookSDK.h>
#import <MBAlertView.h>

@interface QuestViewController () <FBFriendPickerDelegate, FBViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PFQuery * query;

@property (nonatomic, strong) NSNumber * numberOfWaypoints;

@property (nonatomic, strong) NSMutableArray * waypoints;

@property (nonatomic, strong) FBFriendPickerViewController * friendPickerViewController;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, assign) QuestViewControllerActionType actionType;

@end

@implementation QuestViewController

+(QuestViewController *)viewControllerForQuest:(Quest *)quest withActionType:(QuestViewControllerActionType)actionType {
    QuestViewController * questTableViewController = [[QuestViewController alloc] init];
    questTableViewController.quest = quest;
    questTableViewController.title = quest.name;
    questTableViewController.actionType = actionType;
    return questTableViewController;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 44 - 20) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"agsquare"]]];
    self.tableView.backgroundView = backgroundView;
    [self.tableView setSeparatorColor:[UIColor colorWithHexString:@"606a76"]];
    
    if (self.actionType == QuestViewControllerActionTypeCancel) {
        UIBarButtonItem * cancelButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"Cancel"] forState:UIControlStateNormal target:self action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
    }else{
        UIBarButtonItem * closeButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal target:self action:@selector(close)];
        self.navigationItem.leftBarButtonItem = closeButtonItem;
    }

    
    UIBarButtonItem * checkmarkButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"checkmark_active"] forState:UIControlStateNormal target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = checkmarkButtonItem;
}

- (void)facebookViewControllerCancelWasPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender{
    SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Inviting" loading:YES];

    [self dismissViewControllerAnimated:YES completion:^(){
        [hud show];
        NSArray * friends = [self.friendPickerViewController selection];
        for (NSDictionary * friendDict in friends) {
            Invite * invite = [Invite object];
            invite.inviter = [PFUser currentUser];
            invite.inviteeFacebookID = [friendDict objectForKey:@"id"];
            invite.hasAccepted = [NSNumber numberWithBool:NO];
            invite.quest = self.quest;
            [invite save];
        }
        [hud completeAndDismissWithTitle:@"Invites sent"];
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)done{
    MBAlertView *alert = [MBAlertView alertWithBody:@"You now need to invite friends to join your quest." cancelTitle:@"OK" cancelBlock:^(){
        self.friendPickerViewController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerViewController.delegate = self;
        [self.friendPickerViewController loadData];
        [self presentViewController:self.friendPickerViewController animated:YES completion:nil];
    }];
    [alert addToDisplayQueue];
}

-(void)cancel{
    SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Deleting Quest" loading:YES];
    [hud show];
    [self.quest deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
        [hud completeAndDismissWithTitle:@"Quest Deleted"];
        [self close];
    }];
}

-(void)close{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.query = [PFQuery queryWithClassName:@"Waypoint"];
    [self.query whereKey:@"quest" equalTo:self.quest];
    [self.query orderByAscending:@"order"];
    [self.query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error){
        self.numberOfWaypoints = @(objects.count);
        self.waypoints = [objects mutableCopy];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.numberOfWaypoints integerValue] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.numberOfWaypoints.integerValue && self.numberOfWaypoints.integerValue != 0) {
        static NSString *CellIdentifier = @"Cell";
        WaypointStyledTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[WaypointStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        Waypoint * waypoint = [self.waypoints objectAtIndex:indexPath.row];
        [cell setupWithWaypoint:waypoint];
        
        return cell;
    }else if (indexPath.row >= self.numberOfWaypoints.integerValue || self.numberOfWaypoints.integerValue == 0){
        static NSString *waypointCellIdentifier = @"Add Waypoint";
        QuestStyledTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:waypointCellIdentifier];
        
        if (cell == nil) {
            cell = [[QuestStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:waypointCellIdentifier];
        }
        cell.textLabel.text = @"Add a Way Point +";
        return cell;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    AddWaypointViewController * addWaypointViewController = [[AddWaypointViewController alloc] init];
    addWaypointViewController.quest = self.quest;
    addWaypointViewController.order = @([self.numberOfWaypoints integerValue] + 1);
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:addWaypointViewController];
    [self presentViewController:navigationController animated:YES completion:^() {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.0f;
}

@end
