//
//  Player.h
//  CIU196Group1
//
//  Created by saqirltu on 29/11/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, assign) int gameSession;
@property (nonatomic, assign) int gameID;

- (void) reset;

@end
