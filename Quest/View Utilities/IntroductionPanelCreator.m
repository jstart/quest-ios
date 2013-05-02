//
//  IntroductionPanelCreator.m
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "IntroductionPanelCreator.h"
#import "MYIntroductionPanel.h"
#import "UIControl+ALActionBlocks.h"

@implementation IntroductionPanelCreator

+(NSArray *)createIntroductionPanelsFromArray:(NSArray *) introductionArray{
    NSMutableArray * panelArray = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in introductionArray) {
        NSString * text = dict[@"text"];
        NSString * image = dict[@"image"];
        NSNumber * requiresInput = dict[@"requiresInput"];
        MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithImage:[UIImage imageNamed:image] description:text];
        panel.requiresInput = [requiresInput boolValue];
        [panelArray addObject:panel];
        panel.inputButton = [IntroductionPanelCreator buttonForInputType:dict[@"inputType"]];
    }
    return panelArray;
}

+(UIButton *)buttonForInputType:(NSString*)inputType{
    if ([inputType isEqualToString:@"location"]) {
        return [IntroductionPanelCreator locationButton];
    } else if ([inputType isEqualToString:@"foursquare"]) {
        return [IntroductionPanelCreator foursquareButton];
    } else if ([inputType isEqualToString:@"facebook"]) {
        return [IntroductionPanelCreator facebookButton];
    }
    return nil;
}

+(UIButton*)locationButton{
    UIButton * locationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    locationButton.frame = CGRectMake(0, 0, 200, 50);
    [locationButton setTitle:@"Enable Location" forState:UIControlStateNormal];
    [locationButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton * button){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationRequired" object:nil];
    }];
    locationButton.alpha = 1.0;
    return locationButton;
}


+(UIButton*)facebookButton{
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(0, 0, 200, 50);
    [loginButton setTitle:@"Login With Facebook" forState:UIControlStateNormal];
    [loginButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton * button){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookLogin" object:nil];
    }];
    loginButton.alpha = 1.0;
    return loginButton;
}

+(UIButton*)foursquareButton{
    UIButton * foursquareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    foursquareButton.frame = CGRectMake(0, 0, 200, 50);
    [foursquareButton setTitle:@"Login With Foursquare" forState:UIControlStateNormal];
    [foursquareButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton * button){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FoursquareLogin" object:nil];
    }];
    foursquareButton.alpha = 1.0;
    return foursquareButton;
}


@end
