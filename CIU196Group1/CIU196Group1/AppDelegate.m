//
//  AppDelegate.m
//  Mater
//
//  Created by saqirltu on 27/11/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

NSString *const SCSessionStateChangedNotification =
@"com.facebook.CIU196Group1:SCSessionStateChangedNotification";

#import "AppDelegate.h"

#import <FacebookSDK/FacebookSDK.h>

#import "Game.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    [FBProfilePictureView class];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
//    
//    UIViewController *menuController = (UIViewController*)[mainStoryboard
//                                                                       instantiateViewControllerWithIdentifier: @"menuController"];
    
    
    UINavigationController *navigationController = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"ViewController"];    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:navigationController];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    

    // Override point for customization after application launch.
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[Game sharedGame] saveChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[Game sharedGame] saveChanges];
    [FBSession.activeSession close];
}


FBProfilePictureView *fbImage;
SEL getImageSelector;

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 if (!error) {
                     [[[Game sharedGame] myself] setName:user.name];
                     fbImage = [[FBProfilePictureView alloc] init];
                     fbImage.profileID = user.id;
                     getImageSelector = sel_registerName("getUserImageFromFBView");
                     [self performSelector:getImageSelector withObject:nil afterDelay:1.0];
                 }
             }];
            
            [[self.window rootViewController] dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [[self.window rootViewController] dismissViewControllerAnimated:NO completion:nil];
            
            [FBSession.activeSession closeAndClearTokenInformation];
                        break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:SCSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}



- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void)getUserImageFromFBView
{
    
    UIImage *img = nil;
    
    fbImage.pictureCropping = FBProfilePictureCroppingSquare;
    
    //1 - Solution to get UIImage obj
    
    for (NSObject *obj in [fbImage subviews]) {
        if ([obj isMemberOfClass:[UIImageView class]]) {
            UIImageView *objImg = (UIImageView *)obj;
            img = objImg.image;
            break;
        }
    }
    
    //2 - Solution to get UIImage obj
    
    //    UIGraphicsBeginImageContext(profileDP.frame.size);
    //    [profileDP.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    img = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    
    //Here I'm setting image and it works 100% for me.
    
    [[[Game sharedGame] myself] setImage:img];
    
}


@end
