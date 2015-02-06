//
//  Session.h
//  tuangouproject
//
//  Created by cui on 13-6-12.
//
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "CouponModel.h"

extern NSString * const SessionChangedNotification;

@interface Session : NSObject
DEF_SINGLETON
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *money;
@property (copy, nonatomic) NSString *requireMobile;
@property (copy, nonatomic) NSString *user_id;
@property (nonatomic) BOOL didLogin;
@property (strong, nonatomic) CouponModel *couponModel;

- (void)reset;

- (void)cleanCookies;

- (void)refreshSessionData;

@end

#define SESSION [Session sharedInstance]
