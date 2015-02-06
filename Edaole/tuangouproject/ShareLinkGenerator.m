//
//  ShareLinkGenerator.m
//  tuangouproject
//
//  Created by Steven Choi on 14-7-14.
//
//

#import "ShareLinkGenerator.h"

@implementation ShareLinkGenerator
+ (NSString *)shareLinkForProduct:(NSDictionary *)product
{
    static NSString *homepage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        homepage = [[NSBundle mainBundle] infoDictionary][@"Homepage"];
    });
    NSString *postpending = nil;
    if ([kAppForPlat isEqualToString:@"fw"]) {
        postpending = [homepage stringByAppendingFormat:@"/tuan.php?ctl=deal&id=%@", product[kProductId]];
    } else {
        postpending = [homepage stringByAppendingFormat:@"/team.php?id=%@", product[kProductId]];
    }
    return postpending;
}

@end
