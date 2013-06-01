//
//  Invite.m
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "Invite.h"
#import <Parse/PFObject+Subclass.h>


@implementation Invite
@dynamic inviteeFacebookID, inviter, hasAccepted, quest;

+ (NSString *)parseClassName {
    return @"Invite";
}

@end
