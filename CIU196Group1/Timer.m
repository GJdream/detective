//
//  Timer.m
//  CIU196Group1
//
//  Created by saqirltu on 12/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "Timer.h"

@implementation Timer
@synthesize myTimer, length, interval;

- (id)init
{
    self = [super init];
    if (self) {
        interval = 1;
            }
    return self;
}



-(void)start:(NSInteger)alength {
    myTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                               target:self
                                             selector:@selector(countDown)
                                             userInfo:nil
                                              repeats:YES];
    length = alength;
}

-(void)countDown {
    if (--length == 0) {
        [myTimer invalidate];
    }
}

- (NSInteger) getCount{
    return length;
}

@end
