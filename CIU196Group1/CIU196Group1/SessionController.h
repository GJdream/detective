//
//  SessionController.h
//  CIU196Group1
//
//  Created by Robert Sebescen on 2013-11-29.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionController : NSObject

- (NSInteger) getNewSessionID;

- (NSInteger) addPlayerToSession: (NSInteger) sessionID;

- (NSInteger) getNumberOfPlayersInSession;

- (void) removePlayerFromSession;

- (bool) isGameReady;

- (void) startGame;

- (bool) isChanged;

- (void) changeCleared;

- (NSMutableArray*) getPlayerData;

- (void) getSecret;

- (void) uploadImage;

@end
