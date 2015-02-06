//
//  URL.h
//  tuangouproject
//
//  Created by  na on .
//
//

#import <Foundation/Foundation.h>

//#define kHost @"zuitutuan.sinaapp.com"

#define kWebSite [kProtocol stringByAppendingFormat:@"://%@",kHost]


#define ImageURL(__x__) ([__x__  length] ? [NSString stringWithFormat:kProtocol @"://" kHost @"/static/%@", __x__] : nil)
//#define ImageURL(__x__) [NSString stringWithFormat:@"http://zuitutuan-zuitu.stor.sinaapp.com/static/%@", __x__]

#ifdef __cplusplus
extern "C" {
#endif
    extern NSString *TGURLByPath(NSString *path);
    extern NSString *TGURL(NSString *action, NSDictionary *param);
    extern NSString *TGPayNotifyUrl(void);
#ifdef __cplusplus
}
#endif