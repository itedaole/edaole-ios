//
//  WebViewController.m
//  tuangouproject
//
//  Created by  na on .
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import "WebViewController.h"
#import "SVProgressHUD.h"

@interface WebViewController ()

@end

@implementation WebViewController

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
	self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    UIButton *cancle=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    cancle.titleLabel.font = [UIFont boldSystemFontOfSize:15];
                                
    [cancle setBackgroundImage:[[UIImage imageNamed:@"btn_back_normal"] stretchableImageWithLeftCapWidth:3 topCapHeight:10] forState:UIControlStateNormal];
    [cancle setBackgroundImage:[[UIImage imageNamed:@"btn_back_hilight.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:10] forState:UIControlStateHighlighted];
    [cancle setTitle:@"返回" forState:UIControlStateNormal];
    [cancle setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];

    [cancle addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancle];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHTML:(NSString *)html
{
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString: @"http://" kHost]];
}
- (void)setUrl:(NSString *)url
{
    _url = url;
    if (self.isViewLoaded) {
        NSLog(@"loading: %@", url);
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   self.title = @"加载中...";
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.title = @"加载失败";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)goBack
{
    if (self.navigationController.modalViewController) {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
