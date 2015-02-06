//
//  SNSLoginViewController.m
//  tuangouproject
//
//  Created by  na on .
//
//

#import "SNSLoginViewController.h"

static NSString * const kQQLoginPathFW = @"/Index/QQLogin";
static NSString * const kQQLoginPathZT = @"/thirdpart/qzone/index.php";
static NSString * const kQQLoginCallbackZT = @"/index.php";
static NSString * const kQQLoginCallbackFW = @"/Index/qqcallBack&code=";
static NSString * const kQQLoginSuccessURLFW = @"/Index/result&status=";
static NSString * const kQQLoginSuccessURLZT = @"/index.php";

@interface SNSLoginViewController ()

@end

@implementation SNSLoginViewController
+ (id)weiboLoginViewController
{
    SNSLoginViewController *c = [[SNSLoginViewController alloc] initWithNibName:nil bundle:nil];
    c.url = TGURLByPath(@"/thirdpart/sina/login.php");
    c.type = SNSLoginTypeWeibo;
    return c;
}

+ (id)qqLoginViewController
{
    SNSLoginViewController *c = [[SNSLoginViewController alloc] initWithNibName:nil bundle:nil];
    if ([kAppForPlat isEqualToString:@"fw"]) {
        c.url = TGURLByPath(kQQLoginPathFW);
    } else {
        c.url = TGURLByPath(kQQLoginPathZT);
    }
    c.type = SNSLoginTypeQQ;
    return c;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    if ([self.navigationItem.leftBarButtonItem respondsToSelector:@selector(setTintColor:)]) {
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    }
}

- (void)goBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"url: %@", request.URL);
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    NSString *prefix = nil, *append = nil;
    if (self.type == SNSLoginTypeWeibo) {
        prefix =  @"http://api.t.sina.com.cn/oauth/authorize";
        append = @"&display=mobile";
        
        NSString *urlstr = [request.URL absoluteString];
        if ([urlstr hasPrefix:prefix] && [urlstr rangeOfString:append].location!=NSNotFound) {
            NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", request.URL, append]];
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
            return NO;
        }
    }
    NSString *callbackString;
    if ([kAppForPlat isEqualToString:@"fw"]) {
        callbackString = kQQLoginCallbackFW;
    } else {
        callbackString = kQQLoginCallbackZT;
    }
    
    if ([request.URL.absoluteString rangeOfString:callbackString].location != NSNotFound) {
        if (![request.URL.absoluteString isEqualToString:self.url]) {
            self.title = @"登录成功";
            self.webView.userInteractionEnabled = NO;
        }
    } else if (![kAppForPlat isEqualToString:@"fw"] && [request.URL.absoluteString rangeOfString:kQQLoginCallbackZT].location != NSNotFound) {
        [self.delegate snsLoginViewControllerFinished:self];
        return NO;
    }
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    if ([kAppForPlat isEqualToString:@"fw"]) {
        if ([webView.request.URL.absoluteString rangeOfString:kQQLoginSuccessURLFW].location != NSNotFound) {
            [self.delegate snsLoginViewControllerFinished:self];
        }
    } else {
        if ([webView.request.URL.absoluteString hasSuffix:kQQLoginSuccessURLZT]) {
            [self.delegate snsLoginViewControllerFinished:self];
        }
    }
    self.webView.userInteractionEnabled = YES;
}
@end
