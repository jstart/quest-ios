//
//  QuestStyledTableViewCell.m
//  Quest
//
//  Created by Christopher Truman on 16/04/2013.
//  Copyright (c) 2013 truman. All rights reserved.
//

#import "QuestStyledTableViewCell.h"
#import "UACellBackgroundView.h"
#import "UIColor+Expanded.h"

@implementation QuestStyledTableViewCell
@synthesize backgroundCellColor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // set the background view
        UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [backgroundView setBackgroundColor:[UIColor colorWithHexString:@"4d5967"]];
        self.backgroundView = backgroundView;
        [self.textLabel setBackgroundColor:[UIColor clearColor]];
        
        UACellBackgroundView * selectedBackgroundView = [[UACellBackgroundView alloc] initWithFrame:CGRectZero];
        [selectedBackgroundView setTopGradientColor:[UIColor colorWithHexString:@"29d4be"]];
        [selectedBackgroundView setBottomGradientColor:[UIColor colorWithHexString:@"57b6ad"]];
        self.selectedBackgroundView = selectedBackgroundView;
        
        [self.textLabel setTextColor:[UIColor colorWithHexString:@"fefefe"]];
    }
    return self;
}
-(void)setBackgroundCellColor:(UIColor *)backgroundColor
{
    [[self backgroundView] setBackgroundColor:backgroundColor];
}

-(void)setTextFont:(UIFont *)textFont{
    [self.textLabel setFont:textFont];
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
