//
//  TestViewController.m
//  CIU196Group1
//
//  Created by saqirltu on 12/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"running method: self in init");
    }
    NSLog(@"running method: init");
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"running method: self in initWithCoder");
    }
    NSLog(@"running method: initWithCoder");
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"running method: initWithName");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"running method: viewDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"running method: DidReceiveMemoryWarning");
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"running method: viewWillAppear");
}
- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"running method: viewDidAppear");
}
- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"running method: viewWillDisappear");
}
- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"running method: viewDidDisappear");
}


@end
