//
//  Timer.h
//  CIU196Group1
//
//  Created by saqirltu on 12/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject
@property NSTimer *myTimer;
@property NSInteger length;
@property NSInteger interval;
- (NSInteger) getCount;
-(void)start:(NSInteger)alength;
@end
