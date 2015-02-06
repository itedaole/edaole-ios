//
//  DoubleSideViewController.h
//  tuangouproject
//
//  Created by cui on 13-5-25.
//
//

#import <UIKit/UIKit.h>

@interface DoubleSideViewController : UIViewController
@property (strong, nonatomic) UIViewController *frontViewController;
@property (strong, nonatomic) UIViewController *backViewController;
@property (readonly, nonatomic, getter = isFrontVisible) BOOL frontVisible;
@property (readonly, nonatomic, assign) UIViewController *visibleViewController;

- (id)initWithFront:(UIViewController *)frontViewController
               back:(UIViewController *)backViewController;

- (void)flip;

- (IBAction)onFlip:(id)sender;
@end
