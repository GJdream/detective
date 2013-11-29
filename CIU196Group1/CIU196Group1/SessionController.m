//
//  SessionController.m
//  CIU196Group1
//
//  Created by Robert Sebescen on 2013-11-29.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "SessionController.h"

@implementation SessionController


- (id) init {
    self = [super init];
    
    if (self) {
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost/appserver"]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval:10];
        
        [request setHTTPMethod: @"GET"];
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        self.response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
        


    }
    return self;
}

- (NSUInteger) getSessionID {
    
    NSString* resultStr = [[NSString alloc] initWithData:self.response
                                             encoding:NSUTF8StringEncoding];
    
    NSLog(@"Response %@", resultStr);
    NSUInteger resultUInt = [resultStr integerValue];
    return resultUInt;
}



@end
