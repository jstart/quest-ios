//
//  QuestYouTubeVideoPlayerViewController.m
//  Quest
//
//  Created by Christopher Truman on 30/05/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "QuestYouTubeVideoPlayerViewController.h"

@interface QuestYouTubeVideoPlayerViewController ()

@end

@implementation QuestYouTubeVideoPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"quest-navbar-landscape"] forBarMetrics:UIBarMetricsLandscapePhone];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

@end
