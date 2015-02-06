//
//  ViewControllerManager.m
//  tuangouproject
//
//  Created by cui on 13-5-25.
//
//

#import "ViewControllerManager.h"
#import <objc/runtime.h>
#import "Theme.h"
#import "CouponViewController.h"
#import "TabViewController.h"
#import "MainListViewController.h"
static id controllerByName(NSString *name) {
    if (name.length == 0) return nil;
    name = [name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[name substringToIndex:1] uppercaseString]];
    
    Class klass = NSClassFromString(name);
    if ([[NSBundle mainBundle] pathForResource:name ofType:@"nib"]) {
        return [[klass alloc] initWithNibName:name bundle:nil];
    }
    return [[klass alloc] init];
}
static id controllerBySelector(id self, SEL cmd) {
    return controllerByName(NSStringFromSelector(cmd));
}

@implementation ViewControllerManager
+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *methodName = NSStringFromSelector(sel);
    if ([methodName hasSuffix:@"ViewController"]) {
        class_addMethod(self, sel, (IMP)controllerBySelector, "@:v");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

- (UIViewController *)couponViewController
{
    NSString * xibName =
    [[Theme bundleName] isEqualToString:@"blue"] ? @"CouponViewController-blue" : @"CouponViewController";
    return [[CouponViewController alloc] initWithNibName:xibName bundle:nil];
}

- (UITabBarController *)tabBarController
{
    TabViewController *tab = [[TabViewController alloc] init];
    //团购项目列表
    ListViewController *listViewController = (ListViewController*)[self mainListViewController];
    listViewController.doLocate = YES;
	UINavigationController *navigationController = [listViewController wrapByNavigation];
    // 周边
    UINavigationController *nearbyNav = [[self nearbyViewController] wrapByNavigation];
    //我的团购
	UINavigationController *navigation0Controller = [[self profileViewController] wrapByNavigation];
    //更多
	UINavigationController *navigation4Controller = [[self aboutViewController] wrapByNavigation];
    
	[tab setViewControllers:@[
     navigationController,
     nearbyNav,
     navigation0Controller,
     navigation4Controller]];
    return (UITabBarController *)tab;
}

@end

@implementation UIViewController (UINavigationControllerWrapper)
- (UINavigationController *)wrapByNavigation
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    nav.navigationBar.tintColor = [UIColor barTintColor];
    return nav;
}
@end
