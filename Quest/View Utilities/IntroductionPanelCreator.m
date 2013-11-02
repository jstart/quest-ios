//
//  IntroductionPanelCreator.m
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "IntroductionPanelCreator.h"
#import <MYIntroductionPanel.h>
#import <UIControl+ALActionBlocks.h>
#import <QBFlatButton.h>
#import <UIColor+Expanded.h>

@implementation IntroductionPanelCreator

+(NSArray *)createIntroductionPanelsFromArray:(NSArray *) introductionArray{
    NSMutableArray * panelArray = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in introductionArray) {
        NSString * text = dict[@"text"];
        NSString * image = dict[@"image"];
        NSNumber * requiresInput = dict[@"requiresInput"];
        NSNumber * hasGIF = dict[@"hasGIF"];
        MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithImageName:image description:text];
        panel.requiresInput = [requiresInput boolValue];
        panel.hasGIF = [hasGIF boolValue];
        [panelArray addObject:panel];
        panel.inputButton = [IntroductionPanelCreator buttonForInputType:dict[@"inputType"]];
    }
    return panelArray;
}

+(QBFlatButton *)buttonForInputType:(NSString*)inputType{
    if ([inputType isEqualToString:@"location"]) {
        return [IntroductionPanelCreator locationButton];
    } else if ([inputType isEqualToString:@"foursquare"]) {
        return [IntroductionPanelCreator foursquareButton];
    } else if ([inputType isEqualToString:@"facebook"]) {
        return [IntroductionPanelCreator facebookButton];
    }else if ([inputType isEqualToString:@"notifications"]) {
        return [IntroductionPanelCreator notificationsButton];
    }else if ([inputType isEqualToString:@"next"]) {
        return [IntroductionPanelCreator nextButton];
    }
    return nil;
}

+(QBFlatButton*)nextButton{
    QBFlatButton * nextButton = [[QBFlatButton alloc] init];
    [nextButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    nextButton.frame = CGRectMake(0, 0, 200, 50);
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton * button){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Next" object:nil];
    }];
    nextButton.alpha = 1.0;
    return nextButton;
}

+(QBFlatButton*)locationButton{
    QBFlatButton * locationButton = [[QBFlatButton alloc] init];
    [locationButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    locationButton.frame = CGRectMake(0, 0, 200, 50);
    [locationButton setTitle:@"Enable Location" forState:UIControlStateNormal];
    [locationButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton * button){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationRequired" object:nil];
    }];
    locationButton.alpha = 1.0;
    return locationButton;
}

+(QBFlatButton *)notificationsButton{
    QBFlatButton * notificationButton = [[QBFlatButton alloc] init];
    [notificationButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    notificationButton.frame = CGRectMake(0, 0, 200, 50);
    [notificationButton setTitle:@"Enable Notifications" forState:UIControlStateNormal];
    [notificationButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton * button){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsRequired" object:nil];
    }];
    notificationButton.alpha = 1.0;
    return notificationButton;
}

+(QBFlatButton *)facebookButton{
    QBFlatButton * loginButton = [[QBFlatButton alloc] init];
    [loginButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    loginButton.frame = CGRectMake(0, 0, 200, 50);
    [loginButton setTitle:@"Login With Facebook" forState:UIControlStateNormal];
    [loginButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton * button){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookLogin" object:nil];
    }];
    loginButton.alpha = 1.0;
    [loginButton setFaceColor:[UIColor colorWithHexString:@"3b5999"] forState:UIControlStateNormal];
    [loginButton setSideColor:[UIColor blackColor] forState:UIControlStateNormal];
    return loginButton;
}

+(QBFlatButton *)foursquareButton{
    QBFlatButton * foursquareButton = [[QBFlatButton alloc] init];
    [foursquareButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    foursquareButton.frame = CGRectMake(0, 0, 200, 50);
    [foursquareButton setTitle:@"Login With Foursquare" forState:UIControlStateNormal];
    [foursquareButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton * button){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FoursquareLogin" object:nil];
    }];
    foursquareButton.alpha = 1.0;
    return foursquareButton;
}

@end
