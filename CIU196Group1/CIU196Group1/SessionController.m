//
//  SessionController.m
//  CIU196Group1
//
//  Created by Robert Sebescen on 2013-11-29.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "SessionController.h"
#import "Game.h"

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
//    [self getPlayerData:1];
    
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
- (NSInteger) addPlayerToSession : (NSInteger) sessionID{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?action=addplayer&sessionid=%d&name=%@", ip, sessionID, [[[Game sharedGame] myself] name]]]
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
- (NSInteger) getNumberOfPlayersInSession {
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%d", ip, @"?action=getnumberofplayers&sessionid=", [[Game sharedGame] sessionID]]]
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

// queries the server for player data given a sessionID. returns an NSArray of NSDictionaries, to be
// parsed by Player.parseFromJSON
- (NSMutableArray *) getPlayerData {
    
    /* something is broken with this
    __block NSData* data;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: [NSString stringWithFormat:@"%@%@%d", ip, @"?action=getplayerdata&sessionid=", sessionID]]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
        NSLog(@"aaa %@", data);

    });
     */
    
    // create the URL we'd like to query
    NSURL *myURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@%lu", ip, @"?action=getplayerdata&sessionid=", (long)[[Game sharedGame] sessionID]]];
                    
    // we'll receive raw data so we'll create an NSData Object with it
    NSData *myData = [[NSData alloc]initWithContentsOfURL:myURL];
                    
    id myJSON = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableContainers error:nil];

    NSMutableArray *players = [NSMutableArray arrayWithCapacity:20];
    for (NSDictionary* playerData in myJSON) {
        Player* player = [[Player alloc] init];
        if(![playerData[@"playerName"] isKindOfClass:[NSNull class]])
            [player setName: playerData[@"playerName"]];
        else
            [player setName: @"empty"];
        
        //        [player setRole: (NSInteger)playerData[@"playerRole"]];
        //        [player setIsAlive: (bool)playerData[@"playerAlive"]];
        
        [players addObject:player];

    }

    
    return players;
}

- (NSDictionary *)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    return json;
}

- (void) removePlayerFromSession {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%lu%@%d", ip, @"?action=removeplayer&sessionid=", (long)[[Game sharedGame] sessionID], @"&playerid=", [[[Game sharedGame] myself] inGameID]]]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSString* responseStr = [[NSString alloc] initWithData:response
                                                  encoding:NSUTF8StringEncoding];
    NSLog(@"response from server: %@", responseStr);
}

- (bool) isGameReady {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%lu", ip, @"?action=sessionready&sessionid=", (long)[[Game sharedGame] sessionID]]]
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
        return [responseStr boolValue];
    }
    @catch (NSException *e) {
        NSLog(@"Server returned exception: %@", responseStr);
        return -1;
    }
}

- (void) startGame {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%lu", ip, @"?action=startgame&sessionid=", (long)[[Game sharedGame] sessionID]]]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSString* responseStr = [[NSString alloc] initWithData:response
                                                  encoding:NSUTF8StringEncoding];
    NSLog(@"response from server: %@", responseStr);
}

- (bool) isChanged {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%lu%@%d", ip, @"?action=ischanged&sessionid=", (long)[[Game sharedGame] sessionID], @"&playerid=", [[[Game sharedGame] myself] inGameID]]]
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
        return [responseStr boolValue];
    }
    @catch (NSException *e) {
        NSLog(@"Server returned exception: %@", responseStr);
        return -1;
    }
}

- (void) changeCleared {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%lu%@%d", ip, @"?action=changecleared&sessionid=", (long)[[Game sharedGame] sessionID], @"&playerid=", [[[Game sharedGame] myself] inGameID]]]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSString* responseStr = [[NSString alloc] initWithData:response
                                                  encoding:NSUTF8StringEncoding];
    
    NSLog(@"response from server: %@", responseStr);

}


@end
