//
//  MyLabel.m
//  CIU196Group1
//
//  Created by saqirltu on 18/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "MyLabel.h"

@implementation MyLabel

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
    self.font = [UIFont fontWithName:@"You Rook Marbelous" size:self.font.pointSize];
    
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
