//
//  NewGameViewController.m
//  CIU196Group1
//
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "NewGameViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#import "PlayerCell.h"
#import "Game.h"
#import "SessionController.h"


@interface NewGameViewController ()
@property (strong, nonatomic) IBOutlet UITableView *playerTable;
@property (strong, nonatomic) IBOutlet UILabel *sessionIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *counterLabel;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
- (IBAction)startButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *gameNavButton;

@end

@implementation NewGameViewController

@synthesize sessionIDLabel, playerTable, counterLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


NSTimer *timer;
BOOL timerActive = TRUE;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    //if already joind a game, skip rejoining
    if(![[Game sharedGame] sessionID]){
        [[Game sharedGame] setSessionID: [[[Game sharedGame] sessionController] getNewSessionID]];
        
        //RobertTODO: when a player join a game, it also sends the player info to the server, so i want you to add a parameter with type of Player* (or at least a String name and a profile image) to addPlayerToSession method as called below
        
        //RobertTODO Update: you don't really need to add a parameter here, you can simply access the player own information from your SC code by calling [[Game sharedGame] myself]
        
        [[[Game sharedGame] myself] setInGameID: [[[Game sharedGame] sessionController]  addPlayerToSession:[[Game sharedGame] sessionID]]];

    }
    
    sessionIDLabel.text = [NSString stringWithFormat:@"ID: %lu", (unsigned long)[[Game sharedGame] sessionID]];
    
    
    //load the current game status at once
    //RobertDone: return me a type of NSMutableArray* with Player as instance
//    
//    NSMutableArray *players = [NSMutableArray arrayWithCapacity:20];
//    for (NSDictionary* playerData in [[[Game sharedGame] sessionController] getPlayerData:[[Game sharedGame] sessionID]]) {
//        [players addObject: [Player parseFromJSON:playerData]];
//    }
    
    [[Game sharedGame] setHeroes: [[[Game sharedGame] sessionController] getPlayerData]];
    [[[Game sharedGame] sessionController] changeCleared];
    
    
    //TODELETE: following are a dummy list for test purpose
//    NSMutableArray *dummyplayers;
//    dummyplayers = [NSMutableArray arrayWithCapacity:20];
//    Player *player = [[Player alloc] init];
//    player.name = @"Bill Evans";
//    [dummyplayers addObject:player];
//    player = [[Player alloc] init];
//    player.name = @"Oscar Peterson";
//    [dummyplayers addObject:player];
//    player = [[Player alloc] init];
//    player.name = @"Dave Brubeck";
//    [dummyplayers addObject:player];
//    [[Game sharedGame] setHeroes: dummyplayers];
    
    
    
    counterLabel.text =  [NSString stringWithFormat:@"%d player joined the game", [[Game sharedGame] count]];
    // start polling from the server
    [self startUpdating];
    
}

- (void)startUpdating
{
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkServer:) userInfo:nil repeats:YES];
}

- (void)stopUpdating
{
    [timer invalidate];
    timer = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    //disable the start button as default
    [self.startButton setEnabled:FALSE];
    [self.startButton setHidden:TRUE];
    [self.gameNavButton setEnabled:FALSE];
    
    //if it's a host and the game status is waiting, show start button
    if([[Game sharedGame] waiting]){
        if ([[Game sharedGame] host] == [[[Game sharedGame] myself] inGameID]) {
            [self.startButton setEnabled:TRUE];
            [self.startButton setHidden:FALSE];
        }
    } else{
        [self.gameNavButton setEnabled:TRUE];
    }
    
    
    [self.playerTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    timerActive = TRUE;
}

- (void)viewDidDisappear:(BOOL)animated{
    timerActive = FALSE;
}

// polling is done here
- (void)checkServer : (id) sender{
    if(timerActive && [[Game sharedGame] waiting]){
        
        
        //RobertTODO: return a Player* which is newly added as called below, feel free to rename the method, if no changes, return nil. this is kinda depracated by following solution
        
        //or
        
        //RobertDone: i just came up with a new thought, you can add a statusChange flag to player table, when game status changed on the server, this flag is set to true to all players in the session. so we can resue in sc.status function. remember to reset the statusChagne flag into false at the end of sc.status function, better to do it on server side due to atomicity concern
        
        if([[[Game sharedGame] sessionController] isChanged]){
            
//            [[Game sharedGame] setHeroes: sc.status];
            [[Game sharedGame] setHeroes: [[[Game sharedGame] sessionController] getPlayerData]];
            
            [[[Game sharedGame] sessionController] changeCleared];
            
//            //Dummy
//            Player *ahero = [[Player alloc] init];
//            [[Game sharedGame] addHero: ahero];
        }

        
        
        
        
        
        counterLabel.text =  [NSString stringWithFormat:@"%d player joined the game", [[Game sharedGame] count]];
        [self.playerTable reloadData];

        //RobertDone: add this method returns the ready flag of the game session
        if([[[Game sharedGame] sessionController] isGameReady]){
            [[Game sharedGame] setWaiting:FALSE];
            [self enterGame];
        }
        
        
        NSLog(@"my inGameID is %d", [[[Game sharedGame] myself] inGameID]);
    }
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //int selectedRow = indexPath.row;
    //NSLog(@"touch on row %d", selectedRow);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Game sharedGame] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerCell *cell = (PlayerCell*)[tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
    
    
    Player *player = [[Game sharedGame] heroAtIndex:indexPath.row];    
    
    cell.nameLabel.text = player.name;
    cell.profileImage.image = player.image;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (IBAction)startButtonClicked:(id)sender {
    
    //RobertDone: create a method that sets the ready flag of the game session to TRUE
    
    [[[Game sharedGame] sessionController] startGame];
    
    [[Game sharedGame] setWaiting:FALSE];
    [self enterGame];
}

- (void) enterGame{
    [self performSegueWithIdentifier:@"startGame" sender:self];
}

@end
