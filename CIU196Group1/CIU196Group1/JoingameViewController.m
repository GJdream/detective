//
//  JoingameViewController.m
//  CIU196Group1
//
//  Created by saqirltu on 08/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "JoingameViewController.h"
#import "Game.h"
#import "SessionController.h"

@interface JoingameViewController ()
@property (strong, nonatomic) IBOutlet UITextField *sessionIDInput;
- (IBAction)joinButtonClicked:(id)sender;

@end

@implementation JoingameViewController

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

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidAppear:(BOOL)animated{
    if ([[Game sharedGame] sessionID]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//dismiss the keyboard when the Text Field is not on focus
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinButtonClicked:(id)sender {
    
//    [[Game sharedGame] setSessionID: [self.sessionIDInput.text integerValue]];
    NSInteger inGameID = [[[Game sharedGame] sessionController] addPlayerToSession: [self.sessionIDInput.text integerValue]];
    
    
    if(inGameID){
        [[[Game sharedGame] myself] setInGameID: inGameID];
        [self performSegueWithIdentifier:@"joinGame" sender:self];
    }
    else{
        [[Game sharedGame] setSessionID:0];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Session not found" message:@"pleae check with the host for correct Session ID" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [self performSelector:@selector(autoDismiss:) withObject:alert afterDelay:4];
    }
}

-(void)autoDismiss:(UIAlertView*)x{
	[x dismissWithClickedButtonIndex:-1 animated:YES];
}


@end
