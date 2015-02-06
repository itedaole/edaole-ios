//
//  Coupon.m
//  tuangouproject
//
//  Created by stcui on 14-1-12.
//
//

#import "Order.h"
#import "ASIHTTPRequest.h"

@interface Order () <ASIHTTPRequestDelegate>
@property (strong) ASIHTTPRequest *req;
@property (strong, nonatomic) NSArray *allOrders;
@end

@implementation Order
IMP_SINGLETON
- (void)load
{
    ASIHTTPRequest *req = [[ASIHTTPRequest alloc] initWithURL: [NSURL URLWithString:TGURL(@"User/getOrders", nil)]];
    self.req = req;
    req.delegate = self;
    [req startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *resp = [request.responseData objectFromJSONData];
        self.allOrders = resp[@"result"];
        NSMutableArray *paied = [NSMutableArray arrayWithCapacity:self.allOrders.count];
        NSMutableArray *unpaied = [NSMutableArray arrayWithCapacity:self.allOrders.count];
        
        for (NSDictionary *item in self.allOrders) {
            NSString *state = item[@"state"];
            if ([state isEqualToString:@"unpay"]) {
                [unpaied addObject:item];
            } else if ([state isEqualToString:@"pay"]) {
                [paied addObject:item];
            }
        }
        self.paiedOrders = paied;
        self.unpaiedOrders = unpaied;
        [self willChangeValueForKey:@"loading"];
        self.req = nil;
        [self didChangeValueForKey:@"loading"];
    });
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self willChangeValueForKey:@"loading"];
    self.req = nil;
    [self didChangeValueForKey:@"loading"];
}

- (BOOL)loading
{
    return nil != self.req;
}

@end
