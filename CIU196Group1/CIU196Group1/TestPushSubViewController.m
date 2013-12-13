//
//  TestPushSubViewController.m
//  CIU196Group1
//
//  Created by saqirltu on 12/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "TestPushSubViewController.h"

@interface TestPushSubViewController ()
- (IBAction)closeClicked:(id)sender;

@end

@implementation TestPushSubViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
