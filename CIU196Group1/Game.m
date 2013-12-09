//
//  Game.m
//  CIU196Group1
//
//  Created by saqirltu on 04/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "Game.h"


@implementation Game
@synthesize myself = profileData, heroes, sessionID, host, waiting, sessionController;


static Game* _sharedGame = nil;

+(Game*)sharedGame {
    @synchronized([Game class])
    {
        if (!_sharedGame)
            _sharedGame = [[self alloc] init];
        
        return _sharedGame;
    }
}


- (id)init
{
    self = [super init];
    if (self) {
        [self loadData];
        heroes =[[NSMutableArray alloc] init];
        host = 0;
        waiting = TRUE;
        sessionController = [[SessionController alloc] init];
    }
    return self;
}

#define kFileName @"Profile.data"

- (NSString *)pathInDocumentDirectory:(NSString *)fileName {
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:fileName];
    
}

- (NSString *)profileStoreDataPath {
    
    return [self pathInDocumentDirectory:kFileName];
    
}


Player* profileData = nil;
- (void)loadData {
    profileData = [NSKeyedUnarchiver unarchiveObjectWithFile:[self profileStoreDataPath]];
    if (!profileData) {        
        // Means that data could not be loaded, which for instance would happen the first time
        profileData = [[Player alloc] init];
        [profileData reset];
    }

}

- (BOOL)saveChanges {
    return [NSKeyedArchiver archiveRootObject:self.myself toFile:[self profileStoreDataPath]];
}

- (void)reset{
    sessionID = 0;
}

//
// heroes managers
//
- (NSUInteger)count {
    //TODO; here we have to assume maximum no more than 13 players
    if ([heroes count] > 13) {
        return 13;
    }
    return [heroes count];
}

- (Player* )heroAtIndex:(NSUInteger)index {
    
    return (Player* )[heroes objectAtIndex:index];
}

- (void)addHero:(Player *)ahero {
    
    [heroes addObject:ahero];
}

- (void)removeHero:(Player *)ahero {
    
    [heroes removeObject:ahero];
    
}

- (void)removeBookAtIndex:(NSUInteger)index {
    
    [heroes removeObjectAtIndex:index];
    
}

@end
