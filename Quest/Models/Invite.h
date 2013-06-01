//
//  Invite.h
//  Invite
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import <Parse/Parse.h>

@class Quest;

@interface Invite : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString * inviteeFacebookID;
@property (nonatomic, strong) PFUser * inviter;
@property (nonatomic, strong) NSNumber * hasAccepted;
@property (nonatomic, strong) Quest * quest;

@end
