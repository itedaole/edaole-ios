//
//  TabViewController.m
//  
//
//  Created by Steven Choi on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TabViewController.h"
#import "NHTabBar.h"

static const CGFloat kTabHeight = 49;

@implementation TabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)loadView
{
    [super loadView];
    CGRect bounds = self.view.bounds;
    self.tab = [[NHTabBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(bounds) - kTabHeight, CGRectGetWidth(bounds), kTabHeight)];
    self.tab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.tab];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    [super setSelectedViewController:selectedViewController];
    NSInteger idx = [self.viewControllers indexOfObject:selectedViewController];
    [self.tabBar setSelectedIndex:idx];
    if ([selectedViewController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController*)selectedViewController setDelegate:self];
    }
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [(NHTabBar *)self.tab addTarget:self action:@selector(onTabChanged:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setDelegate:(id)delegate
{
    
}

#pragma mark - Actions
- (void)onTabChanged:(id)sender
{
    NSInteger index = self.tabBar.selectedIndex;
    if (index >= 0 && index < self.viewControllers.count) {
        UIViewController *controller = [self.viewControllers objectAtIndex:index];
        self.selectedViewController = controller;
        if ([controller isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)controller setDelegate:self];
        }
    }
//    [(NHTabBar *)self.tab showBadgetAtIndex:3];
}

- (NHTabBar *)tabBar{
    return (NHTabBar*)self.tab;
}

- (void)adjustFrame
{
    UIViewController *selectedController = self.selectedViewController;
    if ([selectedController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)selectedController;
        selectedController = [nav.viewControllers lastObject];
    }
    
    if (selectedController.hidesBottomBarWhenPushed) {
        self.contentView.frame = self.view.bounds;
    } else {
        self.contentView.frame = [self contentFrame];
    }
}

#pragma mark - Accessors
- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    [self.tabBar setTabs:[viewControllers valueForKeyPath:@"tabBarItem"]];
    for (id vc in viewControllers) {
        id v = vc;
        if ([vc isKindOfClass:[UINavigationController class]]) v = [vc viewControllers][0];
        [v addObserver:self forKeyPath:@"modalViewController"
                options:NSKeyValueObservingOptionNew
                context:NULL];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIViewController *)object change:(NSDictionary *)change context:(void *)context
{
    if (object.presentedViewController) {
        [self.view bringSubviewToFront:object.view];
    } else {
        [self.view bringSubviewToFront:self.tabBar];
    }
}

#pragma mark - UINavigationControllerDelegate
/*
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
    }
    [self.tabBar setAlpha:viewController.hidesBottomBarWhenPushed ? 0.0 : 1.0];
    [self adjustFrame];
    if (animated) {
        [UIView commitAnimations];
    }
}*/

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
    }
    self.tabBar.top = viewController.hidesBottomBarWhenPushed ? self.view.height : self.view.height - self.tabBar.height;
//    [self.tabBar setAlpha:viewController.hidesBottomBarWhenPushed ? 0.0 : 1.0];
    [self adjustFrame];
    if (animated) {
        [UIView commitAnimations];
    }

}

@end
