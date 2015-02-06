//
//  UIBarButtonItem+Factory.m
//  tuangouproject
//
//  Created by cui on 13-6-1.
//
//

#import "UIBarButtonItem+Factory.h"

@implementation UIBarButtonItem (Factory)
+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *bn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [bn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [bn setBackground:@"bar_button" highlight:@"bar_button_hilight"];
    bn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [bn setTitle:title forState:UIControlStateNormal];
    [bn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [bn sizeToFit];
    bn.width += 20;
    bn.height = 30;
    return [[UIBarButtonItem alloc] initWithCustomView:bn];
}

+ (instancetype)backItemWithTarget:(id)target action:(SEL)action
{
    UIButton *bn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [bn setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [bn setBackgroundImage:[UIImage imageNamed:@"btn_back_hilight.png"] forState:UIControlStateHighlighted];
    [bn setTitle:@"返回" forState:UIControlStateNormal];
    bn.titleLabel.font=[UIFont systemFontOfSize:15];
    [bn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [bn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:bn];
}

@end
