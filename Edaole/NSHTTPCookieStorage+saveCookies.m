//
//  NSHTTPCookieStorage+saveCookies.m
//  tuangouproject
//
//  Created by iBcker on 14-5-18.
//
//

#import "NSHTTPCookieStorage+saveCookies.h"
#import <objc/message.h>

@implementation NSHTTPCookieStorage (saveCookies)
- (void)synchronizeCookies
{
    SEL saveCookies = NSSelectorFromString(@"_saveCookies");
    if ([[NSHTTPCookieStorage sharedHTTPCookieStorage] respondsToSelector:saveCookies]) {
        objc_msgSend([NSHTTPCookieStorage sharedHTTPCookieStorage], saveCookies);
    }
}

@end
