//
//  BaseTabController.m
//  
//
//  Created by Steven Choi on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseTabController.h"

@implementation BaseTabController

@synthesize tab = _tab;
@synthesize viewControllers = _viewControllers;
@synthesize contentView = _contentView;
@synthesize selectedViewController = _selectedViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.selectedViewController;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - Accessors
- (CGRect)contentFrame
{
    CGRect bounds = self.view.bounds;
    bounds.size.height -= CGRectGetHeight(self.tab.frame);
    return bounds;
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    if (_selectedViewController == selectedViewController) return;
    if (_selectedViewController) {
        [self transitionFromViewController:_selectedViewController toViewController:selectedViewController duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
            [self.view insertSubview:selectedViewController.view belowSubview:self.tab];
        }completion:^(BOOL finished) {
            _selectedViewController = selectedViewController;
            self.contentView = self.selectedViewController.view;
            self.contentView.frame = [self contentFrame];
        }];
    } else {
        [self.view insertSubview:selectedViewController.view belowSubview:self.tab];
        _selectedViewController = selectedViewController;
    }
//    [self.view insertSubview:self.contentView belowSubview:self.tab];

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
//    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
//        UINavigationBar *bar = [(UINavigationController *)self.selectedViewController navigationBar];
//    }
}


- (void)setViewControllers:(NSArray *)viewControllers
{
    if (_viewControllers == viewControllers) return;
    for (UIViewController *vc in _viewControllers) {
        [vc removeFromParentViewController];
    }
    _viewControllers = viewControllers;
    for (UIViewController *vc in viewControllers) {
        [self addChildViewController:vc];
    }
    self.selectedViewController = viewControllers[0];
}

@end
