//
//  QuestTableViewController.m
//  Quest
//
//  Created by Christopher Truman on 18/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "QuestTableViewController.h"
#import "UIBarButtonItem+ImageButton.h"
#import "Quest.h"
#import "QuestStyledTableViewCell.h"
#import "UIColor+Expanded.h"

@interface QuestTableViewController ()

@end

@implementation QuestTableViewController

+(QuestTableViewController *)viewControllerForQuest:(Quest *)quest{
    QuestTableViewController * questTableViewController = [[QuestTableViewController alloc] initWithStyle:UITableViewStylePlain];
    questTableViewController.quest = quest;
    questTableViewController.title = quest.name;
    return questTableViewController;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"agsquare"]]];
        self.tableView.backgroundView = backgroundView;
        [self.tableView setSeparatorColor:[UIColor colorWithHexString:@"606a76"]];

        UIBarButtonItem * backButton = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = backButton;
        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.quest.waypoints query].countObjects + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= [self.quest.waypoints query].countObjects && [self.quest.waypoints query].countObjects != 0) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }else if (indexPath.row > [self.quest.waypoints query].countObjects || [self.quest.waypoints query].countObjects == 0){
        static NSString *waypointCellIdentifier = @"Add Waypoint";
        QuestStyledTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:waypointCellIdentifier];
        
        if (cell == nil) {
            cell = [[QuestStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:waypointCellIdentifier];
            cell.textLabel.text = @"Add a Way Point +";
        }
        
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
