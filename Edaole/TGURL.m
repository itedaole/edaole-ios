//
//  URL.m
//  tuangouproject
//
//  Created by  na on .
//
//

#import "TGURL.h"
#import "NSDictionary+RequestEncoding.h"
#import "NSString+Platform.h"

#define ZTPLATFORM @"IOS"

NSString *TGURLByPath(NSString *path)
{
    return [NSString stringWithFormat:@"%@://%@/%@", kProtocol, kHost, path];
}

NSString *TGURL(NSString *action, NSDictionary *param)
{
    UIDevice *d=[UIDevice currentDevice];
    NSMutableDictionary *pars=[NSMutableDictionary dictionaryWithDictionary:param];
    if (![kAppForPlat isEqualToString:@"fw"]) {
        pars[@"SYSVersion"]=[d systemVersion];
        pars[@"SYSName"]= @"iPhone";//[NSString platformString];
        pars[@"SYSPlat"]=ZTPLATFORM;
        
        NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
        pars[@"SYSBuilVersion"]=[infoDict objectForKey:@"CFBundleVersion"];
        pars[@"SYSAppVersion"]=[infoDict objectForKey:@"CFBundleShortVersionString"];
    }
    static NSString *dir = nil;
    if (!dir) {
        if ([kAppForPlat isEqualToString:@"fw"]) {
            dir =@"ztapp";
        }else/* if([kAppForPlat isEqualToString:@"fw"])*/{
            dir =@"app";
        }
    }
    
    NSString *result = nil;
    if (pars.count == 0) {
        result = [NSString stringWithFormat:@"%@://%@/%@/api.php?s=%@", kProtocol, kHost, dir , action];
    } else {
        NSString *paramStr = [pars urlEncodedKeyValueString];
        result = [NSString stringWithFormat:@"%@://%@/%@/api.php?s=%@&%@", kProtocol ,kHost,dir, action, paramStr];
    }
    NSLog(@"url:%@",result);
    return result;
}

NSString *TGPayNotifyUrl(void){
    return [NSString stringWithFormat:@"http://%@/app/api.php",kHost];
}

