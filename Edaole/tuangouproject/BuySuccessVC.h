//
//  BuySuccessVC.h
//  tuangouproject
//
//  Created by Jinsongzhuang on 1/17/15.
//
//

#import <UIKit/UIKit.h>

@interface BuySuccessVC : UIViewController

// 商品Id
@property (nonatomic, copy)NSString * groupId;

// 设置为NO时，进入页面自动弹出分享界面  yes时，进入 自动 弹出分享界面
@property (nonatomic, assign) BOOL isHidenAutomaticShare;

@end
