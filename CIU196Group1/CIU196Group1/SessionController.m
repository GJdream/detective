//
//  SessionController.m
//  CIU196Group1
//
//  Created by Robert Sebescen on 2013-11-29.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "SessionController.h"

@implementation SessionController

static NSString * ip = @"http://95.80.44.85/";


- (id) init {
    self = [super init];
    
    if (self) {

    }
    return self;
}

// Gets a new session ID from the server. if the server responds with an error, the error message is printed and -1 is returned.
- (NSInteger) getNewSessionID {
    [self getPlayerData:1];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", ip, @"?action=newsession"]]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSString* responseStr = [[NSString alloc] initWithData:response
                                              encoding:NSUTF8StringEncoding];
    
    @try {
        //NSLog(@"Server returned ok: %d",  [responseStr integerValue]);
        return [responseStr integerValue];
    }
    @catch (NSException *e) {
        NSLog(@"Server returned exception: %@", responseStr);
        return -1;
    }
}

// Adds a player to an existing session. The method will connect to the server and retrieve an available player ID for that session. If the server responded with an error, the error message is printed and -1 is returned.
// TODO: make server check if sessionID exists
- (NSInteger) addPlayerToSession: (NSInteger) sessionID {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%d", ip, @"?action=addplayer&sessionid=", sessionID]]
                                                         cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSString* responseStr = [[NSString alloc] initWithData:response
                                                  encoding:NSUTF8StringEncoding];
    
    @try {
        //NSLog(@"Server returned ok: %d",  [responseStr integerValue]);
        return [responseStr integerValue];
    }
    @catch (NSException *e) {
        NSLog(@"Server returned exception: %@", responseStr);
        return -1;
    }
}

// Retrieves the number of players in the session with the given sessionID. If the server responded with an error, the error message is printed and -1 is returned.
- (NSInteger) getNumberOfPlayersInSession:(NSInteger)sessionID {
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%d", ip, @"?action=getnumberofplayers&sessionid=", sessionID]]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSString* responseStr = [[NSString alloc] initWithData:response
                                                  encoding:NSUTF8StringEncoding];
    
    @try {
        //NSLog(@"Server returned ok: %d",  [responseStr integerValue]);
        return [responseStr integerValue];
    }
    @catch (NSException *e) {
        NSLog(@"Server returned exception: %@", responseStr);
        return -1;
    }
}

- (void) getPlayerData:(NSInteger)sessionID {
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%d", ip, @"?action=getplayerdata&sessionid=", sessionID]]                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData  timeoutInterval:10];
    //NSError *requestError;
    //NSURLResponse *urlResponse = nil;
    
    //NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    //NSString* responseStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@", responseStr);
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: [NSString stringWithFormat:@"%@%@%d", ip, @"?action=getplayerdata&sessionid=", sessionID]]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
    
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSLog(@"%@", json);
}


@end
