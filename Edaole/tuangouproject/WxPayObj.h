//
//  WxPayObj.h
//  tuangouproject
//
//  Created by iBcker on 14-5-31.
//
//

#import <Foundation/Foundation.h>

@interface WxPayObj : NSObject
@property (strong, nonatomic) NSString *AppId;
@property (strong, nonatomic) NSString *PartnerId;
@property (strong, nonatomic) NSString *SignKey;
@property (strong, nonatomic) NSString *AppSecret;

@property (strong, nonatomic) NSString *package;

@end
