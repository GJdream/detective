//
//  SettingViewController.m
//  CIU196Group1
//
//  Created by saqirltu on 27/11/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "SettingViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#import "Game.h"

@interface SettingViewController ()
- (IBAction)logoutButtonWasPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)resetButtonPressed:(id)sender;

@end

@implementation SettingViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    if (FBSession.activeSession.isOpen) {
        // To-do, show logout button
        [self.loginButton setEnabled:NO];
        [self.loginButton setHidden:TRUE];
        [self.logoutButton setEnabled:YES];
        [self.logoutButton setHidden:FALSE];
        
    } else {
        // No, show the login button
        [self.loginButton setEnabled:YES];
        [self.loginButton setHidden:FALSE];
        [self.logoutButton setEnabled:NO];
        [self.logoutButton setHidden:TRUE];

        //        [[self.window rootViewController] performSegueWithIdentifier:@"loginSegue" sender:(id)[self.window rootViewController]];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButtonWasPressed:(id)sender {
    //NSLog(@"this did run");
    [FBSession.activeSession closeAndClearTokenInformation];
    [self.view setNeedsDisplay];
}
- (IBAction)resetButtonPressed:(id)sender {
    [[[Game sharedGame] myself] reset];
}
@end
