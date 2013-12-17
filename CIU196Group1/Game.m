//
//  Game.m
//  CIU196Group1
//
//  Created by saqirltu on 04/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "Game.h"


@implementation Game
@synthesize myself = profileData, heroes, sessionID, host, waiting, sessionController, timer, order, news, turnFinished, targetID, syncTime;


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
        news = @"check your role and clue";
        turnFinished = FALSE;
        syncTime = 0;
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


// Game loop
NSInteger length;
-(void)startTimer:(NSInteger)alength {
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(countDown)
                                           userInfo:nil
                                            repeats:YES];
    length = alength;
}

-(void)countDown {
    length--;
    if (length == 0) {
        [timer invalidate];
        if(!turnFinished)
            [self takeTurn];
    }
}



//NSInteger prepareTime = 5, speechTime = 5, actionTime = 10;

//short timer test
NSInteger prepareTime = 2, speechTime = 3, actionTime = 5;

- (void) startATurn{
    
    i = 0;
    targetID = -1;
    [self setTurnFinished:FALSE];
    
    //countDone preparation time for a turn
    [self startTimer: prepareTime]; //TODO change to syncTime
    
    //set the first speech order
    [self setOrder: [[self sessionController] getOrder]];
    
}


int i = 0, turn = 0;
- (void)takeTurn{
    if(i < [[self order] count]){
        turn = [[[self order] objectAtIndex: i] intValue];
        news = [NSString stringWithFormat:@"%@'s turn", [[self heroAtIndex:turn] name]];

        //speech time
        [self startTimer: speechTime];
        
        i++;
    }
    else{
        news = @"Select a target to act"; //TODO should be specified with the roles
        [self setTurnFinished:TRUE]; //TODO check this to show action button
        
        //if no action commited, get status and start new turn
        [self performSelector:@selector(commitcommit:) withObject: [NSNumber numberWithInteger:targetID] afterDelay:actionTime];
        //after 1 sec, refresh the data
        
        [self startTimer: actionTime];
        [self performSelector:@selector(refreshStatus:) withObject:nil afterDelay:(actionTime + 1.5)];
    }
}

- (void)commitcommit : (NSNumber*) aTargetID{
    [sessionController commitAction: [aTargetID integerValue]];
}


- (void) refreshStatus : (id) sender{
    [self updateStatus: [sessionController getPlayerStatuses]];
    targetID = -1;
    [self startATurn];
}

- (NSInteger) readTimer{
    return length;
}

- (BOOL) isMyTurn{
    return [[self heroAtIndex:turn] inGameID] == [self.myself inGameID];
}

- (void) updateStatus: (NSMutableArray *) heroStatus{
    
    news = @"";
    int deathFlag = 0;
    
    for (int i =0; i < heroes.count; i++) {
        if ([[self heroAtIndex:i] isAlive] && !(NSInteger)[heroStatus objectAtIndex:i]) {
            deathFlag++;
            if(deathFlag == 1)
                news= [NSString stringWithFormat:@"%@%@", news, [[self heroAtIndex:i] name]];
            else
                news= [NSString stringWithFormat:@"%@ and %@", news, [[self heroAtIndex:i] name]];
            [[self heroAtIndex:i] setIsAlive: FALSE];
        }
    }
    
    if (deathFlag == 0) {
        news = @"nothing happened";
    } else{
        news= [NSString stringWithFormat:@"%@ died", news];
    }
}

@end
