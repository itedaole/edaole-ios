//
//  LoginViewController.h
//  tuangouproject
//
//  Created by liu song on 13-3-5.
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "TextField.h"
#import "ASIHTTPRequest.h"

#define kSinaTag 10
#define kQQTag   11

@protocol LoginViewControllerDelegate;

@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    UITapGestureRecognizer* oneFingerTwoTaps;
}
@property (unsafe_unretained, nonatomic) id <LoginViewControllerDelegate>delegate;
@property (nonatomic, strong) IBOutlet UINavigationBar *bar;
@property (nonatomic, strong) IBOutlet UIButton *qqButton;

@property (weak, nonatomic) IBOutlet UIButton *wxButton;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *registerButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *shopButton;
@property (nonatomic) BOOL showSNSLogin;
@property (strong, nonatomic) NSString *loginAction;
@property (strong, nonatomic) ASIHTTPRequest *loginReq;
- (IBAction)onThirdLogin:(id)sender;

- (void)isNormalUser:(BOOL)b;
- (void)setTitle:(NSString*)title;

// 微信登录成功调用的方法 ，具体查看AppDelegate
- (void)getWeiXinCodeFinishedWithResp:(BaseResp *)resp;

@end


@protocol LoginViewControllerDelegate <NSObject>
@optional
- (void)loginViewController:(LoginViewController *)controller finishedWithObject:(id)obj success:(BOOL)success;
@end
