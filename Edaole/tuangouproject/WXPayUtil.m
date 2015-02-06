//
//  WXPayUtil.m
//  tuangouproject
//
//  Created by stcui on 4/21/14.
//
//

#import "WXPayUtil.h"
#import "NSString+MKNetworkKitAdditions.h"
#import "CommonUtil.h"
#import "ASIFormDataRequest.h"
#import "WXApi.h"
#import "TGURL.h"
#import "WxPayObj.h"

NSString *AccessTokenKey = @"access_token";
NSString *PrePayIdKey = @"prepayid";
NSString *errcodeKey = @"errcode";
NSString *errmsgKey = @"errmsg";
NSString *expiresInKey = @"expires_in";

@interface WXPayUtil ()
@property (strong, nonatomic)NSString *nonceStr;
@property (strong, nonatomic) NSString *timestamp;
@property (strong, nonatomic) NSString *traceId;

@property (strong, nonatomic) ASIHTTPRequest *request;
@end

@implementation WXPayUtil
{
    ASIHTTPRequest *_req;
}
+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (NSString *)genTimestamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}
- (NSString *)genNonceStr
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}
/**
 * 建议 traceid 字段包含用户信息及订单信息，方便后续对订单状态的查询和跟踪
 */
- (NSString *)genTraceId
{
    return [NSString stringWithFormat:@"crestxu_%@", [self genTimestamp]];
}
- (NSString *)genOutTradNo
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}
/*
- (NSString *)genPackageWithProductName:(NSString *)productName orderID:(NSString *)orderID
{
    NSDictionary *params =
    @{
      @"bank_type" : @"WX",
      @"body" : productName,
      @"fee_type" : @"1",
      @"input_charset" : @"UTF-8",
      @"notify_url": TGPayNotifyUrl(),
      @"out_trade_no": orderID,
      @"partner" : kWeChatPartnerId,
      @"spbill_create_ip" : @"111.161.79.227",//[CommonUtil getIPAddress:YES],//@"111.161.79.227",//
      @"total_fee" : @"1"};
    NSArray *keys = [params allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    // 生成 packageSign
    NSMutableString *package = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [package appendString:key];
        [package appendString:@"="];
        [package appendString:[params objectForKey:key]];
        [package appendString:@"&"];
    }
    
    [package appendString:@"key="];
    [package appendString:kWeChatAppPartnerKey]; // 注意:不能hardcode在客户端,建议genPackage这个过程都由服务器端完成
    
    // 进行md5摘要前,params内容为原始内容,未经过url encode处理
    NSString *packageSign = [[CommonUtil md5:[package copy]] uppercaseString];
    package = nil;
    
    // 生成 packageParamsString
    NSString *value = nil;
    package = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [package appendString:key];
        [package appendString:@"="];
        value = [params objectForKey:key];
        
        // 对所有键值对中的 value 进行 urlencode 转码
        value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, nil, (CFStringRef)@"!*'&=();:@+$,/?%#[]", kCFStringEncodingUTF8));
        
        [package appendString:value];
        [package appendString:@"&"];
    }
    NSString *packageParamsString = [package substringWithRange:NSMakeRange(0, package.length - 1)];
    
    NSString *result = [NSString stringWithFormat:@"%@&sign=%@", packageParamsString, packageSign];
    
    NSLog(@"--- Package: %@", result);
    
    return result;
}
*/

- (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    NSString *result = [CommonUtil sha1:signString];
    NSLog(@"--- Gen sign: %@", result);
    return result;
}

- (void)payForProductName:(NSString *)productName orderID:(NSString *)orderID obj:(WxPayObj*)obj completion:(void(^)(NSDictionary *order, NSError *error))completion
{
    NSString *tokenURL = [NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%@&secret=%@",
                           obj.AppId, obj.AppSecret];
    __weak __typeof(self) wself = self;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:tokenURL]];
    _req = request;
    [request setCompletionBlock:^{
        __strong __typeof(wself) sself = wself;
        NSDictionary *result = [sself->_req.responseData objectFromJSONData];
        NSError *error = nil;
        if (result) {
            NSString *token = result[@"access_token"];
            [self getPrepayId:token productName:productName orderID:orderID obj:obj completion:completion];
        } else {
            error = [NSError errorWithDomain:@"weixinpay" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"支付错误(-1)"}];
        }
        // if no error occured `getPrePayId` will call the completion block
        if (error) {
            completion(nil, error);
        }
    }];
    [request startAsynchronous];
}

/// 生成预订单
- (NSMutableData *)getProductArgsWithProductName:(NSString *)prodNmae orderID:(NSString *)orderID obj:(WxPayObj *)obj
{
    self.timestamp = [self genTimestamp];
    self.nonceStr = [self genNonceStr]; // traceId 由开发者自定义，可用于订单的查询与跟踪，建议根据支付用户信息生成此id
    self.traceId = [self genTraceId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:obj.AppId forKey:@"appid"];
    [params setObject:obj.SignKey forKey:@"appkey"];
    [params setObject:self.timestamp forKey:@"noncestr"];
    [params setObject:self.timestamp forKey:@"timestamp"];
    [params setObject:self.traceId forKey:@"traceid"];
    
//    [params setObject:[self genPackageWithProductName:prodNmae orderID:orderID] forKey:@"package"];
//    NSString *pkg=[self genPackageWithProductName:prodNmae orderID:orderID];
//    NSLog(@"%@",pkg);
    
    [params setObject:obj.package forKey:@"package"];
    [params setObject:[self genSign:params] forKey:@"app_signature"];
    [params setObject:@"sha1" forKey:@"sign_method"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
    NSLog(@"--- ProductArgs: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    return [NSMutableData dataWithData:jsonData];
}

+ (BOOL)isWeixinInstalled
{
    return [WXApi isWXAppInstalled];
}

- (void)getPrepayId:(NSString *)accessToken productName:(NSString *)productName orderID:(NSString *)orderID  obj:(WxPayObj*)obj completion:(void(^)(NSDictionary *order, NSError *error))completion
{
    NSString *getPrepayIdUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/pay/genprepay?access_token=%@", accessToken];
    
    NSLog(@"--- GetPrepayIdUrl: %@", getPrepayIdUrl);
    
    NSMutableData *postData = [self getProductArgsWithProductName:productName orderID:orderID obj:obj];

    // 文档: 详细的订单数据放在 PostData 中,格式为 json
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:getPrepayIdUrl]];
    [self.request addRequestHeader:@"Content-Type" value:@"application/json"];
    [self.request addRequestHeader:@"Accept" value:@"application/json"];
    [self.request setRequestMethod:@"POST"];
    [self.request setPostBody:postData];
    
    __weak WXPayUtil *wself = self;
    __weak ASIHTTPRequest *weakRequest = self.request;
    
    [self.request setCompletionBlock:^{
        __strong __typeof(wself) sself = wself;
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[weakRequest responseData]
                                                             options:kNilOptions
                                                               error:&error];
        if (error) {
            completion(nil, error);
            return;
        } else {
            NSLog(@"--- %@", [weakRequest responseString]);
        }
        
        NSString *prePayId = dict[PrePayIdKey];
        if (prePayId) {
            NSLog(@"--- PrePayId: %@", prePayId);
            // 调起微信支付
            PayReq *request   = [[PayReq alloc] init];
            request.partnerId = obj.PartnerId;
            request.prepayId  = prePayId;
            request.package   = @"Sign=WXPay";      // 文档为 `Request.package = _package;` , 但如果填写上面生成的 `package` 将不能支付成功
            request.nonceStr  = wself.nonceStr;
            request.timeStamp = [wself.timestamp longLongValue];
            
            // 构造参数列表
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:obj.AppId forKey:@"appid"];
            [params setObject:obj.SignKey forKey:@"appkey"];
            [params setObject:request.nonceStr forKey:@"noncestr"];
            [params setObject:request.package forKey:@"package"];
            [params setObject:request.partnerId forKey:@"partnerid"];
            [params setObject:request.prepayId forKey:@"prepayid"];
            [params setObject:sself.timestamp forKey:@"timestamp"];
            request.sign = [wself genSign:params];
            
            // 在支付之前，如果应用没有注册到微信，应该先调用 [WXApi registerApp:appId] 将应用注册到微信
            BOOL success = [WXApi safeSendReq:request];
            if (success) {
                completion(nil,nil);
            } else {
                completion(nil, [NSError errorWithDomain:@"weixinpay" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"支付失败"}]);
            }
        } else {
            NSError *error = [NSError errorWithDomain:@"weixinpay" code:[dict[errcodeKey] integerValue] userInfo:@{NSLocalizedDescriptionKey:dict[errmsgKey]}];
            completion(nil, error);
        }
    }];
    [self.request setFailedBlock:^{
        completion(nil, wself.request.error);
    }];
    [self.request startAsynchronous];
}

@end
