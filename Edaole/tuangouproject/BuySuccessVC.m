//
//  BuySuccessVC.m
//  tuangouproject
//
//  Created by Jinsongzhuang on 1/17/15.
//
//

#import "BuySuccessVC.h"
#import "SVProgressHUD.h"
#import "ASIHTTPRequest.h"

#import "WeiChatShareView.h"
#import "CustomAlert.h"
#import "UIImageView+WebCache.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"

@interface BuySuccessVC ()

@end

@implementation BuySuccessVC
{
    __weak IBOutlet UIScrollView *_mainScrollView;
    __weak IBOutlet UIView *_contentView;
    
    
    __weak IBOutlet UILabel *_title_cn_Label;
    __weak IBOutlet UILabel *_title_local_Label;
    __weak IBOutlet UILabel *_goodCodeLable;
    
    __weak IBOutlet UILabel *_shopName;
    __weak IBOutlet UILabel *_shopAddress;
    __weak IBOutlet UILabel *_opningHoursLabel;
    __weak IBOutlet UILabel *_telephoneLabel;
    
    CustomAlert *alert;
    WeiChatShareView *shareView;
    
    NSString *_share_url;
    NSString *_shareImagePath;
    
}

#pragma mark -导航栏方法
- (void)configureNavBar
{
    UIButton *bn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:bn];
    [bn setTitle:@"返回" forState:UIControlStateNormal];
    bn.titleLabel.font=[UIFont systemFontOfSize:15];
    [bn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [bn addTarget:self action:@selector(navigationBarBackbuttonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *bn2=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:bn2];
    [bn2 setImage:[UIImage imageNamed:@"action"] forState:UIControlStateNormal];
    bn2.titleLabel.font=[UIFont systemFontOfSize:15];
    [bn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [bn2 addTarget:self action:@selector(navigationBarShareButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.title = @"优惠券";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化导航栏
    [self configureNavBar];
    
    _contentView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _contentView.layer.borderWidth = 2.0f;
    _contentView.layer.shadowOffset = CGSizeMake(2, 2);
    _contentView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    
    _mainScrollView.contentSize = CGSizeMake(320, 568);
    
    
    // 初始化contentView
    alert = [[CustomAlert alloc] init];
    shareView = [[NSBundle mainBundle] loadNibNamed:@"WeiChatShareView" owner:nil options:nil][0];
    alert.contentView = shareView;
    
    [shareView.closeButton addTarget:self action:@selector(closeButtonOnclick) forControlEvents:UIControlEventTouchUpInside];
    
    [shareView.shareButton addTarget:self action:@selector(shareButtonOnclick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 重置商品信息
    [self resetItemsInfo];
    
    // 发起请求
    [self startRequest];
}

- (void)closeButtonOnclick
{
    [alert hide];
}

- (void)shareButtonOnclick
{
    if (![WXApi isWXAppInstalled]) {
        [SVProgressHUD showErrorWithStatus:@"您尚未安装微信客户端"];
        return;
    }
    
    [self shareContentToWeChat];
}

- (void)startRequest
{
    NSString *loginURL = TGURL(@"Tuan/detail_new", @{@"id":self.groupId,
                                                   @"user_id": [SESSION user_id]});
    
    [SVProgressHUD showWithStatus:@"获取中..." ];
    
    NSLog(@"购买URL ======= %@",loginURL);
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:loginURL]];
    [request setDelegate:self];
    [request startAsynchronous];

}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSDictionary *rootDic = [request.responseData objectFromJSONData];
    
    [self setItemsInfoWithDictionary:[rootDic objectForKey:@"result"]];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"获取失败"];
    
    // 重置信息（清除获取信息）
    [self resetItemsInfo];
}

- (void)setItemsInfoWithDictionary:(NSDictionary *)dic
{
    if (!dic) {
        [self resetItemsInfo];
        return;
    }
    
    NSString *title = [dic objectForKey:@"title"];
    if (title.length > 0 && title) {
        _title_cn_Label.text = [dic objectForKey:@"title"];
        shareView.subtitleLable.text = title;
    }
    
    NSString *title_local = [dic objectForKey:@"title_local"];
    if (title_local.length > 0 && title_local) {
        _title_local_Label.text = [dic objectForKey:@"title_local"];
    }
    
    NSString *couponcode = [dic objectForKey:@"couponcode"];
    if (couponcode.length > 0 && couponcode) {
        _goodCodeLable.text = [dic objectForKey:@"couponcode"];
    }
    
     NSString *yy_time = [dic objectForKey:@"yy_time"];
    if (yy_time.length > 0 && yy_time) {
        _opningHoursLabel.text = [dic objectForKey:@"yy_time"];
    }
    
    NSString *shopName = [dic objectForKey:@"shop_name"];
    if (shopName.length > 0 && shopName) {
        _shopName.text = [dic objectForKey:@"shop_name"];
    }
    
    NSString *shopAddress = [dic objectForKey:@"address"];
    if (shopAddress.length > 0 && shopAddress) {
        _shopAddress.text = [dic objectForKey:@"address"];
    }
    
    NSString *phone = [dic objectForKey:@"phone"];
    if (phone.length > 0 && phone) {
        _telephoneLabel.text = [dic objectForKey:@"phone"];
    }
    
    NSString *large_image = [dic objectForKey:@"large_image"];
    if (large_image.length > 0 && large_image) {
        
        _shareImagePath = [NSString stringWithFormat:@"http://www.edaole.com%@",large_image];
        [shareView.productImageView sd_setImageWithURL:[NSURL URLWithString:_shareImagePath]];
    }
    
    NSString *share_summary = [dic objectForKey:@"share_summary"];
    if (share_summary.length > 0 && share_summary) {
        
        shareView.productNotesTextView.text = share_summary;
    }
    
    NSString *share_url = [dic objectForKey:@"share_url"];
    if (share_url.length > 0 && share_url) {
        _share_url = share_url;
    }
    
    if (!_isHidenAutomaticShare)
    {
        [self navigationBarShareButtonOnclick:nil];
    }
}

#pragma mark -重置显示信息
- (void)resetItemsInfo
{
    _title_cn_Label.text = nil;
    _title_local_Label.text = nil;
    _goodCodeLable.text = nil;
    
    _shopName.text = nil;
    _shopAddress.text = nil;
    _opningHoursLabel.text = nil;
    _telephoneLabel.text = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationBarShareButtonOnclick:(id)sender
{
    [alert show];
}

-  (void)navigationBarBackbuttonOnclick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)shareContentToWeChat
{
    NSString *content = @"我刚刚免费拿到了一道乐 (www.edaole.com) 去欧洲购物美食的优惠券，真的很便宜啊，快来一起去欧洲血拼吧！";
    
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:content
                                                image:[ShareSDK imageWithUrl:_shareImagePath]
                                                title:shareView.subtitleLable.text
                                                  url:_share_url
                                          description:content
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK clientShareContent:publishContent
                            type:ShareTypeWeixiTimeline //平台类型
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件
                              
                              if (state == SSPublishContentStateSuccess)
                              {
                                  //NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
                                  [self closeButtonOnclick];
                                  [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                                  
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                  //NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
                                  [self closeButtonOnclick];
                                  [SVProgressHUD showErrorWithStatus:[error errorDescription]];
                              }
                              else if (state == SSPublishContentStateCancel)
                              {
                                  [SVProgressHUD showSuccessWithStatus:@"取消分享"];
                                  [self closeButtonOnclick];
                              }
                              
                          }];
}
@end
