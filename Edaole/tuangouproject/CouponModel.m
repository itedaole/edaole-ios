//
//  Coupon.m
//  tuangouproject
//
//  Created by stcui on 14-2-15.
//
//

#import "CouponModel.h"
#import "ASIHTTPRequest.h"

@interface CouponModel () <ASIHTTPRequestDelegate>
@end

@implementation CouponModel
{
    dispatch_queue_t _parseQueue;
    dispatch_queue_t _actorQueue;
}

- (id)init
{
    self = [super init];
    if (self) {
        dispatch_queue_t target = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        _parseQueue = dispatch_queue_create("coupons.parse", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(target, _parseQueue);
        _actorQueue = dispatch_queue_create("coupons.parse", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(target, _actorQueue);
    }
    return self;
}

- (void)loadFromNetwork
{
    if (!self.coupons) {
        [self loadFromDisk];
    }
    //请求团购列表
    NSURL *url = [NSURL URLWithString:TGURL(@"User/getCoupon", nil)];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    if (request.error) {
        self.error = request.error;
    }
    
    NSDictionary *rootDic = [request.responseData objectFromJSONData];
    
    if([[NSString stringWithFormat:@"%@", [rootDic objectForKey:@"status"]] isEqualToString: @"1" ])
    {
        NSArray *response = [rootDic objectForKey:@"result"];
        self.coupons = response;

        // 未使用
        NSMutableArray *unconsumed = [NSMutableArray arrayWithCapacity:response.count];
        // 已使用
        NSMutableArray *consumed   = [NSMutableArray arrayWithCapacity:response.count];
        // 已过期
        NSMutableArray *outdated   = [NSMutableArray arrayWithCapacity:response.count];
        NSArray *couponsDict = response;
        for (NSDictionary *coupon in couponsDict) {
            BOOL used = [[coupon valueForKey:@"consume"] isEqualToString:@"Y"];
            NSDate *exp = [NSDate dateWithTimeIntervalSince1970:[[coupon valueForKey:@"expire_time"] integerValue]];
            if (used) {
                [consumed addObject:coupon];
            } else {
                if ([exp timeIntervalSinceNow] < 0) {
                    [outdated addObject:coupon];
                } else {
                    [unconsumed addObject:coupon];
                }
            }
        }
        self.expiredCoupons = outdated;
        self.unusedCoupons = unconsumed;
        self.consumedCoupons = consumed;
        
        url = [NSURL URLWithString:TGURL(@"User/getCoupon", @{@"express":@""})];
        request = [ASIHTTPRequest requestWithURL:url];
        [request startSynchronous];
        if (request.error) {
            self.error = request.error;
        }
        
        rootDic = [[request.responseData objectFromJSONData] valueForKeyPath:@"result"];

        self.expressCoupons = [rootDic valueForKey:@"express"];
        self.rootObject = @{@"all":self.coupons?:@[], @"expired":self.expiredCoupons?:@[], @"unused":self.unusedCoupons?:@[],
                            @"used":consumed?:@[],
                            @"express":self.expressCoupons?:@[]};
    }
    [self saveToDisk];
}

- (void)loadFromDisk
{
    [super loadFromDisk];
    NSDictionary *obj = (NSDictionary *)self.rootObject;
    self.coupons = obj[@"all"];
    self.expiredCoupons = obj[@"expired"];
    self.unusedCoupons =  obj[@"unused"];
    self.consumedCoupons = obj[@"consumed"];
    self.expressCoupons = obj[@"express"];
}

- (void)setNeedsReload
{
    dispatch_async(_actorQueue, ^{
        self.loading = YES;
        [self loadFromNetwork];
        self.loading = NO;
    });
}

@end
