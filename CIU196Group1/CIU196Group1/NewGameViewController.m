//
//  NewGameViewController.m
//  CIU196Group1
//
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "NewGameViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#import "Player.h"
#import "PlayerCell.h"

#import "SessionController.h"


@interface NewGameViewController ()
@property (strong, nonatomic) IBOutlet UITableView *playerTable;
@property (strong, nonatomic) IBOutlet UILabel *sessionIDLabel;
@end

@implementation NewGameViewController
NSMutableArray *players;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // player database setupssssssssssss
    
    players = [NSMutableArray arrayWithCapacity:20];
    
    Player *player = [[Player alloc] init];
    player.name = @"Bill Evans";
    player.gameSessionID = 1;
    [players addObject:player];
    
    player = [[Player alloc] init];
    player.name = @"Oscar Peterson";
    player.gameSessionID = 2;
    [players addObject:player];
    
    player = [[Player alloc] init];
    player.name = @"Dave Brubeck";
    player.gameSessionID = 3;
    [players addObject:player];

    
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
    return [players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerCell *cell = (PlayerCell*)[tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
    
    Player *player = players[indexPath.row];
    
    cell.nameLabel.text = player.name;
//    cell.profileImage.profileID = ?
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (void)viewWillAppear:(BOOL)animated {
    [self.playerTable reloadData];
    self.sessionIDLabel.text = @"defaule_shit";

    SessionController *sc = [[SessionController alloc] init];
    self.sessionIDLabel.text = [NSString stringWithFormat:@"ID: %d", sc.getNewSessionID];
    //NSUInteger res = [sc addPlayerToSession:14];
    //NSLog(@"result %d", res);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
