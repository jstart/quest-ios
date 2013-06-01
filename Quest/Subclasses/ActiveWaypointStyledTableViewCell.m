//
//  ActiveWaypointStyledTableViewCell.m
//  Quest
//
//  Created by Christopher Truman on 22/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "ActiveWaypointStyledTableViewCell.h"
#import "Waypoint.h"

@interface ActiveWaypointStyledTableViewCell ()

@property (nonatomic, assign) BOOL isVisible;

@end

@implementation ActiveWaypointStyledTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupWithWaypoint:(Waypoint *)waypoint visible:(BOOL)isVisible{
    self.isVisible = isVisible;
    if (isVisible) {
        NSString * orderText = [NSString stringWithFormat:@"%@. %@", waypoint.order, waypoint.name];
        
        self.textLabel.text = orderText;
    }else{
        self.textLabel.text = @"???";
    }
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
