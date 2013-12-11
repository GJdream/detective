//
//  Player.m
//  CIU196Group1
//
//  Created by saqirltu on 29/11/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "Player.h"

@implementation Player
@synthesize name, image, inGameID, role, isAlive;

- (id)init
{
    return [self initWithName:@"User Noname" image:[UIImage imageNamed:@"alien.png"]];
}

-(id)initWithName:(NSString *)aName image:(UIImage*) anImage {
    self = [super init];

    if (self) {
        self.name = aName;
        self.image = anImage;
    }
    return self;
}


- (void)reset
{
    self.name = @"User Noname";
    self.image = [UIImage imageNamed:@"alien.png"];
}

// parses a player from an NSDictionary (json object)
+ (Player*) parseFromJSON: (NSDictionary*) json {
    Player* player = [[Player alloc] initWithName:json[@"playerName"] image:[UIImage imageNamed:@"alien.png"]];
    player.role = (NSInteger)json[@"playerRole"];
    player.isAlive = (bool)json[@"playerAlive"];
    return player;
}



#define kEncodeKeyStringValue   @"kEncodeKeyStringValue"
#define kEncodeKeyImageValue   @"kEncodeKeyImageValue"
#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name   forKey:kEncodeKeyStringValue];
    [aCoder encodeObject:self.image   forKey:kEncodeKeyImageValue];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init]))
    {
        self.name = [aDecoder decodeObjectForKey:kEncodeKeyStringValue];
        self.image = [aDecoder decodeObjectForKey:kEncodeKeyImageValue];
    }
    return self;
}

@end
