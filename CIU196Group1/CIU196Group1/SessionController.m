//
//  SessionController.m
//  CIU196Group1
//
//  Created by Robert Sebescen on 2013-11-29.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "SessionController.h"
#import "Game.h"
#import "Utilities.h"

// Handles sessions and server GET requests (would be more suitable to name it ServerController).
//
// It would be more suitable to return JSON from the server and parse it here, as right now
// the actions are more hard coded.
@implementation SessionController

- (id) init {
    self = [super init];
    
    if (self) {
    }
    return self;
}

// Makes a GET request for a server at a given URL. Returns a string with the response data.
- (NSString*) queryServer: (NSString*) queryURL{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: queryURL]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:5];
    // make the request
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    // if the request failed, requestError will now be non-nil so we can log it
    if (requestError) {
        NSLog(@"%@", requestError);
        return nil;
    }
    // otherwise, everything went fine and we got a response string
    else {
        NSString* responseStr = [[NSString alloc] initWithData:response
                                                      encoding:NSUTF8StringEncoding];
        //NSLog(@"Server returned %@", responseStr);
        return responseStr;
    }
    
}

// IP for our app server
static NSString * ip = @"http://95.80.44.85/";

// Makes a get request to server with a given action
- (NSString*) queryAppServerWithAction:(NSString*) action {
    NSString* urlString = [NSString stringWithFormat:@"%@?action=%@", ip, action];
    //NSLog(@"%@", urlString);
    return [self queryServer:urlString];
}

// TODO: make server check if sessionID exists
- (NSString*) queryAppServerWithAction: (NSString*) action
                         withSessionID:(NSInteger) sessionID {
    return [self queryServer: [NSString stringWithFormat:@"%@?action=%@&sessionid=%d", ip, action, sessionID]];
}

- (NSString*) queryAppServerWithAction: (NSString*) action
                         withSessionID:(NSInteger) sessionID
                          withPlayerID:(NSInteger) playerID {
    return [self queryServer:[NSString stringWithFormat:@"%@?action=%@&sessionid=%d&playerid=%d", ip, action, sessionID, playerID]];
}

// Gets a new session ID from the server. if the server responds with an error, the error message is printed and -1 is returned.
- (NSInteger) getNewSessionID {
    NSString *serverResponse = [self queryAppServerWithAction:@"newsession"];
    
    @try {
        NSLog(@"getNewSessionID ok: %d",  [serverResponse integerValue]);
        return [serverResponse integerValue];
    }
    @catch (NSException *e) {
        NSLog(@"getNewSessionID exception: %@", serverResponse);
        return -1;
    }
}

// Adds a player to an existing session. The method will connect to the server and retrieve an available player ID for that session. If the server responded with an error, the error message is printed and -1 is returned.
- (NSInteger) addPlayerToSession : (NSInteger) sessionID{
    NSString* serverResponse = [self queryServer:[NSString stringWithFormat:@"%@?action=addplayer&sessionid=%lu&name=%@", ip, (long)sessionID, [[[[Game sharedGame] myself] name] stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];
    
    @try {
        NSInteger returnVal =  [serverResponse integerValue];
        [[Game sharedGame] setSessionID:sessionID];
        [[[Game sharedGame] myself] setInGameID:returnVal];

        [self uploadPlayerImage];
        return returnVal;
    }
    @catch (NSException *e) {
        NSLog(@"addPlayerToSession exception: %@", serverResponse);
        return -1;
    }
}

// Retrieves the number of players in the session with the given sessionID. If the server responded with an error, the error message is printed and -1 is returned.
- (NSInteger) getNumberOfPlayersInSession {
    NSString* serverResponse = [self queryAppServerWithAction:@"getnumberofplayers" withSessionID:[[Game sharedGame] sessionID]];
    
    @try {
        return [serverResponse integerValue];
    }
    @catch (NSException *e) {
        NSLog(@"getNumberOfPlayersInSession exception: %@", serverResponse);
        return -1;
    }
}

// queries the server for player data given a sessionID. returns an NSArray of NSDictionaries, to be
// parsed by Player.parseFromJSON
Player* player;

- (NSMutableArray *) getPlayerData {
    
    // create the URL we'd like to query
    NSURL *myURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@%lu", ip, @"?action=getplayerdata&sessionid=", (long)[[Game sharedGame] sessionID]]];
                    
    // we'll receive raw data so we'll create an NSData Object with it
    NSData *myData = [[NSData alloc]initWithContentsOfURL:myURL];
                    
    id myJSON = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableContainers error:nil];

    NSMutableArray *players = [NSMutableArray arrayWithCapacity:20];
    for (NSDictionary* playerData in myJSON) {
        if(![playerData[@"playerName"] isKindOfClass:[NSNull class]]) {
            player = [[Player alloc] init];

            [player setName: playerData[@"playerName"]];
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@/uploadedfiles/%d-%d.jpg", ip,
                                                                                              [[Game sharedGame] sessionID], [playerData[@"playerID"] intValue]]]];

            //NSLog(@"%@",[NSString stringWithFormat:@"%@/uploadedfiles/%d-%d.jpg", ip, [[Game sharedGame] sessionID], [playerData[@"playerID"] intValue]]);
            
            UIImage *image = [UIImage imageWithData: imageData];
            [player setImage: image];
            
        }
        else
            [player setName: @"empty"];
        
        //        [player setRole: (NSInteger)playerData[@"playerRole"]];
        //        [player setIsAlive: (bool)playerData[@"playerAlive"]];
        
        [players addObject:player];

    }

    return players;
}

// reutnrs an array of strings with 1 if the player is alive and 0 if the player is dead
- (NSMutableArray *) getPlayerStatuses {
    NSString* serverResponse = [self queryAppServerWithAction:@"getplayerstatuses" withSessionID:[[Game sharedGame] sessionID]];
    
    return [[serverResponse componentsSeparatedByString:@","] mutableCopy];
}

- (void) removePlayerFromSession {
    NSString* serverResponse = [self queryAppServerWithAction:@"removeplayer" withSessionID:[[Game sharedGame] sessionID] withPlayerID:[[[Game sharedGame] myself] inGameID]];
    NSLog(@"removePlayerFromSession: %@", serverResponse);
}

- (bool) isGameReady {
    NSString* serverResponse = [self queryAppServerWithAction:@"sessionready" withSessionID:[[Game sharedGame] sessionID]];
    
    @try {
        NSLog(@"isGameReady ok: %d",  [serverResponse integerValue]);
        return [serverResponse boolValue];
    }
    @catch (NSException *e) {
        NSLog(@"isGameReady exception: %@", serverResponse);
        return -1;
    }
}

// starts the game (i.e. sets isReady flag on server to true)
- (void) startGame {
    NSString* serverResponse = [self queryAppServerWithAction:@"startgame" withSessionID:[[Game sharedGame] sessionID]];
    NSLog(@"startgame response: %@", serverResponse);
}

// sets changed flag on server
- (bool) isChanged {
    NSString* serverResponse = [self queryAppServerWithAction:@"ischanged" withSessionID:[[Game sharedGame] sessionID] withPlayerID:[[[Game sharedGame] myself] inGameID]];
    @try {
        NSLog(@"isChanged ok: %d",  [serverResponse boolValue]);
        return [serverResponse boolValue];
    }
    @catch (NSException *e) {
        NSLog(@"isChanged exception: %@", serverResponse);
        return -1;
    }
}

// clears change flags on server
- (void) changeCleared {
    NSString* serverResponse = [self queryAppServerWithAction:@"changecleared" withSessionID:[[Game sharedGame] sessionID] withPlayerID:[[[Game sharedGame] myself] inGameID]];
    NSLog(@"changeCleared: %@", serverResponse);

}

// Sets this player's role and clue given by the server
- (void) getSecret {
    NSString* serverResponse = [self queryAppServerWithAction:@"getsecret" withSessionID:[[Game sharedGame] sessionID] withPlayerID:[[[Game sharedGame] myself] inGameID]];
    NSLog(@"getSecret: %@", serverResponse);
    
    NSArray *words = [serverResponse componentsSeparatedByString:@";"];
    [[[Game sharedGame] myself] setRole: [words[0] integerValue]];
    [[[Game sharedGame] myself] setClue: words[1]];
    [[Game sharedGame] setSyncTime:[words[2] integerValue]];
}


// uploads the players current image to server.
- (void) uploadPlayerImage{
    
    // get a scaled profile image and store it as binary data to send to server
    UIImage *scaledProfileImage = [Utilities scaledImageCopyOfSize:[[[Game sharedGame] myself] image] : CGSizeMake(100, 100)];
    NSData *storeData = UIImageJPEGRepresentation(scaledProfileImage, 90);
    
    // make POST request to server and let it handle it
    NSString *URLString = [NSString stringWithFormat:@"%@/uploadimage.php", ip];
    NSMutableURLRequest *request  = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URLString]];
    [request setHTTPMethod:@"POST"];
    
    // random boundary from the
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *idItem = [NSString stringWithFormat:@"%d-%d", [[Game sharedGame] sessionID], [[[Game sharedGame] myself] inGameID]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n", idItem] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:storeData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    [request addValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    //NSLog(@"body length %d",[body length]);
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *serverResponse = [[NSString alloc] initWithData:returnData
                                                  encoding:NSUTF8StringEncoding];
}

// Gets play order for players. All players will recieve the same order from the server.
//RobertTODO: better logic for distributing player roles
- (NSMutableArray*) getOrder{
    if ([self didEveryoneGotOrder]) {
        [self clearOrder];
    }
    
    NSString* serverResponse = [self queryAppServerWithAction:@"getplayorder" withSessionID:[[Game sharedGame] sessionID] withPlayerID:[[[Game sharedGame] myself] inGameID]];
    NSLog(@"getPlayOrder: %@", serverResponse);
    
    NSMutableArray *arrayFromString = [[serverResponse componentsSeparatedByString:@","] mutableCopy];
    
    return arrayFromString;
}

- (bool) didEveryoneGotOrder {
    NSString* serverResponse = [self queryAppServerWithAction:@"isordercleared" withSessionID:[[Game sharedGame] sessionID]];
    
    @try {
        NSLog(@"didEveryOneGotOrder ok: %d",  [serverResponse boolValue]);
        return [serverResponse boolValue];
    }
    @catch (NSException *e) {
        NSLog(@"didEveryOneGetOrder exception: %@", serverResponse);
        return false;
    }
}

- (void) clearOrder {
    NSString* serverResponse = [self queryAppServerWithAction:@"clearorder" withSessionID:[[Game sharedGame] sessionID]];
    NSLog(@"clearOrder response: %@", serverResponse);
}

//RobertTODO: call the server with targetID, based on the role, different action applied on server, if i send targetID as -1, that is a empty action, but necessary to change the flag somehow
- (void)commitAction : (NSInteger) targetID{
    if (targetID >=0 && targetID < [[Game sharedGame] count]) {
        NSLog(@"action target is: No.%d - %@", targetID, [[[Game sharedGame] heroAtIndex:targetID] name]);
        
        switch ([[[Game sharedGame] myself] role]) {
            case Detective:
                [self addVoteFromDetective:targetID];
                break;
            case Police:
                [self addVoteFromPolice:targetID];
                break;
            case Killer:
                [self addVoteFromKiller:targetID];
                break;
            default:
                @throw [NSException exceptionWithName:@"" reason:@"invalid role sentt to commitAction" userInfo:nil];
                break;
        }
        
    } else {
        [self skipVote];
    }
}


- (void) addVoteFromDetective: (NSInteger) voteID {
    
    NSString* serverResponse = [self queryServer: [NSString stringWithFormat:@"%@?action=addvotefromdetective&sessionid=%d&playerid=%d&voteid=%d", ip, [[Game sharedGame] sessionID], [[[Game sharedGame] myself] inGameID], voteID]];
    NSLog(@"addVoteFromDetective response: %@", serverResponse);
}

- (void) addVoteFromPolice: (NSInteger) voteID {
    NSString* serverResponse = [self queryServer: [NSString stringWithFormat:@"%@?action=addvotefrompolice&sessionid=%d&playerid=%d&voteid=%d", ip, [[Game sharedGame] sessionID], [[[Game sharedGame] myself] inGameID], voteID]];
    NSLog(@"addVoteFromPolice response: %@", serverResponse);
}

- (void) addVoteFromKiller: (NSInteger) voteID {
    NSString* serverResponse = [self queryServer: [NSString stringWithFormat:@"%@?action=addvotefromkiller&sessionid=%d&playerid=%d&voteid=%d", ip, [[Game sharedGame] sessionID], [[[Game sharedGame] myself] inGameID], voteID]];

    NSLog(@"addVoteFromKiller response: %@", serverResponse);
}

- (void) skipVote {
    NSString *serverResponse = [self queryAppServerWithAction:@"skipvote" withSessionID:[[Game sharedGame] sessionID] withPlayerID:[[[Game sharedGame] myself]inGameID]];
    NSLog(@"skipVote response: %@",serverResponse);
}

// 0 for no win, 1 for detective win, 2 for killer win
- (NSInteger) detectWinningCondition {
    NSString *serverResponse = [self queryAppServerWithAction:@"detectwinningcondition" withSessionID:[[Game sharedGame] sessionID] withPlayerID:[[[Game sharedGame] myself]inGameID]];
    NSLog(@"detectWinningCondition response: %@",serverResponse);
    return [serverResponse integerValue];
}




@end
