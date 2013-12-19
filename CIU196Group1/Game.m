//
//  Game.m
//  CIU196Group1
//
//  Created by saqirltu on 04/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "Game.h"


@implementation Game
@synthesize myself = profileData, heroes, sessionID, host, waiting, sessionController, timer, order, news, turnFinished, whoseTurn,targetID, syncTime, winningCondition;


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
        sessionID = 0;
        heroes =[[NSMutableArray alloc] init];
        host = 0;
        waiting = TRUE;
        sessionController = [[SessionController alloc] init];
        news = @"check your role and clue";
        turnFinished = FALSE;
        syncTime = 0;
        targetID = 100;
        winningCondition = 0;
        whoseTurn = -1;
    }
    return self;
}

- (void)reset{
    sessionID = 0;
    heroes =[[NSMutableArray alloc] init];
    host = 0;
    waiting = TRUE;
    news = @"check your role and clue";
    turnFinished = FALSE;
    syncTime = 0;
    targetID = 100;
    winningCondition = 0;
    whoseTurn = -1;
}

- (void) endGame{
    waiting = TRUE;
    syncTime = 0;
    targetID = 100;
    winningCondition = 0;
    whoseTurn = -1;
    [self.myself setIsAlive:TRUE];
   [timer invalidate];
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
    if (index < [heroes count]) {
        return (Player* )[heroes objectAtIndex:index];
    } else {
        return nil;
    }
    
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
    
    NSLog(@"am I alive: %d", [self.myself isAlive]);
}



NSInteger prepareTime = 20, speechTime = 15, actionTime = 20;

//short timer test
//NSInteger prepareTime = 5, speechTime = 5, actionTime = 5;

- (void) startATurn{
    
    i = 0;
    targetID = 100;
    [self setTurnFinished:FALSE];
    [self setWhoseTurn:-1];
    
    //countDone preparation time for a turn
    [self startTimer: prepareTime]; //TODO change to syncTime
    
    //set the first speech order
    [self setOrder: [[self sessionController] getOrder]];
    
}


int i = 0, turn = 0;
- (void)takeTurn{
    if(i < [[self order] count]){
        while(1){
            turn = [[[self order] objectAtIndex: i] intValue];
            
            
            //TOTEST: skip the died person
            if ([[self heroAtIndex:turn] isAlive]) {
                [self setWhoseTurn:turn];
                
                news = [NSString stringWithFormat:@"%@'s turn", [[self heroAtIndex:turn] name]];
                
                //speech time
                [self startTimer: speechTime];
                break;
            }
            else{
                i++;
            }
        }
        i++;
    }
    else{
        news = @"Select a target to act"; //TODO should be specified with the roles
        [self setTurnFinished:TRUE]; //TODO check this to show action button
        [self setWhoseTurn:-1];
        
        //if no action commited, get status and start new turn
        [self performSelector:@selector(commitcommit:) withObject: nil afterDelay:actionTime];
        //after 1 sec, refresh the data
        
        [self startTimer: actionTime];
        [self performSelector:@selector(refreshStatus:) withObject:nil afterDelay:(actionTime + 3)];
    }
}

- (void)commitcommit : (id) sender{
    [sessionController commitAction: [[Game sharedGame] targetID]];
    
    news = @"calculating...";
}


- (void) refreshStatus : (id) sender{
    [self updateStatus: [sessionController getPlayerStatuses]];
    targetID = 100;
    if(winningCondition == 0){
        [self startATurn];
    }
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
//        NSLog(@"the hero is Alive:%d", [[self heroAtIndex:i] isAlive]);
//        NSLog(@"the hero is Alive:%d", [(NSNumber*)[heroStatus objectAtIndex:i] integerValue]);
        
        if ([[self heroAtIndex:i] isAlive] && ![(NSNumber*)[heroStatus objectAtIndex:i] integerValue]) {
            deathFlag++;
            if(deathFlag == 1)
                news= [NSString stringWithFormat:@"%@%@", news, [[self heroAtIndex:i] name]];
            else
                news= [NSString stringWithFormat:@"%@ and %@", news, [[self heroAtIndex:i] name]];
            [[self heroAtIndex:i] setIsAlive: FALSE];
            
            
            NSLog(@"died inGameID: %d, myself inGameID: %d",[[self heroAtIndex:i] inGameID], [self.myself inGameID]);
            if ([[self heroAtIndex:i] inGameID] == [self.myself inGameID]) {
                [self.myself setIsAlive:FALSE];
                NSLog(@"I died");
            }
        }
    }
    
    if (deathFlag == 0) {
        news = @"nothing happened";
    } else{
        news= [NSString stringWithFormat:@"%@ died", news];
    }

    winningCondition = [sessionController detectWinningCondition];
}

@end
