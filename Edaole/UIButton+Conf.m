//
//  UIButton+Conf.m
//  tuangouproject
//
//  Created by  na on .
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import "UIButton+Conf.h"

@implementation UIButton (Conf)
- (void)setBackground:(NSString *)img highlightSuffix:(NSString *)suffix
{
    [self setBackground:img highlight:[img stringByAppendingString:suffix]];
}

- (void)setBackground:(NSString *)img highlight:(NSString *)highlight
{
    UIImage *image = [UIImage imageNamed:img];
    CGFloat leftCap = ceilf(image.size.width / 2);
    CGFloat topCap = ceilf(image.size.height / 2);
    
    [self setBackgroundImage:[[UIImage imageNamed:img] stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap] forState:UIControlStateNormal];
    [self setBackgroundImage:[[UIImage imageNamed:highlight] stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap] forState:UIControlStateHighlighted];
}
@end
