//
//  Game.h
//  CIU196Group1
//
//  Created by saqirltu on 04/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Player.h"

@interface Game : NSObject

+(Game*) sharedGame;
//+(Player*)myself;
-(BOOL)saveChanges;
@property (nonatomic, strong) Player* myself;

@end
