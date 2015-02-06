//
//  RegisterController.m
//  tuangouproject
//
//  Created by liu song on 13-3-7.
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import "RegisterController.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"
#import "NSDictionary+RequestEncoding.h"
#import "BindMobileViewController.h"
#import "UIAlertView+Blocks.h"

@interface RegisterController () <ASIHTTPRequestDelegate, BindMobileViewControllerDelegate>
@property (unsafe_unretained, nonatomic) ASIHTTPRequest *req;
@property (nonatomic) BOOL sendingCode;
@end

@implementation RegisterController

@synthesize telname,telname1,telname2,telname3;
@synthesize telname4;

@synthesize bar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)onCancle
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    if (request.tag == 101) {
//        [self doRegisterWithCode:@"123456"];
//        return;
//    }
//    
    if (request.tag == 102) {
        
        [SVProgressHUD dismiss];
        
        NSDictionary *rootDic = [request.responseData objectFromJSONData];
        int ret = [[rootDic objectForKey:@"status"] intValue];
        
        if(ret == 1)
        {
//            [self dismissModalViewControllerAnimated:NO];
            UIAlertView *uialert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功！请登录!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            uialert.delegate = self;
            
            [uialert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (self.registerCompletion) {
                    self.registerCompletion(YES);
                }
            }];
        }
        else if([[NSString stringWithFormat:@"%@", [rootDic objectForKey:@"status"]]  isEqualToString: @"0" ])
        {
            UIAlertView *uialert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:[rootDic valueForKeyPath:@"error.info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            uialert.delegate = self;
            [uialert show];
            
        }
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"网络错误"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    bar.tintColor = [UIColor barTintColor];
    NSLog(@"%@", self.confirmButton);
    [self.confirmButton setBackground:@"bar_button" highlight:@"bar_button_hilight"];
    UIButton *cancle=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    cancle.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cancle setBackground:@"bar_button" highlight:@"bar_button_hilight"];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(onCancle) forControlEvents:UIControlEventTouchUpInside];
    self.bar.topItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:cancle];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        bar.height = 64;
        for (UIView *v in self.view.subviews) {
            if (v == bar) continue;
            v.top += 20;
        }
    }
}

//- (void)bindController:(BindMobileViewController *)c enterCode:(NSString *)code
//{
//    self.sendingCode = NO;
//    //    [self dismissModalViewControllerAnimated:YES];
//    
//}

//用户注册
-(IBAction)userregister:(id)sender
{
    if([telname.text isEqualToString:@""])
    {
        UIAlertView *uialert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        uialert.delegate = self;
        [uialert show];
        
        return;
    }
    if([telname1.text isEqualToString:@""])
    {
        UIAlertView *uialert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        uialert.delegate = self;
        [uialert show];
        
        return;
    }
    if([telname3.text isEqualToString:@""])
    {
        UIAlertView *uialert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"电话不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        uialert.delegate = self;
        [uialert show];
        return;
    }
    if([telname4.text isEqualToString:@""])
    {
        UIAlertView *uialert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        uialert.delegate = self;
        [uialert show];
        
        return;
    }
    if([telname4.text rangeOfString:@"@"].location==NSNotFound)
    {
        UIAlertView *uialert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱不合法！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        uialert.delegate = self;
        [uialert show];
        
        return;
    }
    
    if(![telname1.text isEqualToString:telname2.text])
    {
        UIAlertView *uialert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入的密码不一致，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        uialert.delegate = self;
        [uialert show];
        
        return;
    }
    
    
    [SVProgressHUD showWithStatus:@"注册中..."];
    //[self doSendRequestCode];
    
    [self doRegisterWithCode:@"123456"];
}

#pragma mark -发起注册请求
- (void)doRegisterWithCode:(NSString *)code
{
    NSDictionary *params = @{@"name": telname.text,
                             @"pwd":telname1.text,
                             @"email":telname4.text,
                             @"vcode":code,
                             @"mobile":telname3.text};
    NSString *postURL = TGURL(@"User/register", params);
    
     NSLog(@"提交注册：=%@",postURL);
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:postURL]];
    [request setDelegate:self];
    request.tag = 102;
    [request startAsynchronous];
}

#pragma mark -发送验证码（发送任意验证码）
- (void)doSendRequestCode
{
    NSString *url = TGURL(@"User/mobileVerify", @{@"mobile":telname3.text});
    [SVProgressHUD showWithStatus:@"发送中..."];
    
    NSLog(@"获取验证码：=%@",url);
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    req.delegate = self;
    req.tag = 101;
    [req startAsynchronous];
}

- (IBAction)touchintextfield
{
    
    /*******手势*********/
    oneFingerTwoTaps =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchouttextfield)];
    
    // Set required taps and number of touches
    
    [oneFingerTwoTaps setNumberOfTapsRequired:1];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    
    // Add the gesture to the view
    [self.view addGestureRecognizer:oneFingerTwoTaps];
    /******************/
}

- (IBAction)touchouttextfield
{
    [self.telname3 resignFirstResponder];
    [self.telname resignFirstResponder];
    [self.telname1 resignFirstResponder];
    [self.telname2 resignFirstResponder];
    [self.telname4 resignFirstResponder];
    
    
    [self.view  removeGestureRecognizer:oneFingerTwoTaps];
}

-(IBAction)goback:(id)sender
{
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onHideKeyboard:(id)sender
{
    for (UITextField *field in self.view.subviews) {
        if ([field isKindOfClass:[UITextField class]] && [field isFirstResponder]) {
            [field resignFirstResponder];
            break;
        }
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload {
    [self setConfirmButton:nil];
    [super viewDidUnload];
}
@end
