//
//  UIAlertWindow.m
//  CustomAlertView
//
//  Created by Jinsongzhuang on 1/17/15.
//  Copyright (c) 2015 Ahsun. All rights reserved.
//

#import "CustomAlert.h"

#define m_width [UIScreen mainScreen].bounds.size.width
#define m_height [UIScreen mainScreen].bounds.size.height

@implementation CustomAlert
{
    UIViewController *contentViewController;
    UIWindow *orginalKeyWindow;
}

-(id)init
{
    CGRect frame = [UIScreen mainScreen].bounds;
    
    self = [super initWithFrame:frame];
    if (self) {
        contentViewController = [[UIViewController alloc] init];
        self.rootViewController = contentViewController;
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1f];
        contentViewController.view.backgroundColor = [UIColor clearColor];
        
        orginalKeyWindow = [UIApplication sharedApplication].keyWindow;
    }
    return self;
}

- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    
    float x = (m_width - contentView.frame.size.width)/2;
    float y = (m_height - contentView.frame.size.height)/2;
    
    _contentView.frame = CGRectMake(x, y, contentView.frame.size.width, contentView.frame.size.height);
    _contentView.layer.cornerRadius = 5.0f;
    _contentView.layer.shadowOffset = CGSizeMake(5, 5);
    _contentView.layer.shadowColor = [[UIColor lightTextColor] CGColor];
    _contentView.clipsToBounds = YES;
    [contentViewController.view addSubview:_contentView];
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self hide];
//}


- (void)showAnimation:(id)sender
{
    
    [UIView animateWithDuration:0.2 animations:
     ^(void){
         self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0f, 1.0f);
         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
     }
                     completion:^(BOOL finished){
                         [self bounceInAnimationStoped];
                     }];
}
- (void)bounceOutAnimationStoped
{
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8, 0.8);
//         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
     }
                     completion:^(BOOL finished){
                         [self bounceInAnimationStoped];
                     }];
}
- (void)bounceInAnimationStoped
{
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1, 1);
//         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
     }
                     completion:^(BOOL finished){
                         [self animationStoped];
                     }];
}
- (void)animationStoped
{
   self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
}

- (void)show
{
    [self makeKeyAndVisible];
    [self showAnimation:nil];
}

- (void)hide
{
    self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8, 0.8);
    
    self.hidden = YES;
    [orginalKeyWindow makeKeyAndVisible];
}



@end
