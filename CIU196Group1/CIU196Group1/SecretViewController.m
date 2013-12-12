//
//  SecretViewController.m
//  CIU196Group1
//
//  Created by saqirltu on 08/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "SecretViewController.h"
#import "Game.h"

@interface SecretViewController ()
@property (strong, nonatomic) IBOutlet UILabel *roleLabel;

@property (strong, nonatomic) IBOutlet UILabel *clueLabel;
@end

@implementation SecretViewController

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
    
    self.roleLabel.text = [NSString stringWithFormat:@"Role: %d", [[[Game sharedGame] myself] role]];
    
    self.clueLabel.text = [NSString stringWithFormat:@"Clue: %@", [[[Game sharedGame] myself] clue]];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
