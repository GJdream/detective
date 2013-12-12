//
//  MenuViewController.m
//  CIU196Group1
//
//  Created by saqirltu on 27/11/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "MenuViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Game.h"

@interface MenuViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong, nonatomic) IBOutlet UIButton *resumeButton;
@property (strong, nonatomic) IBOutlet UIButton *newgameButton;
@property (strong, nonatomic) IBOutlet UIButton *joingameButton;
@property (strong, nonatomic) IBOutlet UIButton *quitgameButton;
- (IBAction)quitButtonClicked:(id)sender;

@end

@implementation MenuViewController
@synthesize userProfileImage, userNameLabel;

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
    
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(sessionStateChanged:)
//     name:SCSessionStateChangedNotification
//     object:nil];
}

//- (void)sessionStateChanged:(NSNotification*)notification {
//    [self populateUserDetails];
//}
//
//- (void)populateUserDetails
//{
//    if (FBSession.activeSession.isOpen) {
//        [[FBRequest requestForMe] startWithCompletionHandler:
//         ^(FBRequestConnection *connection,
//           NSDictionary<FBGraphUser> *user,
//           NSError *error) {
//             if (!error) {
//                 userNameLabel.text = user.name;
//                 //userProfileImage.profileID = user.id;
//             }
//         }];
//    }
//}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    userNameLabel.text = [[[Game sharedGame] myself] name];
    [userProfileImage setImage:[[[Game sharedGame] myself] image]];
    
    
    if ([[Game sharedGame] sessionID]) {
        // if already in a game
        [self.newgameButton setEnabled:NO];
        [self.newgameButton setHidden:TRUE];
        [self.resumeButton setEnabled:YES];
        [self.resumeButton setHidden:FALSE];
        [self.joingameButton setEnabled:NO];
        [self.joingameButton setHidden:TRUE];
        [self.quitgameButton setEnabled:YES];
        [self.quitgameButton setHidden:FALSE];

        
    } else {
        // if not in any game
        [self.newgameButton setEnabled:YES];
        [self.newgameButton setHidden:FALSE];
        [self.resumeButton setEnabled:NO];
        [self.resumeButton setHidden:TRUE];
        [self.joingameButton setEnabled:YES];
        [self.joingameButton setHidden:FALSE];
        [self.quitgameButton setEnabled:NO];
        [self.quitgameButton setHidden:TRUE];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(IBAction)exit:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    exit(0);
}

- (IBAction)quitButtonClicked:(id)sender {
    [[[Game sharedGame] sessionController] removePlayerFromSession];
    
    [[Game sharedGame] reset];
    [self viewWillAppear: TRUE];
}
@end
