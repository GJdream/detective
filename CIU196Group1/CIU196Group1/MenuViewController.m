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
    
    counter++;
    NSLog(@"setting will appear: %d times",counter);
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

static int counter = 0;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    userNameLabel.text = [[[Game sharedGame] myself] name];
    [userProfileImage setImage:[[[Game sharedGame] myself] image]];
    
    
//    if (FBSession.activeSession.isOpen) {
//        [self populateUserDetails];
//    }
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

@end
