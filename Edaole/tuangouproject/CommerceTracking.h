//
//  CommerceTracking.h
//  tuangouproject
//
//  Created by stcui on 11/6/14.
//
//

#import <Foundation/Foundation.h>

@interface CommerceTracking : NSObject
+ (void)tracePurchaseSuccessWithID:(NSString *)productID revenue:(NSNumber *)revenue shipping:(NSNumber *)shipping;
@end
