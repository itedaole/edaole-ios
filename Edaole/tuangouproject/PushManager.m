////
////  PushManager.m
////  tuangouproject
////
////  Created by stcui on 11/19/14.
////
////
//
//#import "PushManager.h"
//#import "XGPush.h"
//#import "XGSetting.h"
//
//@implementation PushManager
//+ (void)setupWithLaunchOptions:(NSDictionary *)launchOptions
//{
//    NSLog(@"[XGPush] appid: %u, key: %@", (uint32_t)kXGAPPID, kXGAPPKey);
//    [XGPush startApp:kXGAPPID appKey:kXGAPPKey];
//    void (^successCallback)(void) = ^(void){
//        //如果变成需要注册状态
//        if(![XGPush isUnRegisterStatus])
//        {
//            [self registerPush];
//        }
//    };
//    [XGPush initForReregister:successCallback];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    
//    //推送反馈回调版本示例
//    void (^successBlock)(void) = ^(void){
//        //成功之后的处理
//        NSLog(@"[XGPush]handleLaunching's success");
//    };
//    
//    void (^errorBlock)(void) = ^(void){
//        //失败之后的处理
//        NSLog(@"[XGPush]handleLaunching's error");
//    };
//    
//    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
//}
//+ (void)registerPush
//{
//    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if (sysVer >= 8) {
//        [self registerPush8];
//    } else {
//        [self registerPushBefore8];
//    }
//}
//
//+ (void)registerPushBefore8
//{
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
//}
//
//+ (void)registerPush8
//{
//    //Types
//    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//}
//
//+ (void)registerDeviceToken:(NSData *)deviceToken
//{
//    [[XGSetting getInstance] setChannel:@"appstore"];
//    [XGPush registerDevice:deviceToken successCallback:^{
//        NSLog(@"[XGPush] upload token success");
//    }errorCallback:^{
//        NSLog(@"[XGPush] upload token failed");
//    }];
//}
//
//+ (void)handleNotification:(NSDictionary *)notification
//{
//    NSLog(@"notification: %@", notification);
//    [XGPush handleReceiveNotification:notification successCallback:^{
//        NSLog(@"[XGPush] handle notification success");
//    }errorCallback:^{
//        NSLog(@"[XGPush] handle notification fail");
//    } completion:^{
//        NSLog(@"[XGPush] handle notification finish");
//    }];
//}
//@end
