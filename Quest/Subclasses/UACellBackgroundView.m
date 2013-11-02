//
//  UACellBackgroundView.m
//  Ambiance
//
//  Created by Matt Coneybeare on 1/31/10.
//  Copyright 2010 Urban Apps LLC. All rights reserved.
//

#define TABLE_CELL_BACKGROUND    { 1, 1, 1, 1, 0.866, 0.866, 0.866, 1}			// #FFFFFF and #DDDDDD

#define kDefaultMargin           10

#import "UACellBackgroundView.h"
#import <UIColor+Expanded.h>

@implementation UACellBackgroundView

@synthesize position;

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.topGradientColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.bottomGradientColor = [UIColor colorWithRed:0.866 green:0.866 blue:0.866 alpha:1];
    }
    return self;
}

- (BOOL) isOpaque {
    return NO;
}

-(void)drawRect:(CGRect)aRect {
    // Drawing code

    CGContextRef c = UIGraphicsGetCurrentContext();	

    int lineWidth = 1;
	
    CGRect rect = [self bounds];	
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    miny -= 1;
	
    CGFloat locations[2] = { 0.0, 1.0 };
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = nil;
    CGFloat red1, green1, blue1, alpha1;
    [self.topGradientColor getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    CGFloat red2, green2, blue2, alpha2;
    [self.bottomGradientColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    CGFloat components[8] = {red1, green1, blue1, alpha1, red2, green2, blue2, alpha2};

    CGContextSetStrokeColorWithColor(c, [[UIColor grayColor] CGColor]);
    CGContextSetLineWidth(c, lineWidth);
    CGContextSetAllowsAntialiasing(c, YES);
    CGContextSetShouldAntialias(c, YES);
    	
    if (position == UACellBackgroundViewPositionTop) {
		
        miny += 1;
		
	CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minx, maxy);
        CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, kDefaultMargin);
        CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, maxy, kDefaultMargin);
        CGPathAddLineToPoint(path, NULL, maxx, maxy);
	CGPathAddLineToPoint(path, NULL, minx, maxy);
	CGPathCloseSubpath(path);
		
	// Fill and stroke the path
	CGContextSaveGState(c);
	CGContextAddPath(c, path);
	CGContextClip(c);
		
	myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
	CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
		
	CGContextAddPath(c, path);
	CGPathRelease(path);
	CGContextStrokePath(c);
	CGContextRestoreGState(c);		

    } else if (position == UACellBackgroundViewPositionBottom) {
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minx, miny);
        CGPathAddArcToPoint(path, NULL, minx, maxy, midx, maxy, kDefaultMargin);
        CGPathAddArcToPoint(path, NULL, maxx, maxy, maxx, miny, kDefaultMargin);
        CGPathAddLineToPoint(path, NULL, maxx, miny);
        CGPathAddLineToPoint(path, NULL, minx, miny);
	CGPathCloseSubpath(path);
		
	// Fill and stroke the path
	CGContextSaveGState(c);
	CGContextAddPath(c, path);
	CGContextClip(c);
		
	myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
	CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
		
	CGContextAddPath(c, path);
	CGPathRelease(path);
	CGContextStrokePath(c);
	CGContextRestoreGState(c);

		
    } else if (position == UACellBackgroundViewPositionMiddle) {
		
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, minx, miny);
	CGPathAddLineToPoint(path, NULL, maxx, miny);
	CGPathAddLineToPoint(path, NULL, maxx, maxy);
	CGPathAddLineToPoint(path, NULL, minx, maxy);
	CGPathAddLineToPoint(path, NULL, minx, miny);
	CGPathCloseSubpath(path);
		
	// Fill and stroke the path
	CGContextSaveGState(c);
	CGContextAddPath(c, path);
	CGContextClip(c);
		
	myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
	CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
		
	CGContextAddPath(c, path);
	CGPathRelease(path);
	CGContextStrokePath(c);
	CGContextRestoreGState(c);
		
    } else if (position == UACellBackgroundViewPositionSingle) {
	miny += 1;
		
	CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minx, midy);
        CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, 0);
        CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, midy, 0);
        CGPathAddArcToPoint(path, NULL, maxx, maxy, midx, maxy, 0);
        CGPathAddArcToPoint(path, NULL, minx, maxy, minx, midy, 0);
	CGPathCloseSubpath(path);
		
		
	// Fill and stroke the path
	CGContextSaveGState(c);
	CGContextAddPath(c, path);
	CGContextClip(c);
		
		
	myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
	CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
		
	CGContextAddPath(c, path);
	CGPathRelease(path);
	CGContextStrokePath(c);
	CGContextRestoreGState(c);	
    }
	
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    return;
}

- (void)setPosition:(UACellBackgroundViewPosition)newPosition {
    if (position != newPosition) {
        position = newPosition;
        [self setNeedsDisplay];
    }
}

@end