//
//  UIViewController+ioshack.m
//  tuangouproject
//
//  Created by iBcker on 13-12-24.
//
//

#import "UIViewController+ioshack.h"
#import <objc/runtime.h>

@implementation UIViewController (ioshack)


static const char *__edgesForExtendedLayout__;
- (UIRectEdge)edgesForExtendedLayout
{
    //适配银联
    if ([NSStringFromClass([self class]) rangeOfString:@"UMSPay_QMJF_"].location!=NSNotFound) {
        return UIRectEdgeAll;
    }

    id v=objc_getAssociatedObject(self,&__edgesForExtendedLayout__);
    if (v!=nil) {
        return [v integerValue];
    }else{
        return UIRectEdgeNone;
    }
}

- (void)setEdgesForExtendedLayout:(UIRectEdge)rect
{
    objc_setAssociatedObject(self, &__edgesForExtendedLayout__, @(rect), OBJC_ASSOCIATION_COPY);
}
@end

