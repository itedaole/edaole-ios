//
//  ShareLinkGenerator.h
//  tuangouproject
//
//  Created by Steven Choi on 14-7-14.
//
//

#import <Foundation/Foundation.h>

@interface ShareLinkGenerator : NSObject
+ (NSString *)shareLinkForProduct:(NSDictionary *)product;
@end
