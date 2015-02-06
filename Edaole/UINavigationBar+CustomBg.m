//
//  UINavigationBar+CustomBg.m
//  tuangouproject
//
//  Created by  na on .
//
//

#import "UINavigationBar+CustomBg.h"

@implementation UINavigationBar (CustomBg)
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [[UIImage imageNamed:@"titlebar_bk"] drawInRect:self.bounds];
}

- (UIColor *)tintColor
{
    return [UIColor colorWithRed:240/255.0 green:40/255.0 blue:90/255.0 alpha:1.0];
}

@end
