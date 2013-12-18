//
//  ViewController
//
//  Created by Robert Sebescen on 24/11/13.
//

#import <UIKit/UIKit.h>
#import "TutorialContentViewController.h"

@interface ViewController : UIViewController <UIPageViewControllerDataSource>

- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSArray *pageImages;

@end
