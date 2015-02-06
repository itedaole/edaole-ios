//
//  CouponViewController.h
//  tuangouproject
//
//  Created by liu song on 13-3-5.
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SDSegmentedControl.h"
#import "DragRefreshViewController.h"

//定义系统Delegate
#ifndef APPDELEGATE
#define APPDELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate
#endif

@interface CouponViewController : DragRefreshViewController
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) id <UITableViewDataSource> menuDataSource;
@property (nonatomic, strong) id <UITableViewDataSource> couponDataSoruce;
@property (nonatomic, strong) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) IBOutlet UIView *menuHeaderView;
@property (strong, nonatomic) IBOutlet UIImageView *headerBgView;

@property (unsafe_unretained, nonatomic) IBOutlet SDSegmentedControl *segmentControl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)onSegmentChanged:(id)sender;


@end
