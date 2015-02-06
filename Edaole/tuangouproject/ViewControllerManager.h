//
//  ViewControllerManager.h
//  tuangouproject
//
//  Created by cui on 13-5-25.
//
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"
#import "CategoryViewController.h"
#import "CityListViewController.h"
#import "LoginViewController.h"
#import "AboutViewController.h"
#import "CategoryViewController.h"
#import "PlaceOrderViewController.h"
#import "RegisterController.h"
#import "SearchViewController.h"
#import "ScannerViewController.h"
#import "WebViewController.h"
#import "DetailViewController.h"
#import "YijianViewController.h"
#import "ConfirmViewController.h"
#import "BindMobileViewController.h"
#import "DoubleSideViewController.h"

@interface ViewControllerManager : NSObject
+ (instancetype)sharedInstance;
- (UITabBarController *)tabBarController;
@end

@interface ViewControllerManager (DynamicMethods)
- (UIViewController *)listViewController;
- (UIViewController *)mainListViewController;
- (UIViewController *)nearbyViewController;
- (UIViewController *)mapViewController;
- (UIViewController *)couponViewController;
- (UIViewController *)profileViewController;
- (UIViewController *)aboutViewController;

- (UIViewController *)detailViewController;
@end

@interface UIViewController (UINavigationControllerWrapper)
- (UINavigationController *)wrapByNavigation;
@end