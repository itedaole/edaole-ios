//
//  Session.m
//  tuangouproject
//
//  Created by cui on 13-6-12.
//
//

#import "Session.h"
#import <objc/runtime.h>
#import <string.h>
#import "ASIHTTPRequest.h"
#import "NSHTTPCookieStorage+saveCookies.h"

NSString * const SessionChangedNotification = @"SessionChangedNotification";

static id getter(id self, SEL cmd) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = NSStringFromSelector(cmd);
    return [defaults valueForKey:key];
}

static void setter(id self, SEL cmd, id value) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    const char *name = sel_getName(cmd);
    char *key = malloc(strlen(name) - 4 + 1);
    bzero(key, strlen(name)-3);
    strncat(key, name+3, strlen(name)-4);
    key[0] = tolower(key[0]);
    NSString *k = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
    free(key);
    if ([value isKindOfClass:[NSNull class]]) {
        value = nil;
    }
    if (value) {
        [defaults setValue:value forKey:k];
    } else {
        [defaults removeObjectForKey:k];
    }
    [defaults synchronize];
}

@implementation Session
{
    ASIHTTPRequest *_req;
}
IMP_SINGLETON
@dynamic username, mobile, money,requireMobile,user_id;
- (id)init
{
    self = [super init];
    if (self) {
        if (self.username) {
            self.didLogin = YES;
            [self.couponModel setNeedsReload];
        } else {
            self.didLogin = NO;
        }
    }
    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    const char * name = sel_getName(sel);
    if (strstr(name, "set") == name) {
        class_addMethod([self class], sel, (IMP)setter, "v:@");
    } else {
        class_addMethod([self class], sel, (IMP)getter, "@:v");
    }
    return YES;
}

- (void)reset
{
//    [self performBlockInBackground:^{
//        [NSData dataWithContentsOfURL:[NSURL URLWithString:TGURL(@"User/logout", nil)]];
//    }];
    self.username = nil;
    self.mobile = nil;
    self.money = nil;
    self.didLogin = NO;
    self.requireMobile=nil;
    self.user_id = nil;
    //清理cookise
    [self cleanCookies];
}

- (void)refreshSessionData
{
    _req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString: TGURL(@"User/login", nil)]];
    __weak __typeof(self) wself = self;
    [_req setCompletionBlock:^{
        __strong __typeof(wself) sself = wself;
        ASIHTTPRequest *req = sself->_req;
        NSDictionary *rootDic = [req.responseData objectFromJSONData];
        
        NSDictionary* resultDictionary = [rootDic objectForKey:@"result"];
        [SESSION setUsername:[resultDictionary valueForKeyPath:@"username"]];
        [SESSION setMobile:[resultDictionary valueForKeyPath:@"mobile"]];
        [SESSION setMoney:[resultDictionary valueForKeyPath:@"money"]];
        [SESSION setUser_id:[resultDictionary valueForKey:@"id"]];
        [SESSION setRequireMobile:[resultDictionary valueForKeyPath:@"_config.requireMobile"]];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] synchronizeCookies];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SessionChangedNotification object:sself];
        });
    }];
    [_req startAsynchronous];
}

- (BOOL)didLogin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"];
}

- (void)setDidLogin:(BOOL)didLogin
{
    [[NSUserDefaults standardUserDefaults] setBool:didLogin forKey:@"didLogin"];
    if (didLogin) {
        [self.couponModel setNeedsReload];
    } else {
        self.couponModel = nil;
    }
}

- (CouponModel *)couponModel
{
    if (!_couponModel) {
        _couponModel = [[CouponModel alloc] init];
    }
    return _couponModel;
}

- (void)setNilValueForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

- (void)cleanCookies
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];

    NSArray *servers=@[kWebSite, info[@"Weibo"], info[@"Homepage"]];
    
    for (NSString *urlStr in servers) {
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray* sinaweiboCookies = [cookies cookiesForURL:
                                     [NSURL URLWithString:urlStr]];
        for (NSHTTPCookie* cookie in sinaweiboCookies)
        {
            [cookies deleteCookie:cookie];
        }
    }
}

@end
