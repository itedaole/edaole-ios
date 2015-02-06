//
//  WXPayUtil.h
//  tuangouproject
//
//  Created by stcui on 4/21/14.
//
//

#import <Foundation/Foundation.h>
@class WxPayObj;

@interface WXPayUtil : NSObject

+ (instancetype)sharedInstance;
- (void)payForProductName:(NSString *)productName orderID:(NSString *)orderID obj:(WxPayObj*)obj completion:(void(^)(NSDictionary *order, NSError *error))completion;
+ (BOOL)isWeixinInstalled;
@end
