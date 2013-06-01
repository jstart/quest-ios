//
//  WaypointStyledTableViewCell.m
//  Quest
//
//  Created by Christopher Truman on 22/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "WaypointStyledTableViewCell.h"
#import "Waypoint.h"

@implementation WaypointStyledTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupWithWaypoint:(Waypoint *)waypoint{
    self.waypoint = waypoint;
    NSString * orderText = [NSString stringWithFormat:@"%@. %@", waypoint.order, waypoint.name];

    self.textLabel.text = orderText;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
