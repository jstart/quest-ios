//
//  AddWaypointViewController.m
//  Quest
//
//  Created by Christopher Truman on 25/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "AddWaypointViewController.h"
#import "MLPAutoCompleteTextField.h"
#import <QuartzCore/QuartzCore.h>
#import <UIColor+Expanded.h>
#import <XCDFormInputAccessoryView.h>
//#import "Foursquare2.h"
#import <CoreLocation/CoreLocation.h>
#import "RCLocationManager.h"
#import "UIBarButtonItem+ImageButton.h"
#import <SSToolkit.h>
#import "Waypoint.h"
#import "Quest.h"

@interface AddWaypointViewController () <UITextFieldDelegate> //MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate,

//@property (nonatomic, strong) MLPAutoCompleteTextField * autoCompleteTextField;
@property (nonatomic, strong) CLLocation * currentLocation;
//@property (nonatomic, strong) NSMutableArray * foursquareResults;
@property (weak, nonatomic) IBOutlet SSTextField *titleField;
@property (weak, nonatomic) IBOutlet SSTextField *youtubeField;
@property (nonatomic, strong) XCDFormInputAccessoryView * inputAccessoryView;

@end

@implementation AddWaypointViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Add a Waypoint";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"agsquare"]]];
    
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
    
    [self.titleField setFont:[UIFont fontWithName:@"Avenir-Black" size:17]];
    [self.titleField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [self.titleField setTextEdgeInsets:UIEdgeInsetsMake(15, 15, 0, 0)];
    [self.titleField setClearButtonEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.titleField.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    self.titleField.layer.borderWidth = 1;
    [self.titleField setDelegate:self];
    
    [self.youtubeField setFont:[UIFont fontWithName:@"Avenir-Black" size:14]];
    [self.youtubeField setTextEdgeInsets:UIEdgeInsetsMake(15, 15, 0, 0)];
    [self.youtubeField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    self.youtubeField.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    self.youtubeField.layer.borderWidth = 1;
    [self.youtubeField setDelegate:self];
    
    self.inputAccessoryView = [[XCDFormInputAccessoryView alloc] init];
    [self.inputAccessoryView setHasDoneButton:NO animated:NO];
    
//    self.autoCompleteTextField = [[MLPAutoCompleteTextField alloc] initWithFrame:CGRectMake(0, -1, 325, 40)];
//    self.autoCompleteTextField.placeholder = @"Enter a location";
//    self.autoCompleteTextField.delegate = self;
//    self.autoCompleteTextField.autoCompleteDataSource = self;
//    self.autoCompleteTextField.autoCompleteDelegate = self;
//    self.autoCompleteTextField.font = [UIFont fontWithName:@"Avenir-Light" size:26];
//    self.autoCompleteTextField.maximumNumberOfAutoCompleteRows = 6;
//    self.autoCompleteTextField.autoCompleteFontSize = 16;
//    self.autoCompleteTextField.autoCompleteRegularFontName = @"Avenir-Light";
//    self.autoCompleteTextField.autoCompleteBoldFontName = @"Avenir-Black";
//    [self.autoCompleteTextField setAutoCompleteTableAppearsAsKeyboardAccessory:YES];
//    [self.autoCompleteTextField setBorderStyle:UITextBorderStyleLine];
//    [self.view addSubview:self.autoCompleteTextField];
//    [[RCLocationManager sharedManager] startUpdatingLocationWithBlock:^(CLLocationManager * manager, CLLocation * newLocation, CLLocation * oldLocation){
//        self.currentLocation = newLocation;
//        [Foursquare2 searchVenuesNearByLatitude:@(self.currentLocation.coordinate.latitude) longitude:@(self.currentLocation.coordinate.longitude) accuracyLL:@(0) altitude:@(0) accuracyAlt:@(0) query:@"" limit:@(10) intent:intentBrowse radius:@(50) callback:^(BOOL success, id result){
//            NSArray * resultsArray = [[result objectForKey:@"response"] objectForKey:@"venues"];
//            NSArray * nameArray = [resultsArray mutableArrayValueForKey:@"name"];
//            self.foursquareResults = [nameArray copy];
//        }];
//        
//        [[RCLocationManager sharedManager] stopUpdatingLocation];
//    } errorBlock:^(CLLocationManager * manager, NSError * error){
//        
//    }];
}

-(void)textFieldChanged{
    if (!((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]).isSelected && self.titleField.text.length > 0 && self.youtubeField.text.length > 0) {
        [((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]) setEnabled:YES];
        [((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]) setSelected:YES];
        [self.inputAccessoryView setHasDoneButton:YES animated:YES];
    } else if(((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]).isSelected && self.titleField.text.length < 1 && self.youtubeField.text.length < 1){
        [((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]) setEnabled:NO];
        [((UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews objectAtIndex:0]) setSelected:NO];
        [self.inputAccessoryView setHasDoneButton:NO animated:YES];
    }
}

-(void)close{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)done{
    SSHUDView *hud = [[SSHUDView alloc] initWithTitle:@"Creating Waypoint..." loading:YES];
	[hud show];
    Waypoint * waypoint = [Waypoint object];
    waypoint.name = self.titleField.text;
    waypoint.youtubeURLString = self.youtubeField.text;
    waypoint.order = self.order;
    waypoint.quest = self.quest;
    [waypoint saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
        [self.quest.waypoints addObject:waypoint];
        [self.quest saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
            [hud completeAndDismissWithTitle:@"Created!"];
            [self close];
        }];
    }];
}

//#pragma mark - MLPAutoCompleteTextField
//- (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField possibleCompletionsForString:(NSString *)string{
//    return self.foursquareResults;
//}

//- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
//shouldStyleAutoCompleteTableView:(UITableView *)autoCompleteTableView
//               forBorderStyle:(UITextBorderStyle)borderStyle{
//    return YES;
//}
//
//- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
//          shouldConfigureCell:(UITableViewCell *)cell
//       withAutoCompleteString:(NSString *)autocompleteString
//         withAttributedString:(NSAttributedString *)boldedString
//            forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return YES;
//}
//
//- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
//  didSelectAutoCompleteString:(NSString *)selectedString
//            forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}
//
//- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
//willShowAutoCompleteTableView:(UITableView *)autoCompleteTableView{
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
