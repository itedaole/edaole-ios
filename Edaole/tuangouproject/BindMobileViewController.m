//
//  BindMobileViewController.m
//  tuangouproject
//
//  Created by  na on .
//
//

#import "BindMobileViewController.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import "LoginViewController.h"

@interface BindMobileViewController () <ASIHTTPRequestDelegate>
@property (unsafe_unretained, nonatomic) ASIHTTPRequest *req;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) UIButton *bindButton;
@property (nonatomic) BOOL sent;
@end

@implementation BindMobileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self.req cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"绑定手机号码";
    UIButton *bn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [bn setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
    [bn setBackgroundImage:[UIImage imageNamed:@"btn_back_hilight.png"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:bn];
    [bn setTitle:@"返回" forState:UIControlStateNormal];
    bn.titleLabel.font=[UIFont systemFontOfSize:15];
    [bn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [bn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    
    bn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [bn setBackground:@"bar_button" highlight:@"bar_button_click"];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:bn];
    [bn setTitle:@"绑定" forState:UIControlStateNormal];
    self.bindButton = bn;
    bn.titleLabel.font=[UIFont systemFontOfSize:15];
    [bn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [bn addTarget:self action:@selector(onBind) forControlEvents:UIControlEventTouchUpInside];
    if (self.inputOnly) {
        self.title = @"请输入验证码";
        [self.bindButton setTitle:@"确认" forState:UIControlStateNormal];
    }
}

- (void)onBack
{
    if (self.presentingViewController) {
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onBind
{
    if (self.inputOnly) {
        if (self.textField.text.length > 1) {
            [self.delegate bindController:self enterCode:self.textField.text];
        }
        return;
    }
    if (self.req) return;
    
    if (self.sent) {
        if (![self.textField hasText]) return;
        NSString *url = TGURL(@"User/mobileVerify", @{@"vcode": self.textField.text,
                            @"mobile": self.mobile
                            });
        [SVProgressHUD showWithStatus:@"验证中..."];
        ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        req.delegate = self;
        self.req = req;
        [req startAsynchronous];

    } else {
        if (![self.textField hasText] || self.textField.text.length != 11) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
            return;
        }
        NSString *url = TGURL(@"User/mobileVerify", @{@"mobile":self.textField.text});
        self.mobile = self.textField.text;
        [SVProgressHUD showWithStatus:@"发送中..."];
        ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        req.delegate = self;
        self.req = req;        
        [req startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.req = nil;
    NSDictionary *resp = [[request responseData] objectFromJSONData];
    int code = [[resp valueForKey:@"status"] intValue];
    
    if (code == 0) {
        NSString * info = @"失败";
        if ([resp valueForKey:@"error"])  {info = [resp valueForKey:@"error"];}
        [SVProgressHUD showErrorWithStatus:info];
    } else if (code == 1) {
        if (self.sent) {
            [SVProgressHUD showSuccessWithStatus:@"验证成功"];
            [SESSION setMobile:self.mobile];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.1];
            
        } else {
            [SVProgressHUD showSuccessWithStatus:@"请查收验证短信"];
            self.sent = YES;
            self.title = @"请输入验证码";
            self.textField.text = nil;
            CATransition *a = [CATransition animation];
            a.type = kCATransitionFade;
            [self.navigationController.navigationBar.layer addAnimation:a forKey:nil];
            [self.bindButton setTitle:@"确认" forState:UIControlStateNormal];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"请登录"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    self.req = nil;
    [SVProgressHUD showErrorWithStatus:@"发送失败"];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextField:nil];
    [super viewDidUnload];
}
@end
