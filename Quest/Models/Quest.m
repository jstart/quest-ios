//
//  Quest.m
//  Quest
//
//  Created by Christopher Truman on 04/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "Quest.h"
#import <Parse/PFObject+Subclass.h>


@implementation Quest
@dynamic name, description, owner, viewers, questers, waypoints;

+ (NSString *)parseClassName {
    return @"Quest";
}

-(void)registerOwnerForPushNotifications{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSString * channelName = [self ownerChannelName];
    [currentInstallation addUniqueObject:channelName forKey:@"channels"];
    [currentInstallation saveInBackground];
}

-(void)registerViewerForPushNotifications{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSString * channelName = [self viewerChannelName];
    [currentInstallation addUniqueObject:channelName forKey:@"channels"];
    [currentInstallation saveInBackground];
}

-(void)registerJoinerForPushNotifications{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSString * channelName = [self joinerChannelName];
    [currentInstallation addUniqueObject:channelName forKey:@"channels"];
    [currentInstallation saveInBackground];
}

-(NSString*)ownerChannelName{
    return [NSString stringWithFormat:@"quest_owner-%@", self.objectId];
}

-(NSString*)viewerChannelName{
    return [NSString stringWithFormat:@"quest_viewer-%@", self.objectId];
}

-(NSString*)joinerChannelName{
    return [NSString stringWithFormat:@"quest_joiner-%@", self.objectId];
}

@end
