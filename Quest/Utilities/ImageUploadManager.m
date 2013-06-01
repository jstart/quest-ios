//
//  ImageUploadManager.m
//  
//
//  Created by Christopher Truman on 31/05/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ImageUploadManager.h"
#import <Parse/Parse.h>
#import <MTStatusBarOverlay.h>
#import "QuestActivity.h"
#import "NSRunLoop+TimeOutAndFlag.h"

@interface ImageUploadManager () <MTStatusBarOverlayDelegate>

@property (nonatomic, strong) NSOperationQueue * operationQueue;
@property (nonatomic, strong) NSNumber * currentOperation;

@end

@implementation ImageUploadManager 

+ (id)sharedImageUploadManager {
	static dispatch_once_t predicate;
	static ImageUploadManager *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}

-(id)init{
    if (self = [super init]) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue setMaxConcurrentOperationCount:1];
        MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
        overlay.animation = MTStatusBarOverlayAnimationFallDown;  // MTStatusBarOverlayAnimationShrink
        overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
        overlay.delegate = self;
        overlay.progress = 0.0;
        self.currentOperation = @(0);
    }
    return self;
}

-(void)uploadImage:(UIImage *) image toActivity:(QuestActivity *)activity{
    self.currentOperation = @(self.currentOperation.integerValue + 1);
    [self.operationQueue addOperationWithBlock:^() {
        __block BOOL found;
        NSString * formattedMessage;
        if (self.currentOperation.integerValue == self.operationQueue.operationCount) {
            formattedMessage = @"Uploading Image";
        }else{
            formattedMessage = [NSString stringWithFormat:@"Uploading Image %@/%d", self.currentOperation, self.operationQueue.operationCount];
        }
        [[MTStatusBarOverlay sharedInstance] postMessage:formattedMessage];
        NSData * data = UIImagePNGRepresentation(image);
        PFFile * imageFile = [PFFile fileWithData:data];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error) {
                NSLog(@"%@", error);
                [[MTStatusBarOverlay sharedInstance] postImmediateErrorMessage:@"Upload Failed" duration:2.0 animated:YES];
                self.currentOperation = @(self.currentOperation.integerValue - 1);
                found = YES;
            }
            if (succeeded) {
                activity.image = imageFile;
            }
            [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (error) {
                    NSLog(@"%@", error);
                    [[MTStatusBarOverlay sharedInstance] postImmediateErrorMessage:@"Upload Failed" duration:2.0 animated:YES];
                    self.currentOperation = @(self.currentOperation.integerValue - 1);
                    found = YES;
                }
                [[MTStatusBarOverlay sharedInstance] postImmediateFinishMessage:@"Complete" duration:2.0 animated:YES];
                self.currentOperation = @(self.currentOperation.integerValue - 1);
                found = YES;
            }];
        } progressBlock:^(int percentDone){
            [MTStatusBarOverlay sharedInstance].progress = ((double)percentDone)/100.0;
        }];
        [[NSRunLoop currentRunLoop] runUntilTimeout:300 orFinishedFlag:&found];
    }];
    if (self.operationQueue.operations.count > 1) {
        [[[self.operationQueue operations] lastObject] addDependency:[[self.operationQueue operations] objectAtIndex:self.operationQueue.operations.count - 2]];
    }
}

@end
