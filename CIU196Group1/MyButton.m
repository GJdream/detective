//
//  MyButton.m
//  CIU196Group1
//
//  Created by saqirltu on 19/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    //Black Wolf
    //Plain & Simple
    //The Lovers
    //Snacker Comic Personal Use Only
    //You Rook Marbelous
    //    self.font = [UIFont fontWithName:@"You Rook Marbelous" size:self.font.pointSize];
    self.titleLabel.font = [UIFont fontWithName:@"You Rook Marbelous" size: 20];
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Draw a rectangle
//    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
//    CGContextFillPath(context);
    CGContextSetLineWidth(context, 3.0);
    CGContextStrokeRect(context, CGRectInset(rect, 0.5, 0.5));

}

//-(void) drawRect: (CGRect) rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//    CGContextFillRect(context, self.bounds);
//}

//-(void) drawRect: (CGRect) rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGRect paperRect = self.bounds;
//    
//    
//    // START NEW
//    CGRect strokeRect = CGRectInset(paperRect, 5.0, 5.0);
//    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
//    CGContextSetLineWidth(context, 3.0);
//    CGContextStrokeRect(context, strokeRect);
//    // END NEW
//    
//}


@end
