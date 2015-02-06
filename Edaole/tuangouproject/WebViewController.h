//
//  WebViewController.h
//  tuangouproject
//
//  Created by  na on .
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *url;
- (void)setHTML:(NSString *)html;
@end
