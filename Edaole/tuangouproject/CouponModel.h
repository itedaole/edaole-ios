//
//  Coupon.h
//  tuangouproject
//
//  Created by stcui on 14-2-15.
//
//

#import <Foundation/Foundation.h>
#import "AsyncModel.h"

@interface CouponModel : AsyncModel
@property (strong, nonatomic) NSError *error;
@property (assign, nonatomic) BOOL loading;
@property (strong, nonatomic) NSArray *coupons;
@property (strong, nonatomic) NSArray *consumedCoupons;
@property (strong, nonatomic) NSArray *expiredCoupons;
@property (strong, nonatomic) NSArray *unusedCoupons;
@property (strong, nonatomic) NSArray *expressCoupons;

- (void)setNeedsReload;

@end
