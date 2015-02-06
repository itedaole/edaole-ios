//
//  XiangqingViewController.m
//  tuangouproject
//
//  Created by liu song on 13-3-17.
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "WebViewController.h"
#import "UIView+Sizes.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import "JSONKit.h"
#import "EGORefreshTableHeaderView.h"
#import "Reachability.h"
#import "SDWebImageManager.h"
#import "UIAlertView+Blocks.h"
#import <ShareSDK/ShareSDK.h>
#import "SRRefreshView.h"
#import "ShenQianQrViewController.h"
#import "ListViewController.h"
#import "ShareLinkGenerator.h"

#import "LoginViewController.h"
#import "BuySuccessVC.h"

static NSUInteger k2GTipTag = 100;

@interface DetailViewController () <SRRefreshDelegate, UIScrollViewDelegate,LoginViewControllerDelegate>
{
    SRRefreshView *_refreshHeaderView;
    Reachability *_reachability;
}
@property (strong, nonatomic) NSDictionary *options;
@property (strong, nonatomic) ASIHTTPRequest *req;
@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _reachability = [Reachability reachabilityWithHostName: [kHost componentsSeparatedByString:@"/"][0]];
        // Custom initialization
        UIButton *bn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [bn setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
        [bn setBackgroundImage:[UIImage imageNamed:@"btn_back_hilight.png"] forState:UIControlStateHighlighted];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:bn];
        [bn setTitle:@"返回" forState:UIControlStateNormal];
        bn.titleLabel.font=[UIFont systemFontOfSize:15];
        [bn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [bn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        //    [button setBackground:@"bar_button" highlight:@"bar_button_hilight"];
//        [button setImage:[UIImage imageNamed:@"action"] forState:UIControlStateNormal];
//        [button setSize:CGSizeMake(35, 30)];
//        [button addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
//                                                  initWithCustomView:button];
        
    }
    return self;
}

- (void)setupButton
{
    [self.bottomOrderButton setBackground:@"bar_button" highlight:@"bar_button_click"];
    [self.bottomOrderButton setImage:nil forState:UIControlStateNormal];
    [self.bottomOrderButton setImage:nil forState:UIControlStateHighlighted];
    self.bottomOrderButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [self.bottomOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bottomOrderButton setTitle:@"立即购买" forState:UIControlStateNormal];
    
    [self.topOrderButton setBackground:@"bar_button" highlight:@"bar_button_click"];
    [self.topOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.topOrderButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupButton];
    
    self.addrLabel.hidden = YES;
    
    self.updateDate = [NSDate date];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.origPriceLabel.textColor = [UIColor priceColor];
    [self priceLabel].textColor = [UIColor priceColor];
    self.priceUnitLabel.textColor = [UIColor priceColor];
    
    scroll.delaysContentTouches = NO;
    scroll.delegate = self;
    self.contentLabel.text = nil;
    self.noticeLabel.text = nil;
    
    SRRefreshView *view = [[SRRefreshView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - 65, self.view.frame.size.width, 65)];
    view.delegate = self;
    [scroll addSubview:view];
    _refreshHeaderView = view;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapImage:)];
    imageview.userInteractionEnabled = YES;
    [imageview addGestureRecognizer:tap];

    [self updateView];

    self.bottomBgView.backgroundColor = [UIColor colorWithWhite:0.73 alpha:1];
    [self.noticeLabel setBackgroundColor: self.scrollView.backgroundColor];
    [self.contentLabel setBackgroundColor: self.scrollView.backgroundColor];

    [self.scrollView addSubview:self.storeView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView scrollViewDidScroll];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView scrollViewDidEndDraging];
}
- (IBAction)dismiss:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc
{
    [self.req cancel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)is2G
{
    NetworkStatus status = _reachability.currentReachabilityStatus;
    return status != kReachableViaWiFi;
}

- (void)updateView
{
    self.title = @"优惠详情";
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[self.product valueForKey:kEndTime] integerValue]];
    NSInteger diff = MAX([date timeIntervalSinceNow], 0);
    NSInteger hour = diff / (3600);

    BOOL refund = [[self.product valueForKey:@"tksq-gm"] isEqualToString:@"Y"];
    BOOL expireRefund = [[self.product valueForKey:@"tksq-gq"] isEqualToString:@"Y"];
    NSInteger rebate = [[self.product valueForKey:@"bonus"] integerValue];

    NSString *text = nil;
    if (hour <= 24) {
        text = [NSString stringWithFormat:@"%d小时以内", hour];
    } else if (hour <= 24 * 3) {
        NSInteger day = hour / 24;
        NSInteger hour_part = hour % 24;
        if (hour_part == 0) {
            text = [NSString stringWithFormat:@"剩余%d天", day];
        } else {
             text = [NSString stringWithFormat:@"剩余%d天%d小时",day, hour_part];
        }
    } else {
        text = @"剩余3天以上";
    }
    self.remainLabel.text = text;
    NSInteger max = [[self.product valueForKey:kMaxCount] integerValue];
    if (max == 0) max = NSIntegerMax;
    
    BOOL full = NO;
    NSNumber *nowNumber = [self.product valueForKey:@"now_number"];
    if ([nowNumber isKindOfClass:[NSNumber class]]) {
        full = [nowNumber integerValue] >= max;
    }
    if (full) {
        self.topOrderButton.enabled = NO;
        self.bottomOrderButton.enabled = NO;
        [self.topOrderButton setTitle:@"人数己满" forState:UIControlStateNormal];
        self.bottomOrderButton.hidden = YES;
    } else {
        self.topOrderButton.enabled = YES;
        self.bottomOrderButton.enabled = YES;
        [self.topOrderButton setTitle:@"抢购" forState:UIControlStateNormal];
        self.bottomOrderButton.hidden = NO;
    }
    
    //初始化数据
    NSString *urlStr ;
    
    if ([self.product[kCNDLargeImage] length]>0) {
       urlStr = self.product[kCNDLargeImage];
    }else{
       urlStr = ImageURL(self.product[kImage]);
    }
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *url = [NSURL URLWithString:urlStr];
    UIImage *image = nil;
    NSString *key = [manager cacheKeyForURL:url];
    if ([manager cachedImageExistsForURL:url]) {
        image = [manager.imageCache imageFromMemoryCacheForKey:key];
        if (!image) {
            image = [manager.imageCache imageFromDiskCacheForKey:key];
        }
    }
    
    if (image) {
        imageview.image =image;
    } else {
        if ([self is2G]) {
            UILabel *label = (UILabel *)[imageview viewWithTag:k2GTipTag];
            if (!label) {
                label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, imageview.width, 30)];
                label.tag = k2GTipTag;
                label.backgroundColor = [UIColor clearColor];
                label.text = @"点击查看图片";
                label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
                label.userInteractionEnabled = NO;
                label.textAlignment = UITextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(CGRectGetMidX(imageview.bounds), CGRectGetMidY(imageview.bounds));
                [imageview addSubview:label];
            }
        } else {
            imageview.userInteractionEnabled = NO;
            [self loadDetailImageWithURL:urlStr];
        }
    }
    xianjia.text = [NSString stringWithFormat:@"%g", [self.product[kCurrentPrice] floatValue]];
    [xianjia sizeToFit];
    yuanjia.left = xianjia.right + 5;
    yuanjia.text = [NSString stringWithFormat:@"%g元", [self.product[kOrigPirce] floatValue]];
    [yuanjia sizeToFit];
    
    yuanjia.bottom = xianjia.bottom - 3;
    yuanjia.left = xianjia.right + 3;
    self.deleteLine.width = yuanjia.width+1;
    self.deleteLine.left = yuanjia.left - 1;
    self.deleteLine.top = CGRectGetMidY(yuanjia.frame);
    renshu.text = [NSString stringWithFormat:@"%@人",self.product[kBoughtCount]];
    [renshu sizeToFit];
   
    self.refundIcon.highlighted = refund;
    self.expireRefundIcon.highlighted = expireRefund;
    self.rebateIcon.highlighted = rebate;
    self.refundLabel.text = refund ? @"支持购买退款" : @"不支持购买退款";
    self.expireRefundLabel.text = expireRefund ? @"支持过期退款" : @"不支持过期退款";
    self.rebateLabel.text = rebate ? [NSString stringWithFormat: @"邀请返利%d元", rebate] : @"不支持邀请返利";
#ifndef kOptionDetail3Support
    self.refundLabel.hidden=YES;
    self.expireRefundLabel.hidden=YES;
    self.rebateLabel.hidden=YES;
    self.refundIcon.hidden = YES;
    self.expireRefundIcon.hidden = YES;
    self.rebateIcon.hidden = YES;
#endif
    
//    UIImage *bgImage = [[UIImage imageNamed:@"detail_item_bg"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    
//    [self.storeInfoButton setBackgroundImage:bgImage forState:UIControlStateNormal];
//    [self.storeInfoButton setImage:[UIImage imageNamed:@"detail_icn_info"] forState:UIControlStateNormal];
//    [self.storeInfoButton setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    
    // 商家名称地址电话
    self.storeName.text = [self.product valueForKeyPath:@"partner.title"];
    self.storeAddress.text = [self.product valueForKeyPath:@"partner.address"];

    // 套餐内容
    NSString *detailText = self.product[kSummary];

    
    detailText = [detailText stringByReplacingOccurrencesOfString:@"((\\r)?\\n){2,}"
                                                       withString:@"\n\n"
                                                          options:NSRegularExpressionSearch
                                                            range:NSMakeRange(0, detailText.length)];
   
    [self.contentLabel setText:detailText];
    [self.contentLabel sizeToFit];
    
    // 消费提示
    NSString *notice = self.product[kNotice];
    NSString *noticeText = nil;
    if ([notice isKindOfClass:[NSString class]]) {
        noticeText = [self.product[kNotice] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    if (noticeText.length == 0) {
        self.noticeTitle.hidden = YES;
        self.noticeLabel.hidden = YES;
    } else {
        self.noticeTitle.hidden = NO;
        self.noticeLabel.hidden = NO;
        self.noticeLabel.text = noticeText.length > 0 ? noticeText : @"暂无";
        [self.noticeLabel sizeToFit];
    }
    
    self.bottomInfoLabel.text = kDetailInfo;
    
    self.bountSuffixLabel.left = renshu.right+2;
    const CGFloat spacing = 20.f;
    const CGFloat titleSpacing = 5;
    BOOL hasSeller = [[self.product valueForKey:@"partner"] isKindOfClass:[NSDictionary class]];
    
    if (hasSeller) {
        self.nameLabel.text = [self.product valueForKeyPath:kSellerName];
        [self.nameLabel sizeToFit];

        self.productNameLabel.text = [self.product valueForKeyPath:kProductName];
        [self.productNameLabel sizeToFit];
        self.productNameLabel.top = self.nameLabel.bottom + 3;

        if (![kHost hasSuffix:@"tuanln.com"]) {
            // 米粒特制
            NSString *mili_summary = [self.product valueForKeyPath:@"team_jybt"];
            if (mili_summary.length > 0) self.productNameLabel.text = mili_summary;
        }
        NSString *mili_addr = [self.product valueForKeyPath:@"team_quyu"];
        if (mili_addr.length > 0) {
            self.addrLabel.textColor = [UIColor colorWithWhite:0.35 alpha:1];
            self.addrLabel.font = self.nameLabel.font;
            self.addrLabel.text = mili_addr;
            [self.addrLabel sizeToFit];
            self.addrLabel.bottom = self.nameLabel.bottom;
            self.addrLabel.left   = self.nameLabel.right + 30;
        }

    } else {
        self.nameLabel.hidden = YES;
        self.productNameLabel.hidden = YES;
        self.productNameLabel.bottom = self.nameLabel.bottom;
        self.productNameLabel.top = self.nameLabel.top;
        self.productNameLabel.height = 0;
    }
    
    


    self.storeView.hidden = !hasSeller;
    CGFloat y = self.productNameLabel.bottom + spacing;
    if (hasSeller) {
        self.storeView.top = y + 5;
    } else {
        self.storeView.frame = CGRectMake(0, y, 1, 1);
    }
    
    self.relativeProductButton.top = self.storeView.bottom + 5;
    
    self.contentTitle.top = self.relativeProductButton.bottom + spacing;

    [self.contentLabel sizeToFit];
    self.contentLabel.top = self.contentTitle.bottom + titleSpacing;
    
    self.noticeTitle.top = self.contentLabel.bottom + spacing;
    self.noticeLabel.top = self.noticeTitle.bottom + titleSpacing;
    
    self.bottomOrderButton.top = self.noticeLabel.bottom + spacing;
    self.bottomOrderButton.centerX = CGRectGetMidX(self.scrollView.bounds);
    self.bottomBgView.top = CGRectGetMidY(self.bottomOrderButton.frame);
    self.bottomBgView.height = 46;
    self.bottomInfoLabel.bottom = self.bottomBgView.bottom - 3;
    
    CGFloat height = MAX(self.bottomBgView.bottom, self.view.height);
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, height);
    self.scrollView.clipsToBounds = NO;
    self.bottomBgView.height = CGRectGetHeight(self.view.bounds);
}

#pragma mark - Actions
- (IBAction)onTapOrder:(id)sender {

    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    if ([bundleId isEqualToString:@"com.csc.shengqianshenqi"]) {//定制
        ShenQianQrViewController *vc= [[ShenQianQrViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentModalViewController:nav animated:YES];
        return;
    }
    
//    PlaceOrderViewController *controller = [[PlaceOrderViewController alloc] initWithNibName:nil bundle:nil];
//    controller.product = self.product;
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
    
    // 如果登陆成功了，则直接跳转到下一级页面
    if ([SESSION didLogin])
    {
        // 跳转到购买成功的界面
        BuySuccessVC *successVC = [[BuySuccessVC alloc] initWithNibName:@"BuySuccessVC" bundle:nil];
        successVC.hidesBottomBarWhenPushed = YES;
        successVC.groupId = [self.product valueForKeyPath: kProductId];
        [self.navigationController pushViewController:successVC animated:YES];
    }
    // 如果登陆失败了，则跳转到注册页面
    else
    {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginVC.delegate = self;
        //[self presentModalViewController:loginVC animated:YES];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark -LoginViewController的回调
- (void)loginViewController:(LoginViewController *)controller finishedWithObject:(id)obj success:(BOOL)success
{
    if (success) {
        
        // 跳转到购买成功的界面
        BuySuccessVC *successVC = [[BuySuccessVC alloc] initWithNibName:@"BuySuccessVC" bundle:nil];
        successVC.hidesBottomBarWhenPushed = YES;
        successVC.groupId = [self.product valueForKeyPath: kProductId];
        [self.navigationController pushViewController:successVC animated:YES];
        
    }
}

- (IBAction)onTapStoreInfo:(id)sender
{
    WebViewController *controller = [[WebViewController alloc] init];
    NSString *pid = [self.product valueForKeyPath: kSellerId];
    controller.url = TGURL(@"Partner/detail_mobile", @{@"id": pid});
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onTapDetail:(id)sender
{
    void (^showDetail)() = ^{
        WebViewController *controller = [[WebViewController alloc] init];
        controller.hidesBottomBarWhenPushed=YES;
        NSString *id = self.product[kProductId];
        controller.url = TGURL(@"Tuan/detail_mobile", @{@"id": id});
        [self.navigationController pushViewController:controller animated:YES];
    };
    
    if ([self is2G]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前网络下会产生额外流量费用，是否继续"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"取消" otherButtonTitles:@"继续访问", nil];
        [alert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex != alert.cancelButtonIndex) {
                showDetail();
            }
        }];
    } else {
        showDetail();
    }
}

- (IBAction)onTapRelativeProduct:(id)sender
{
    ListViewController *vc = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    vc.title = @"相关优惠";
    vc.hidesTopMenu = YES;
    NSMutableDictionary *params = [@{@"ignore":[self.product valueForKeyPath: kProductId]} mutableCopy];
    id partnerId = [self.product valueForKeyPath:kSellerId];
    if (partnerId) {
        params[@"partnerid"] = partnerId;
    }
    vc.currentParams = params;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTapStorePhone:(id)sender {
    NSString *phoneNumber = [self.product valueForKeyPath:@"partner.phone"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"拨打电话"
                                                    message:phoneNumber
                                                   delegate:nil
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"拨打", nil];
    [alert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != alert.cancelButtonIndex) {
            NSString *phoneURLStr = [NSString stringWithFormat:@"tel://%@", phoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURLStr]];
        }
    }];
}

- (void)loadDetailImageWithURL:(NSString *)url
{
    if (![url respondsToSelector:@selector(length)] || url.length == 0) return;
    UILabel *label = (UILabel *)[imageview viewWithTag:k2GTipTag];
    label.hidden = YES;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [imageview addSubview:indicator];
    indicator.center = CGPointMake(CGRectGetMidX(imageview.bounds), CGRectGetMidY(imageview.bounds));
    [indicator startAnimating];
    [imageview addSubview:indicator];
    imageview.userInteractionEnabled = NO;
    __unsafe_unretained UIImageView *weekImageView = imageview;
    
    if ([self.product[kCNDLargeImage] length]>0) {
        url = self.product[kCNDLargeImage];
    }else{
        url = ImageURL(self.product[kImage]);
    }

    [imageview sd_setImageWithURL:[NSURL URLWithString: url]
                 placeholderImage:nil
                          options:SDWebImageRetryFailed
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (error) {
                                [label removeFromSuperview];
                                [indicator removeFromSuperview];
                            } else {
                                weekImageView.userInteractionEnabled = YES;
                                [indicator removeFromSuperview];
                                label.hidden = NO;
                            }
                        }];
}

- (IBAction)onTapImage:(UITapGestureRecognizer *)sender
{
    [self loadDetailImageWithURL:ImageURL(self.product[kImage])];
}

//- (IBAction)onShare:(id)sender
//{
//    id<ISSCAttachment> imageData = nil;
//    if (imageview.image) {
//        NSData *data = UIImageJPEGRepresentation(imageview.image, 0.8);
//        imageData = [ShareSDK attachmentWithData:data mimeType:@"image/jpeg" fileName:@"img"];
//    }
//    NSString *shareLink = [ShareLinkGenerator shareLinkForProduct:self.product];
//    id<ISSContent> publishContent = [ShareSDK content:self.contentLabel.text
//                                       defaultContent:@""
//                                                image:imageData
//                                                title:nil
//                                                  url:shareLink
//                                          description:nil
//                                            mediaType:SSPublishContentMediaTypeNews];
//    
//    NSArray *shareList = [ShareSDK getShareListWithType:/*ShareTypeSinaWeibo, ShareTypeQQ,*/ ShareTypeWeixiSession, ShareTypeWeixiTimeline, nil];
//    id<ISSShareOptions>shareOptions=
//    [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
//                           oneKeyShareList:[NSArray defaultOneKeyShareList]
//                            qqButtonHidden:NO
//                     wxSessionButtonHidden:YES
//                    wxTimelineButtonHidden:YES
//                      showKeyboardOnAppear:YES
//                         shareViewDelegate:nil
//                       friendsViewDelegate:nil
//                     picViewerViewDelegate:nil];
//    
//    [ShareSDK showShareActionSheet:nil
//                         shareList:shareList
//                           content:publishContent
//                     statusBarTips:YES
//                      authOptions :nil
//                      shareOptions:shareOptions
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    NSLog(@"分享成功");
//                                } else if (state == SSResponseStateFail) {
//                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode],[error errorDescription]);
//                                }
//                            }];
//}

- (void)reload
{
    NSString *url = TGURL(@"Tuan/goodById", @{@"id":self.product[kProductId]});
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self.req cancel];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    req.delegate = self;
    [req startAsynchronous];
    self.req = req;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.req = nil;
    NSDictionary *resp = [[request responseData] objectFromJSONData];
    if ([[resp valueForKey:@"status"] intValue] == 1) {
        self.product = [resp valueForKey:@"result"];
    }
    self.updateDate = [NSDate date];
    [SVProgressHUD dismiss];
    [_refreshHeaderView endRefresh];
//    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:scroll];
    [self updateView];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    self.req = nil;
    self.updateDate = [NSDate date];
    [SVProgressHUD dismiss];
    [_refreshHeaderView endRefresh];
}

#pragma mark - EGORefreshTableHeaderDelegate Methods
- (void)slimeRefreshStartRefresh:(SRRefreshView*)refreshView
{
    [self reload];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reload];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return !!self.req;; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return self.updateDate; // should return date data source was last changed
}


@end
