//
//  NewGameViewController.m
//  CIU196Group1
//
<<<<<<< HEAD
//  Created by saqirltu on 29/11/13.
=======
//  Created by Robert Sebescen on 2013-11-29.
>>>>>>> 9879aea09b90356c3c7645543cd7093abbfefb03
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "NewGameViewController.h"
<<<<<<< HEAD

#import <FacebookSDK/FacebookSDK.h>

#import "Player.h"
#import "PlayerCell.h"

@interface NewGameViewController ()
@property (strong, nonatomic) IBOutlet UITableView *playerTable;
@property (strong, nonatomic) IBOutlet UILabel *sessionIDLabel;
=======
#import "SessionController.h"

@interface NewGameViewController ()
@property (strong, nonatomic) IBOutlet UILabel *sessionIdLabel;
>>>>>>> 9879aea09b90356c3c7645543cd7093abbfefb03

@end

@implementation NewGameViewController
<<<<<<< HEAD
NSMutableArray *players;
=======
>>>>>>> 9879aea09b90356c3c7645543cd7093abbfefb03

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
<<<<<<< HEAD
    
    // player database setupssssssssssss
    
    players = [NSMutableArray arrayWithCapacity:20];
    
    Player *player = [[Player alloc] init];
    player.name = @"Bill Evans";
    player.gameID = 1;
    [players addObject:player];
    
    player = [[Player alloc] init];
    player.name = @"Oscar Peterson";
    player.gameID = 2;
    [players addObject:player];
    
    player = [[Player alloc] init];
    player.name = @"Dave Brubeck";
    
    player.gameID = 3;
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
    self.sessionIDLabel.text = @"testSTRING";
}  // Dispose of any resources that can be recreated.


=======
    SessionController *sc = [[SessionController alloc] init];
    self.sessionIdLabel.text = [NSString stringWithFormat:@"ID: %d", sc.getNewSessionID];
    //NSUInteger res = [sc addPlayerToSession:14];
    //NSLog(@"result %d", res);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

>>>>>>> 9879aea09b90356c3c7645543cd7093abbfefb03
@end
