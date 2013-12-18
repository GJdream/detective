//
//  PageContentViewController.h
//  PageViewDemo
//
//  Created by Robert Sebescen on 24/11/13.
//

#import <UIKit/UIKit.h>

@interface TutorialContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property NSUInteger pageIndex;

@property NSString *imageFile;
@end
