//
//  AddWaypointViewController.m
//  Quest
//
//  Created by Christopher Truman on 25/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "WaypointDetailViewController.h"
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
#import "QuestActivity.h"

#import <FlatUIKit/FUIButton.h>
#import <HCYoutubeParser.h>
#import <ZBarSDK.h>
#import "QuestYouTubeVideoPlayerViewController.h"
#import "ImageUploadManager.h"

@interface WaypointDetailViewController () <UITextFieldDelegate, ZBarReaderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//@property (nonatomic, strong) MLPAutoCompleteTextField * autoCompleteTextField;
@property (nonatomic, strong) CLLocation * currentLocation;
//@property (nonatomic, strong) NSMutableArray * foursquareResults;
@property (weak, nonatomic) IBOutlet FUIButton *videoButton;
@property (weak, nonatomic) IBOutlet FUIButton *scanButton;
@property (weak, nonatomic) IBOutlet FUIButton *takePhotoButton;


@property (nonatomic, strong) XCDFormInputAccessoryView * inputAccessoryView;

- (IBAction)showVideo:(id)sender;
- (IBAction)scanCode:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end

@implementation WaypointDetailViewController

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
    self.title = self.waypoint.name;
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
    
    self.videoButton.buttonColor = [UIColor colorWithHexString:@"8bcfb6"];
    self.videoButton.shadowColor = [UIColor colorWithHexString:@"57b6ad"];
    self.videoButton.shadowHeight = 3.0f;
    self.videoButton.cornerRadius = 6.0f;
    self.videoButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:20];
    [self.videoButton setTitleColor:[UIColor colorWithHexString:@"4d5967"] forState:UIControlStateNormal];
    [self.videoButton setTitleColor:[UIColor colorWithWhite:0.950 alpha:1.000] forState:UIControlStateHighlighted];
    
    self.scanButton.buttonColor = [UIColor colorWithHexString:@"8bcfb6"];
    self.scanButton.shadowColor = [UIColor colorWithHexString:@"57b6ad"];
    self.scanButton.shadowHeight = 3.0f;
    self.scanButton.cornerRadius = 6.0f;
    self.scanButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:20];
    [self.scanButton setTitleColor:[UIColor colorWithHexString:@"4d5967"] forState:UIControlStateNormal];
    [self.scanButton setTitleColor:[UIColor colorWithWhite:0.950 alpha:1.000] forState:UIControlStateHighlighted];

    self.takePhotoButton.buttonColor = [UIColor colorWithHexString:@"8bcfb6"];
    self.takePhotoButton.shadowColor = [UIColor colorWithHexString:@"57b6ad"];
    self.takePhotoButton.shadowHeight = 3.0f;
    self.takePhotoButton.cornerRadius = 6.0f;
    self.takePhotoButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:20];
    [self.takePhotoButton setTitleColor:[UIColor colorWithHexString:@"4d5967"] forState:UIControlStateNormal];
    [self.takePhotoButton setTitleColor:[UIColor colorWithWhite:0.950 alpha:1.000] forState:UIControlStateHighlighted];
    
    self.inputAccessoryView = [[XCDFormInputAccessoryView alloc] init];
    [self.inputAccessoryView setHasDoneButton:NO animated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    PFQuery * query = [PFQuery queryWithClassName:@"QuestActivity"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"waypoint" equalTo:self.waypoint];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * object, NSError * error) {
        if (error || object == nil) {
            QuestActivity * activity = [QuestActivity object];
            activity.user = [PFUser currentUser];
            activity.waypoint = self.waypoint;
            activity.hasCompleted = [NSNumber numberWithBool:NO];
            [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (error) {
                    NSLog(@"%@", error);
                }
                self.activity = activity;
            }];
        }else{
            self.activity = (QuestActivity *) object;
        }
    }];

}

-(void)close{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)done{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showVideo:(id)sender {
    NSString * youtubeID = [HCYoutubeParser youtubeIDFromYoutubeURL:[NSURL URLWithString:self.waypoint.youtubeURLString]];
    QuestYouTubeVideoPlayerViewController * youtubeVideoPlayerViewController = [[QuestYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:youtubeID];
    [self presentViewController:youtubeVideoPlayerViewController animated:YES completion:nil];
}

- (IBAction)scanCode:(id)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    [reader setTracksSymbols:YES];
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [scanner setSymbology: ZBAR_ADDON
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [scanner setSymbology: ZBAR_ADDON2
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [scanner setSymbology: ZBAR_ADDON5
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentViewController:reader animated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    if ([reader isKindOfClass:[ZBarReaderViewController class]]) {
        // ADD: get the decode results
        SSHUDView * hud = [[SSHUDView alloc] initWithTitle:@"Checking..." loading:YES];
        [hud show];
        id<NSFastEnumeration> results =
        [info objectForKey: ZBarReaderControllerResults];
        ZBarSymbol *symbol = nil;
        for(ZBarSymbol *aSymbol in results){
            symbol = aSymbol;
        }
        NSLog(@"%@", [symbol data]);
        [reader dismissViewControllerAnimated:YES completion:^(){
            [self.waypoint.quest fetchIfNeeded];
            NSString * formattedString = [NSString stringWithFormat:@"%@-%@", self.waypoint.quest.name, self.waypoint.order];

            if ([[symbol data] isEqualToString:formattedString]) {
                self.activity.hasCompleted = [NSNumber numberWithBool:YES];
                [self.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                    if (error) {
                        NSLog(@"%@", error);
                    }else{
                        [hud completeAndDismissWithTitle:@"You found it!"];
                        [(UIButton *)self.navigationItem.rightBarButtonItem.customView.subviews[0] setEnabled:YES];
                        [(UIButton *)self.navigationItem.rightBarButtonItem.customView.subviews[0] setSelected:YES];
                    }
                }];

            }else{
                [hud failAndDismissWithTitle:@"Wrong QR Code"];
            }
        }];
    }else{
        [reader dismissViewControllerAnimated:YES completion:^(){
            UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            [[ImageUploadManager sharedImageUploadManager] uploadImage:image toActivity:self.activity];
        }];
    }
}

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

@end
