//
//  ImageUploadManager.h
//  
//
//  Created by Christopher Truman on 31/05/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@class QuestActivity;

@interface ImageUploadManager : NSObject

+ (id)sharedImageUploadManager;

- (void)uploadImage:(UIImage *) image toActivity:(QuestActivity *)activity;

@end
