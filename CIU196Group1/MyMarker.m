//
//  MyMarker.m
//  CIU196Group1
//
//  Created by saqirltu on 19/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "MyMarker.h"

@implementation MyMarker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Draw a rectangle
    //    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
    //    CGContextFillPath(context);
    CGContextSetLineWidth(context, 5.0);
    CGContextStrokeRect(context, CGRectInset(rect, 0.5, 0.5));
    
}

@end
