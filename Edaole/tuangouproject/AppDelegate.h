//
//  AppDelegate.h
//  tuangouproject
//
//  Created by liu song on 13-3-5.
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "WXApi.h"

#define App (AppDelegate*)[[UIApplication sharedApplication] delegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate,WXApiDelegate>
{
    UIViewController *homepageViewController;
}
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic) BOOL didLogin;
@property (nonatomic) BOOL parternerDidLogin;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) id<GAITracker> tracker;


@property (assign, nonatomic) NSInteger pageIndex;

@end

