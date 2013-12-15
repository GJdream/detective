//
//  Player.h
//  CIU196Group1
//
//  Created by saqirltu on 29/11/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject <NSCoding>

typedef NS_ENUM(NSInteger, Roles) {
    Detective,
    Police,
    Killer
};

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, assign) NSInteger inGameID;
@property (nonatomic, assign) Roles role;
@property (nonatomic, copy) NSString *clue;
@property (nonatomic, assign) BOOL isAlive;

- (void) reset;


@end
