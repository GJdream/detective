//
//  ProfileViewController.m
//  CIU196Group1
//
//  Created by saqirltu on 04/12/13.
//  Copyright (c) 2013 Eric Zhang, Robert Sebescen. All rights reserved.
//

#import "ProfileViewController.h"
#import "Game.h"
@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImagePickerController* imagePicker;
- (IBAction)cancelClicked:(id)sender;
- (IBAction)doneClicked:(id)sender;
- (IBAction)imageClicked:(id)sender;

@end

@implementation ProfileViewController

@synthesize imagePicker, nameField, imageView;

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
    
    nameField.text = [[[Game sharedGame] myself] name];
    imageView.image = [[[Game sharedGame] myself] image];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneClicked:(id)sender {
    [[[Game sharedGame] myself] setName:nameField.text];
    [[[Game sharedGame] myself] setImage:imageView.image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)imageClicked:(id)sender {
    
//    NSLog(@"image clicked");
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }
//    else
//    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    //[self presentModalViewController:imagePicker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
