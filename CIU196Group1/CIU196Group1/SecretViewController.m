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
    NSString *role = @"nothing";
    switch ([[[Game sharedGame] myself] role]) {
        case 0:
            role = @"detective";
            break;
        case 1:
            role = @"police";
            break;
        case 2:
            role = @"killer";
            break;
            
        default:
            break;
    }
    
    self.roleLabel.text = [NSString stringWithFormat:@"Role: %@", role];
    
    self.clueLabel.text = [NSString stringWithFormat:@"Clue: %@", [[[Game sharedGame] myself] clue]];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
