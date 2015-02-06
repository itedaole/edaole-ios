//
//  DoubleSideViewController.m
//  tuangouproject
//
//  Created by cui on 13-5-25.
//
//

#import "DoubleSideViewController.h"

@interface DoubleSideViewController ()

@end

@implementation DoubleSideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFront:(UIViewController *)frontViewController
               back:(UIViewController *)backViewController
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.frontViewController = frontViewController;
        self.backViewController = backViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.frontViewController.view];
    self.frontViewController.view.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewController:self.visibleViewController didAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self viewController:self.visibleViewController didAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self viewController:self.visibleViewController willDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self viewController:self.visibleViewController didDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewController:(UIViewController *)controller willAppear:(BOOL)animated
{
    if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_5_0) {
        [controller viewWillAppear:animated];
    }
}

- (void)viewController:(UIViewController *)controller didAppear:(BOOL)animated
{
    if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_5_0) {
        [controller viewDidAppear:animated];
    }
}

- (void)viewController:(UIViewController *)controller willDisappear:(BOOL)animated
{
    if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_5_0) {
        [controller viewWillDisappear:animated];
    }
}

- (void)viewController:(UIViewController *)controller didDisappear:(BOOL)animated
{
    if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_5_0) {
        [controller viewDidDisappear:animated];
    }
}

- (BOOL)isFrontVisible
{
    return !([self.backViewController isViewLoaded] && self.backViewController.view.window);
}

- (UIViewController *)visibleViewController
{
    return self.frontVisible ? self.frontViewController : self.backViewController;
}

- (void)flip
{
    
}

- (IBAction)onFlip:(UIBarButtonItem *)sender
{
    [self flip];
    sender.title = self.visibleViewController.title;
}
@end
