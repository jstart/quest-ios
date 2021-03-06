//
//  IntroductionPanelCreator.h
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBFlatButton;

@interface IntroductionPanelCreator : NSObject

+(NSArray *)createIntroductionPanelsFromArray:(NSArray *) introductionArray;
+(QBFlatButton *)buttonForInputType:(NSString*)inputType;

@end
