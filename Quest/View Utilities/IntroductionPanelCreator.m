//
//  IntroductionPanelCreator.m
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "IntroductionPanelCreator.h"
#import "MYIntroductionPanel.h"

@implementation IntroductionPanelCreator

+(NSArray *)createIntroductionPanelsFromArray:(NSArray *) introductionArray{
    NSMutableArray * panelArray = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in introductionArray) {
        NSString * text = dict[@"text"];
        NSString * image = dict[@"image"];
        MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:image] description:text];
        [panelArray addObject:panel];
    }
    return panelArray;
}

@end
