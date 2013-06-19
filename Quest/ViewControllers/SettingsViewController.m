//
//  AddWaypointViewController.m
//  Quest
//
//  Created by Christopher Truman on 25/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "SettingsViewController.h"
#import "MLPAutoCompleteTextField.h"
#import <QuartzCore/QuartzCore.h>
#import <UIColor+Expanded.h>
#import "UIBarButtonItem+ImageButton.h"
#import <SSToolkit.h>

#import <FlatUIKit/FUIButton.h>
#import <HCYoutubeParser.h>
#import <ZBarSDK.h>
#import "QuestYouTubeVideoPlayerViewController.h"
#import "ImageUploadManager.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;

@end

@implementation SettingsViewController

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
    self.title = @"Settings";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"agsquare"]]];
    [self.settingsLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:22]];
    [self.settingsLabel setTextColor:[UIColor colorWithHexString:@"4d5967"]];
    
    UIBarButtonItem * cancelButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"Cancel"] forState:UIControlStateNormal target:self action:@selector(close)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)close{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
