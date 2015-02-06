//
//  Coupon.h
//  tuangouproject
//
//  Created by stcui on 14-1-12.
//
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface Order : NSObject
DEF_SINGLETON
@property (strong, nonatomic) NSArray *paiedOrders;
@property (strong, nonatomic) NSArray *unpaiedOrders;
@property (readonly, nonatomic) BOOL loading;
- (void)load;

@end
