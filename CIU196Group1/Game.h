//
//  Game.h
//  CIU196Group1
//
//  Created by saqirltu on 04/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionController.h"

#import "Player.h"
//#import "Timer.h"

@interface Game : NSObject

+(Game*) sharedGame;

@property (nonatomic, strong) Player *myself;
@property NSInteger sessionID;
@property (nonatomic, strong) NSMutableArray *heroes;
@property NSInteger host;   //index of the host in heroes array
@property BOOL waiting;     //true if the host is waiting in new players page
@property (nonatomic, strong) SessionController* sessionController;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *order;
@property (nonatomic, strong) NSString *news;
@property BOOL turnFinished;
@property NSInteger targetID;
@property NSInteger syncTime; //NOT used due to lacking millisecond precision


-(BOOL)saveChanges;
- (void)reset;
- (NSUInteger)count;
- (void)addHero:(Player *)ahero;
- (Player* )heroAtIndex:(NSUInteger)index;

//Game logics
- (void) startATurn;
- (NSInteger) readTimer;
- (BOOL) isMyTurn;
- (void) updateStatus: (NSMutableArray *) heroStatus;

@end
