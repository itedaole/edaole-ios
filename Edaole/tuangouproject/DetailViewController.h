//
//  XiangqingViewController.h
//  tuangouproject
//
//  Created by liu song on 13-3-17.
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceOrderViewController.h"
//#import "DTCoreText.h"
#import "ASIHTTPRequest.h"

@interface DetailViewController : UIViewController <ASIHTTPRequestDelegate>
{
    IBOutlet UIScrollView *scroll;
    
    IBOutlet UIImageView *imageview;
    IBOutlet UILabel *xianjia;
    IBOutlet UILabel *yuanjia;
    IBOutlet UILabel *renshu;
    IBOutlet UILabel *shangjianame;
}
@property (weak, nonatomic) IBOutlet UIImageView *topBgView;
@property (weak, nonatomic) IBOutlet UIImageView *topInfoBgView;
@property (strong, nonatomic) NSDictionary *product;
@property (strong, nonatomic) NSDate *updateDate;
@property (weak, nonatomic) IBOutlet UIButton *topOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomOrderButton;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
@property (weak, nonatomic) IBOutlet UILabel *bottomInfoLabel;

@property (weak, nonatomic) IBOutlet UIView *topInfoView;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *infoBgView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteLine;
@property (weak, nonatomic) IBOutlet UILabel *noticeTitle;

@property (weak, nonatomic) IBOutlet UILabel * contentLabel; // 套餐内容
@property (weak, nonatomic) IBOutlet UILabel *bountSuffixLabel;

@property (weak, nonatomic) IBOutlet UILabel * noticeLabel;

@property (weak, nonatomic) IBOutlet UILabel *remainLabel;

@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UIButton *relativeProductButton; // 相关团购
@property (weak, nonatomic) IBOutlet UILabel *origPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;

@property (weak, nonatomic) IBOutlet UIImageView *refundIcon;
@property (weak, nonatomic) IBOutlet UILabel *refundLabel;
@property (weak, nonatomic) IBOutlet UIImageView *expireRefundIcon;
@property (weak, nonatomic) IBOutlet UILabel *expireRefundLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rebateIcon;
@property (weak, nonatomic) IBOutlet UILabel *rebateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) IBOutlet UIView *storeView;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeAddress;


- (IBAction)onTapStoreInfo:(id)sender;
- (IBAction)onTapOrder:(id)sender;
- (IBAction)onTapDetail:(id)sender;
- (IBAction)onTapRelativeProduct:(id)sender;
- (IBAction)onTapStorePhone:(id)sender;


@end
