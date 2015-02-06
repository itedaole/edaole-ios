//
//  LoginViewController.m
//  tuangouproject
//
//  Created by liu song on 13-3-5.
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import "LoginViewController.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "RegisterController.h"
//#import "ZXingWidgetController.h"
#import "SNSLoginViewController.h"
//#import "QRCodeReader.h"
#import "NSString+MKNetworkKitAdditions.h"
#import "Theme.h"
#import "NSHTTPCookieStorage+saveCookies.h"

#import <ShareSDK/ShareSDK.h>


@interface LoginViewController () < ASIHTTPRequestDelegate, SNSLoginViewControllerDelegate>
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.showSNSLogin = YES;
        self.loginAction = @"User/login";
    }
    return self;
}

- (void)dealloc
{
    [self.loginReq cancel];
    self.loginReq.delegate=nil;
    self.loginReq=nil;
}

- (void)isNormalUser:(BOOL)b
{
    if (!b) {
        self.registerButton.hidden=YES;
        self.loginButton.left=(self.view.width-self.loginButton.width)/2;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.qqButton.hidden = !self.showSNSLogin;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeTop];
    }
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    // 注册微信一键登录的广播通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeiXinCodeFinishedWithResp:) name:@"weixin" object:nil];

#ifdef kOptionHidenQlogin
    if([kOptionHidenQlogin isEqualToString:@"1"]){
        self.qqButton.hidden=YES;
    }
#endif
    
#ifdef DEBUG
    self.usernameField.text = @"aaa";
    self.passwordField.text = @"123";
#endif

    self.bar.tintColor = [UIColor barTintColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.bar.height = 64;
        for (UIView *v in self.view.subviews) {
            if (v == self.bar) continue;
            v.top += 20;
        }
    }
    
    UIColor *textColor = [UIColor whiteColor];
    [self.loginButton setBackground:@"bar_button" highlight:@"bar_button_hilight"];
    [self.loginButton setTitleColor:textColor forState:UIControlStateNormal];
    [self.registerButton setTitleColor:textColor forState:UIControlStateNormal];
    [self.registerButton setBackground:@"bar_button" highlight:@"bar_button_hilight"];
    [self.shopButton setBackground:@"RepairButton" highlight:nil];
    [self.shopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=nil;
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//    [cancelButton setBackground:@"bar_button" highlight:@"bar_button_hilight"];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    self.bar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    ////////////////////////////
    // 屏蔽功能
    self.qqButton.hidden = YES;
    self.wxButton.hidden = YES;
}

- (void)onCancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onShopButton:(id)sender
{
//    ZXingWidgetController *widController = [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];
//    
//    NSMutableSet *readers = [[NSMutableSet alloc ] init];
//    
//    QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
//    [readers addObject:qrcodeReader];
//    widController.readers = readers;
//    
//    [self presentModalViewController:widController animated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    self.loginReq = nil;
    [SVProgressHUD showErrorWithStatus:@"网络错误"];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.loginReq = nil;
    [SVProgressHUD dismiss];
    // Use when fetching text data
    NSDictionary *rootDic = [request.responseData objectFromJSONData];
    //[[CJSONDeserializer deserializer] deserialize:[resString dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    
    NSDictionary *resultDictionary = [rootDic objectForKey:@"result"];
    
    NSInteger statusCode = [[rootDic objectForKey:@"status"] integerValue];
    if(statusCode == 0) {
        [SESSION setDidLogin:NO];
        [SESSION setMobile:nil];
        [SESSION setMoney:nil];
        [SESSION setUsername:nil];
        [SESSION setRequireMobile:nil];
        [SESSION setUser_id:nil];
        //[SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",[rootDic objectForKey:@"message"]]];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] synchronizeCookies];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码错误" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil,nil];
        alert.delegate = self;
        [alert show];
    } else if(statusCode == 1) {
        [SESSION setDidLogin:YES];
        [SESSION setUsername:[resultDictionary valueForKeyPath:@"username"]];
        [SESSION setMobile:[resultDictionary valueForKeyPath:@"mobile"]];
        [SESSION setMoney:[resultDictionary valueForKeyPath:@"money"]];
        [SESSION setUser_id:[resultDictionary valueForKey:@"id"]];
        [SESSION setRequireMobile:[resultDictionary valueForKeyPath:@"_config.requireMobile"]];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] synchronizeCookies];
        
        [self dismissModalViewControllerAnimated:YES];
        
        if ([self.delegate respondsToSelector:@selector(loginViewController:finishedWithObject:success:)]) {
            [self.delegate loginViewController:self finishedWithObject:rootDic success:YES];
        }
    }
}



//用户登陆
-(IBAction)userlogin
{
    if([self.usernameField.text isEqualToString:@""])
    {
        UIAlertView *uialert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        uialert.delegate = self;
        [uialert show];
        
        return;
    }
    
    NSString *loginURL = TGURL(@"User/login", @{@"name":self.usernameField.text,
                             @"pwd": self.passwordField.text});

    [SVProgressHUD showWithStatus:@"登录中..."];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:loginURL]];
    [request setDelegate:self];
    [request startAsynchronous];
}
// 微信登录
- (IBAction)wechatLoginButtonOnclick:(id)sender
{
    if (![WXApi isWXAppInstalled]) {
        [SVProgressHUD showErrorWithStatus:@"您尚未安装微信客户端"];
        return;
    }
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"123" ;
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
}

- (void)getWeiXinCodeFinishedWithResp:(NSNotification *)notification
{
    
    BaseResp *resp = [notification object];
    
    if (resp.errCode == 0)
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        NSLog(@"%@",aresp.code);
        
        NSString *loginURL = [NSString stringWithFormat:@"http://www.edaole.com/thirdpart/wechat/app_callback.php?code=%@",aresp.code];
        
        [SVProgressHUD showWithStatus:@"登录中..."];
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:loginURL]];
        [request setDelegate:self];
        [request startAsynchronous];

     }else if (resp.errCode == -4){
         [SVProgressHUD showErrorWithStatus:@"您已经拒绝了"];
     }else if (resp.errCode == -2){
         [SVProgressHUD showErrorWithStatus:@"您已经取消登录了"];
     }
}

-(IBAction)theregister:(id)sender{
    
    RegisterController *reg = [[RegisterController alloc] initWithNibName:@"RegisterController" bundle:nil];
    reg.registerCompletion = ^(BOOL succeed){
        if (succeed) {
            [self dismissModalViewControllerAnimated:YES];
        }
    };
    [self presentModalViewController:reg animated:YES];
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];

//    [self.view  removeGestureRecognizer:oneFingerTwoTaps];
}

- (IBAction)dismiss:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setShopButton:nil];
    [super viewDidUnload];
}

- (void)setTitle:(NSString*)title
{
    self.bar.topItem.title=title;
}

//#pragma mark - ZXingDelegate
//- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result;
//{
//    [[[UIAlertView alloc] initWithTitle:nil
//                               message:result delegate:nil
//                     cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
//}
//
//- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
//{
//    [self dismissModalViewControllerAnimated:YES];
//}

//- (IBAction)onThirdLogin:(UIButton *)sender
//{
//    SNSLoginViewController *controller = nil;
//    switch (sender.tag) {
//        case kSinaTag:
//            controller = [SNSLoginViewController weiboLoginViewController];
//            break;
//        case kQQTag:
//            controller = [SNSLoginViewController qqLoginViewController];
//            break;
//    }
//    controller.delegate = self;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
//    nav.navigationBar.tintColor = [UIColor colorWithRed:240/255.0 green:40/255.0 blue:90/255.0 alpha:1.0];
//    [self presentModalViewController:nav animated:YES];
//}
//
//- (void)snsLoginViewControllerFinished:(SNSLoginViewController *)controller
//{
//    [self dismissModalViewControllerAnimated:NO];
//    [SVProgressHUD show];
//    
//    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:TGURL(@"User/login", nil)]];
//    
//    
//    [request setDelegate:self];
//    self.loginReq = request;
//    [request startAsynchronous];
//    
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    } else {
        [self userlogin];
    }
    return YES;
}


@end
