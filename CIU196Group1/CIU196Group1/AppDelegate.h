//
//  AppDelegate.h
//  Mater
//
//  Created by saqirltu on 27/11/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//
extern NSString *const SCSessionStateChangedNotification;

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (void)openSession;

@property (strong, nonatomic) UIWindow *window;


@end
