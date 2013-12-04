//
//  NewGameViewController.m
//  CIU196Group1
//
//  Created by Robert Sebescen on 2013-11-29.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "NewGameViewController.h"
#import "SessionController.h"

@interface NewGameViewController ()
@property (strong, nonatomic) IBOutlet UILabel *sessionIdLabel;

@end

@implementation NewGameViewController

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

@end
