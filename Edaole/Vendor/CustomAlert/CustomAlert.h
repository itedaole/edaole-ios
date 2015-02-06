//
//  UIAlertWindow.h
//  CustomAlertView
//
//  Created by Jinsongzhuang on 1/17/15.
//  Copyright (c) 2015 Ahsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlert : UIWindow
@property (nonatomic, assign) UIView *contentView;

- (void)show;
- (void)hide;

@end
