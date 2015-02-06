//
//  AppDelegate.m
//  tuangouproject
//
//  Created by liu song on 13-3-5.
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import "AppDelegate.h"
#import "ListViewController.h"
#import "CouponViewController.h"
#import "BGView.h"
#import "AboutViewController.h"
#import "LoginViewController.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
//#import "Tenpay.h"
//#import "AlixPay.h"
#import "MobClick.h"
#import "Theme.h"
#import <ShareSDK/ShareSDK.h>

#import "CouponModel.h"
#import "CategoryModel.h"
#import "WXPayUtil.h"
#import "ViewControllerManager.h"
#import <objc/runtime.h>
#import <TencentOpenAPI/QQApi.h>
//#import "XGPush.h"
#import "MainListViewController.h"
#import "MapViewController.h"
#import "UIAlertView+Blocks.h"
#import "GAI.h"
@import MediaPlayer;
#import "MediaPlayerViewController.h"

static NSString *const kTrackingId = @"UA-TRACKING-ID";
#import "PushManager.h"

#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate ()
{
    MediaPlayerViewController *_moviePlayerController;
}
@property (strong, nonatomic) ASIHTTPRequest *pushTokenUploadReq;
@end

@implementation AppDelegate

- (void)setupViewHierachyOnWindow:(UIWindow *)window
{
    ViewControllerManager *vcm = [ViewControllerManager sharedInstance];
	self.tabBarController = [vcm tabBarController];
    window.rootViewController = self.tabBarController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:@"AIzaSyBlm6kT6F3eK1u251o4Wtr5KLdyFAW39Sg"];
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-XXXX-Y"];

    //[PushManager setupWithLaunchOptions:launchOptions];
    [[Session sharedInstance] addObserver:self forKeyPath:@"didLogin" options:NSKeyValueObservingOptionNew context:NULL];
    [[CategoryModel sharedInstance] loadFromNetwork];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSBundle mainBundle].infoDictionary[@"CFBundlerVersion"]
                                              forKey:@"version"];
#ifdef DEBUG
    BOOL didPlayVideo = NO;
#else
    BOOL didPlayVideo = [[NSUserDefaults standardUserDefaults] boolForKey:@"didPlayVideo"];
#endif
    
    __unsafe_unretained id wself = self;
    void (^startMainApp)(MediaPlayerViewController *, MediaPlayerFinishType) = ^(MediaPlayerViewController *p, MediaPlayerFinishType type){
        __strong AppDelegate *sself = wself;
        [sself chooseThemeAndStart:kTheme];
        NSDictionary *notification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        if (notification[@"id"]) {
            MainListViewController *mainListViewController = [[sself tabBarController].viewControllers[0] viewControllers][0];
            if ([mainListViewController isKindOfClass:[MainListViewController class]]) {
                [mainListViewController showProductDetailWithId:notification[@"id"]];
            }
        }
        sself->_moviePlayerController = nil;
        if (p) {
            switch (type) {
                case MediaPlayerFinishTypeLogin:
                {
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    [self.tabBarController presentViewController:loginVC animated:NO completion:nil];
                } break;
                case MediaPlayerFinishTypeRegister: {
                    RegisterController *registerController = [[RegisterController alloc] init];
                    [self.tabBarController presentViewController:registerController animated:NO completion:nil];
                }  break;
                case MediaPlayerFinishTypeSkip:
                default:
                    break;
            }
        }
    };

    
    if (didPlayVideo) {
        startMainApp(nil, 0);
    } else {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"splash" ofType:@"mp4"]];
        _moviePlayerController = [[MediaPlayerViewController alloc] initWithContentURL:url];
        _moviePlayerController.onFinish = startMainApp;
        UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window = window;
        [window makeKeyAndVisible];
        self.window.rootViewController = _moviePlayerController;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"didPlayVideo"];
        [_moviePlayerController play];
    }
    return YES;
}

- (void)chooseThemeAndStart:(NSString *)theme
{
    [Theme setBundleName:nil];
    [self startApp];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
    [self chooseThemeAndStart: buttonIndex == 0 ? @"blue" : @"pink"];
}

- (void)startApp
{
//    [Theme setBundleName:kTheme];
    
    [self _initShareSDK];
    NSString *umKey = kUmengKey;
    if ([umKey length]>0) {
        [MobClick startWithAppkey:kUmengKey];
    }
    NSString *name =  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    [MobClick event:@"open" label:name];
    
    if ([UIBarButtonItem instancesRespondToSelector:@selector(setTintColor:)] && [UINavigationBar instancesRespondToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        if ([UIColor barTintColor]) {
            [[UIBarButtonItem appearance] setTintColor:[UIColor barTintColor]];
        }
        UIImage *navBg = [UIImage imageNamed:@"bg_navigationBar"];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {
            UIGraphicsBeginImageContext(CGSizeMake(320, 64));
            [navBg drawInRect:CGRectMake(0, 0, 320, 64)];
            navBg = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        [[UINavigationBar appearance] setBackgroundImage:navBg forBarMetrics:UIBarMetricsDefault];
    }
    if ([[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."][0] floatValue] > 5) {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor colorWithWhite:0.3 alpha:1];
        shadow.shadowOffset = CGSizeMake(0, -1);
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSShadowAttributeName: shadow}];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    if (self.window) {
        self.window.hidden = YES;
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    [self setupViewHierachyOnWindow:self.window];
    
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    static NSString *tenpayScheme = nil;
//    static NSString *alipayScheme = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSString *bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
//        tenpayScheme = [NSString stringWithFormat:@"tenpay-%@-tuangou", bundleName];
//        alipayScheme = [NSString stringWithFormat:@"alipay-%@-tuangou", bundleName];
//    });
//    NSString *scheme = [url scheme];
//
//    if ([scheme isEqualToString:tenpayScheme]) {
//        [Tenpay handlePayCallBack:url];
//        return YES;
//    } else if ([scheme isEqualToString:alipayScheme]) {
//        NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        AlixPayResult *result = [[AlixPayResult alloc] initWithString:query];
//        if (result.statusCode == 9000) {
//            [SVProgressHUD showSuccessWithStatus:@"支付成功！"];
//        }
//        return YES;
//    }
    
   // [WXApi handleOpenURL:url delegate:self];
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //[WXApi handleOpenURL:url delegate:self];
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"weixin" object:resp];
}

- (void)setPageIndex:(int)index
{
    self.tabBarController.selectedIndex = index;
}

- (NSInteger)pageIndex
{
    return self.tabBarController.selectedIndex;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
}

#pragma mark - Remote Notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"push token: %@", deviceToken);
    NSString *urlStr = TGURL(@"Upload/XGPush",
          @{@"id": [NSString stringWithFormat:@"i_%@", deviceToken],
            @"plat" : @"ios",
            });
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString: urlStr]];
    __weak __typeof(self) wself = self;
    [req setCompletionBlock:^{
        wself.pushTokenUploadReq = nil;
    }];
    self.pushTokenUploadReq = req;
    [req startAsynchronous];
    //[PushManager registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //[PushManager handleNotification:userInfo];

    if (! userInfo[@"id"]) {
        return;
    }
    UINavigationController *nav = (UINavigationController*)self.tabBarController.selectedViewController;
    if ([nav isKindOfClass:[UINavigationController class]]) {
        ListViewController *listViewController = [nav.viewControllers lastObject];
        if (([listViewController isKindOfClass:[ListViewController class]] ||
            [listViewController isKindOfClass:[MapViewController class]]) &&
            ![listViewController presentedViewController]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[userInfo valueForKeyPath:@"aps.alert"]
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"忽略"
                                                  otherButtonTitles:@"去看看", nil];
            [alert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != alert.cancelButtonIndex) {
                    [listViewController showProductDetailWithId:userInfo[@"id"]];
                }
            }];
        }
    }

}
//#pragma mark - tenpay delegate
//- (void)tenpayDidFinish:(TenpayResult)result details:(NSDictionary *)details {
//
//    switch (result) {
//        case TenpayResultCancelledByUser:
//            return;
//            break;
//        case TenpayResultNoError:
//        {
//            UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
//            [nav popToRootViewControllerAnimated:NO];
//            if ([nav presentedViewController]) {
//                [nav dismissModalViewControllerAnimated:NO];
//            }
//
//            [self.tabBarController setSelectedIndex:1];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付成功"
//                                                            message:@"购买成功"
//                                                           delegate:nil cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
//            break;
//        }
//        default:
//        {
//            NSString *message = [NSString stringWithFormat:@"返回码：%d 返回消息：%@",
//                                 result,
//                                 [details objectForKey:@"retmsg"]];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付失败"
//                                                            message:message
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
//            break;
//        }
//    }
//}

- (void)_initShareSDK
{
    NSString *weiboRedirect = [NSString stringWithFormat:@"http://%@", kSinaWeiboRedirectPath];
    [ShareSDK registerApp:kShareSDKKey];
    [ShareSDK ssoEnabled:YES];
    [ShareSDK connectSinaWeiboWithAppKey:kSinaWeiboKey
                               appSecret:kSinaWeiboSecret
                             redirectUri:weiboRedirect];
    [ShareSDK connectQQWithAppId:kQZoneAppID
                        qqApiCls:QQApi.class];
//    [ShareSDK connectQZoneWithAppKey:kQZoneAppID
//                           appSecret:kQZoneAppSecret];
//    [ShareSDK connectWeChatWithAppId:kWeChatAppID
//                           wechatCls:[WXApi class]];
    
    [ShareSDK connectWeChatWithAppId:@"wx9d2279ea33cddad9"   //微信APPID
                           appSecret:@"f9724ba03ef194169ea8dd14fbaa689f"  //微信APPSecret
                           wechatCls:[WXApi class]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == [Session sharedInstance]) {
        if ([Session sharedInstance].didLogin) {
            
        }
    }
}

- (void)dealloc
{
    [[Session sharedInstance] removeObserver:self forKeyPath:@"didLogin"];
}

@end

