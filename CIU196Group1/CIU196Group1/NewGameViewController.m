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
        
        
        [[[Game sharedGame] myself] setInGameID: [[[Game sharedGame] sessionController]  addPlayerToSession:[[Game sharedGame] sessionID]]];

    }
    
    sessionIDLabel.text = [NSString stringWithFormat:@"ID: %lu", (unsigned long)[[Game sharedGame] sessionID]];
    
    //initial setup of the data
    [[Game sharedGame] setHeroes: [[[Game sharedGame] sessionController] getPlayerData]];
    [[[Game sharedGame] sessionController] changeCleared];
    
    
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
        
        
        //if there is some change, update the game status
        
        if([[[Game sharedGame] sessionController] isChanged]){
            
            [[Game sharedGame] setHeroes: [[[Game sharedGame] sessionController] getPlayerData]];
            
            [[[Game sharedGame] sessionController] changeCleared];
            
        }
        
        
        counterLabel.text =  [NSString stringWithFormat:@"%d player joined the game", [[Game sharedGame] count]];
        [self.playerTable reloadData];

        //if a new game is ready to start, set waiting flag to false, and move to game page
        if([[[Game sharedGame] sessionController] isGameReady]){
            [[Game sharedGame] setWaiting:FALSE];
            [self enterGame];
        }
        
        
//        NSLog(@"my inGameID is %d", [[[Game sharedGame] myself] inGameID]);
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

// this method is only availble to the host since it is where the button is only visible
- (IBAction)startButtonClicked:(id)sender {
    
    [[[Game sharedGame] sessionController] startGame];
    
    [[Game sharedGame] setWaiting:FALSE];
    [self enterGame];
}

- (void) enterGame{
    //RobertTODO: uncomment the line below
//    [[[Game sharedGame] sessionController] getSecret];
    [self performSegueWithIdentifier:@"startGame" sender:self];
}

@end
