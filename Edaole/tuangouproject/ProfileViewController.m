//
//  ProfileViewController.m
//  tuangouproject
//
//  Created by stcui on 14-1-1.
//
//

#import "ProfileViewController.h"
//#import "CouponViewController.h"
#import "MyOwnCouponListVC.h"
#import "OrderListViewController.h"
#import "Session.h"
#import "Order.h"
#import "LoginViewController.h"

@interface _ProfileCell : UITableViewCell @end

@interface ProfileViewController ()
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) Order *order;
@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.order = [Order sharedInstance];
        [self.order load];
        self.navigationItem.title=@"我的优惠券";
        self.items = @[/*@"icon_mine_unpaid", @"待付款订单", @"icon_mine_paid", @"已付款订单"*/];
        self.tabBarItem.title = @"优惠券|mycoupon_h.png";
        UIImage *imageTab = [UIImage imageNamed:@"mycoupon.png"];
		self.tabBarItem.image = imageTab;
    }
    return self;
}

- (void)dealloc
{
    if ([self isViewLoaded]) {
        [self.order removeObserver:self forKeyPath:@"loading"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.order addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:NULL];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myCouponsButton.enabled = NO;
    self.myCouponsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    self.myCouponsButton.spacing = 20;
    [self.loginButton setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[[UIImage imageNamed:@"bt_login"] stretchableImageWithLeftCapWidth:5 topCapHeight:10] forState:UIControlStateNormal];
    [self.logoutButton setBackgroundImage:[[UIImage imageNamed:@"bt_login"] stretchableImageWithLeftCapWidth:5 topCapHeight:10] forState:UIControlStateNormal];
    self.tableView.tableHeaderView = self.headerView;
    [self.loginButton addTarget:self action:@selector(showLoginView) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSessionChanged:) name:SessionChangedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView
{
    self.enabled = [SESSION didLogin];
    if (self.enabled) {
        self.usernameLabel.text = [SESSION username];
        NSString *money = [SESSION money];
        if ([money integerValue] == 0) {
            money = @"0元";
        } else {
            money = [NSString stringWithFormat:@"%.2f元", [money floatValue]];
        }
        self.balanceLabel.text = money;
        self.tableView.tableHeaderView = self.infoHeaderView;
    } else {
        self.tableView.tableHeaderView = self.headerView;
    }
    self.myCouponsButton.enabled = self.enabled;
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark -我的优惠跳转到 我的优惠券 列表
- (IBAction)onShowCoupons:(id)sender
{
    if ([SESSION didLogin]) {
        MyOwnCouponListVC *myOwnCoupanListVC = [[MyOwnCouponListVC alloc] init];
        myOwnCoupanListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myOwnCoupanListVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *orders = [Order sharedInstance].unpaiedOrders;
    NSString * const kIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if (!cell) {
        cell = [[_ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.userInteractionEnabled = self.enabled;
    
    NSString *imageName = self.items[indexPath.row * 2];
    if (!self.enabled) {
        imageName = [imageName stringByAppendingString:@"_disabled"];
    }
    cell.accessoryType = (orders.count == 0) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)", self.items[indexPath.row * 2 + 1], orders.count];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Order *order = [Order sharedInstance];
    NSArray *orders = indexPath.row == 0 ? order.unpaiedOrders : order.paiedOrders;
    OrderListViewController *listController = [[OrderListViewController alloc] init];
    listController.title = @"待付款订单";
    listController.orders = orders;
    listController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listController animated:YES];
}

#pragma mark - Drag Refresh
- (void)onRefresh
{
    [SESSION refreshSessionData];
}

#pragma mark - Notification
- (void)onSessionChanged:(NSNotification *)notification
{
    [self updateView];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([self isViewLoaded]) {
        [self endRefresh];
    }
}

#pragma mark - Actions
- (void)showLoginView
{
    LoginViewController *detailViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    [self.view.window.rootViewController presentModalViewController:detailViewController animated:YES];
}

- (IBAction)logout:(id)sender
{
    [SESSION reset];
    [self updateView];
}

@end

@implementation _ProfileCell : UITableViewCell
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.left = 10;
}
@end