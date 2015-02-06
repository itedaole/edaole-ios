//
//  CommerceTracking.m
//  tuangouproject
//
//  Created by stcui on 11/6/14.
//
//

#import "CommerceTracking.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@implementation CommerceTracking
+ (void)tracePurchaseSuccessWithID:(NSString *)productID revenue:(NSNumber *)revenue shipping:(NSNumber *)shipping
{
    // Assumes a tracker has already been initialized with a property ID, otherwise
    // this call returns null.
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createTransactionWithId:@"0_123456"             // (NSString) Transaction ID, should be unique among transactions.
                                                    affiliation:@"iOS"         // (NSString) Affiliation
                                                        revenue:revenue         // (int64_t) Order revenue (including tax and shipping)
                                                            tax:@(0)
                                                       shipping:shipping             // (int64_t) Shipping
                                                   currencyCode:@"CNY"] build]];          // (NSString) Currency code
}
@end
