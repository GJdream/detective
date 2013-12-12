//
//  Player.m
//  CIU196Group1
//
//  Created by saqirltu on 29/11/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "Player.h"

@implementation Player
@synthesize name, image, inGameID, role, isAlive, clue;

- (id)init
{
    return [self initWithName:@"User Noname" image:[UIImage imageNamed:@"alien.png"]];
}

-(id)initWithName:(NSString *)aName image:(UIImage*) anImage {
    self = [super init];

    if (self) {
        self.name = aName;
        self.image = anImage;
        self.role = 0;
        self.inGameID = -1;
        self.isAlive = TRUE;
        self.clue = @"none";
    }
    return self;
}


- (void)reset
{
    self.name = @"User Noname";
    self.image = [UIImage imageNamed:@"alien.png"];
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
