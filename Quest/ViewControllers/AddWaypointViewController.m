//
//  AddWaypointViewController.m
//  Quest
//
//  Created by Christopher Truman on 25/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "AddWaypointViewController.h"
#import "MLPAutoCompleteTextField.h"
#import "Foursquare2.h"

@interface AddWaypointViewController () <MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MLPAutoCompleteTextField * autoCompleteTextField;

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
    
    self.autoCompleteTextField = [[MLPAutoCompleteTextField alloc] initWithFrame:CGRectMake(0, 40, 320, 40)];
    self.autoCompleteTextField.delegate = self;
    self.autoCompleteTextField.autoCompleteDataSource = self;
    self.autoCompleteTextField.autoCompleteDelegate = self;
}

#pragma mark - MLPAutoCompleteTextField
- (NSArray *)possibleAutoCompleteSuggestionsForString:(NSString *)string{
//    [Foursquare2 searchVenuesNearByLatitude:<#(NSNumber *)#> longitude:<#(NSNumber *)#> accuracyLL:<#(NSNumber *)#> altitude:<#(NSNumber *)#> accuracyAlt:<#(NSNumber *)#> query:<#(NSString *)#> limit:<#(NSNumber *)#> intent:intentBrowse radius:@(50) callback:^(BOOL success, id result){
//    }];
    return @[];
}

- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
shouldStyleAutoCompleteTableView:(UITableView *)autoCompleteTableView
               forBorderStyle:(UITextBorderStyle)borderStyle{
    return YES;
}

- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
            forRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
            forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
willShowAutoCompleteTableView:(UITableView *)autoCompleteTableView{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
