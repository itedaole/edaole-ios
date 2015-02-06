    //
//  CouponViewController.m
//  tuangouproject
//
//  Created by liu song on 13-3-5.
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import "CouponViewController.h"
#import "LoginViewController.h"
#import "TuanQuanCustomCell.h"
#import "CodeViewController.h"
#import "SVProgressHUD.h"
#import "UIBarButtonItem+Factory.h"
#import "BaseViewController.h"
#import "UIImageView+WebCache.h"

NS_INLINE NSString *stringfy(id str) {
    if (str == [NSNull null] || str == nil) return @"";
    return [str description];
}

@interface CouponViewController () <LoginViewControllerDelegate>
@property (strong, nonatomic) NSMutableArray *coupons;
@property (strong, nonatomic) NSMutableDictionary *scrollPosition;
@property (assign, nonatomic) NSUInteger currentSegmentIndex;
@property (strong, nonatomic) UILabel *emptyTipLabel;
@property (strong, nonatomic) NSArray *menuItems;
@property (assign, nonatomic) BOOL loginDidAppear;
@end

@implementation CouponViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.scrollPosition = [[NSMutableDictionary alloc] initWithCapacity:4];
        self.currentSegmentIndex = 0;
        self.emptyTipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.emptyTipLabel.backgroundColor = [UIColor clearColor];
        self.emptyTipLabel.text = @"还没有该订单";

        self.navigationItem.title=@"我的优惠券";
        self.tabBarItem.title = @"优惠券|mycoupon_h.png";
        UIImage *imageTab = [UIImage imageNamed:@"mycoupon.png"];
		self.tabBarItem.image = imageTab;

//        UIBarButtonItem *loginItem = [UIBarButtonItem itemWithTitle:@"登录" target:self action:@selector(startLogin)];
//        self.navigationItem.rightBarButtonItem = loginItem;//[[UIBarButtonItem alloc] initWithCustomView:self.login];
//        self.loginButton = (UIButton *)loginItem.customView;
//        [self.loginButton addTarget:self action:@selector(startLogin) forControlEvents:UIControlEventTouchUpInside];
        
        self.menuItems = @[@"未使用", @"已使用", @"已过期", @"快递单"];
        CouponModel *model = SESSION.couponModel;
        self.coupons = [NSMutableArray arrayWithObjects:model.unusedCoupons, model.consumedCoupons, model.expiredCoupons, model.expressCoupons, nil];
//        self.coupons = [NSMutableArray arrayWithObjects:unconsumed, consumed, outdated, nil];
//        self.coupons = [SESSION.couponModel.coupons mutableCopy];
        [SESSION.couponModel addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [SESSION.couponModel removeObserver:self forKeyPath:@"loading"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.menuTableView) {
        self.headerBgView.image = [UIImage imageNamed:@"bg_mine_accountView"];
        self.menuTableView.separatorColor = [UIColor colorWithWhite:0.8 alpha:1];
        self.menuTableView.rowHeight = 30;
        self.menuTableView.tableHeaderView = self.menuHeaderView;
        self.menuTableView.backgroundView = nil;
        self.menuTableView.backgroundColor = [UIColor whiteColor];
    }
    self.tableView.separatorColor = [UIColor colorWithWhite:0.933 alpha:1];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 65;
    self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setSegmentControl:nil];
    [self setMenuHeaderView:nil];
    [self setNameLabel:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateLoginButton];
    self.nameLabel.text = [SESSION username];
    if (!self.modalViewController) {
        if ([SESSION didLogin]) {
            [self loadData];
        } else if (!self.loginDidAppear) {
            self.loginDidAppear = YES;
            [self startLogin];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)updateLoginButton
{
    [self.loginButton setTitle:[SESSION didLogin]?@"注销":@"登录" forState:UIControlStateNormal];
}

- (void)startLogin
{
    if ([SESSION didLogin]) {
        [SESSION reset];
        [self updateLoginButton];
        [self cleanData];
        [self.tableView reloadData];
        return;
    }
    LoginViewController *detailViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    detailViewController.delegate = self;
    [self.view.window.rootViewController presentModalViewController:detailViewController animated:YES];
}

- (void)cleanData
{
    self.coupons = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object != SESSION.couponModel) return;
    void(^action)() = ^{
        CouponModel *model = object;
        self.coupons = [NSMutableArray arrayWithObjects:model.unusedCoupons, model.consumedCoupons, model.expiredCoupons, model.expressCoupons, nil];
        if (self.isViewLoaded && ![change[NSKeyValueChangeNewKey] boolValue]) {
            [SVProgressHUD dismiss];
            [self endRefresh];
            [self.tableView reloadData];
        }
    };
    if ([NSThread isMainThread]) {
        action();
    } else {
        dispatch_async(dispatch_get_main_queue(), action);
    }
}

#pragma mark -
#pragma mark Table view data source
- (NSArray *)currentItems
{
    if (self.coupons.count > 0 && self.currentSegmentIndex < self.coupons.count) {
        return [self.coupons objectAtIndex: self.currentSegmentIndex];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.menuTableView) {
        return [self menuTableViewCellCount];
    } else {
        NSInteger count = [self currentItems].count;
        if (count == 0) {
            [self.emptyTipLabel sizeToFit];
            [self.tableView addSubview:self.emptyTipLabel];
            self.emptyTipLabel.hidden = NO;
            self.emptyTipLabel.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        } else {
            self.emptyTipLabel.hidden = YES;
        }
        return [self currentItems].count;// [self.listimage count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.menuTableView) {
        return [self menuTableViewCellForRowAtIndexPath:indexPath];
    } else {
        return [self listTAbleViewCellForRowAtIndexPath:indexPath];
    }
}
- (UITableViewCell *)listTAbleViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";

    TuanQuanCustomCell *cell = (TuanQuanCustomCell *)[self.tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TuanQuanCustomCell" owner:self options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hang_xz.png"]];
    }

    NSDictionary *coupon = [[self currentItems] objectAtIndex:indexPath.row];

    NSString *url;
    
    if ([[coupon valueForKeyPath:kCouponCDNImage] length]>0) {
        url=stringfy([coupon valueForKeyPath:kCouponCDNImage]);
    }else{
        url=ImageURL(stringfy([coupon valueForKeyPath:kCouponImage]));
    }
    
    [cell.listimageview sd_setImageWithURL:[NSURL URLWithString:url]];
    cell.nameLabel.text = stringfy([coupon valueForKeyPath:@"team.partner.title"]);// [self.titlearray objectAtIndex:row];

    if (self.segmentControl.selectedSegmentIndex < 3) {
        //    cell.price.text = [NSString stringWithFormat:@"购买时间:%@",[self shijianzhuanhuan:coupon[kCreateTime]]];
        cell.sellerLabel.text = [coupon valueForKeyPath:kCouponProduct];
        cell.value.text = [NSString stringWithFormat:@"有效期: %@前",[self shijianzhuanhuan: coupon[kExpireTime] ]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else {
        NSString *express = [coupon valueForKeyPath:@"express_name.name"];
        NSString *number  = [coupon valueForKey:@"express_no"];
        if ([express isKindOfClass:[NSString class]]) {
            cell.sellerLabel.text = [NSString stringWithFormat:@"%@ - %@", express, stringfy(number)];
        } else {
            cell.sellerLabel.text = @"暂无快递信息";
        }
        cell.value.text = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(NSString *)shijianzhuanhuan:(NSString *)time
{
    static NSDateFormatter *dateFormatter = nil;
    if (nil == dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    }
	NSString *currentDay = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[time intValue]]];

    return currentDay;
}

#pragma mark - Refresh Delegate Methods
- (void)loadData {
    [SESSION.couponModel setNeedsReload];
    //请求优惠列表
    [SVProgressHUD showWithStatus:@"加载中"];
}

- (void)onRefresh
{
    [self loadData];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{

	//  should be calling your tableviews data source model to reload
	//  put here just for demo

    [self.tableView reloadData];
}

- (void)doneLoadingTableViewData{

	//  model should call this when its done loading
//	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	[self endRefresh];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[super scrollViewDidScroll:scrollView];

    //判断uitableview滑到了底，用来做分页显示
    if(self.tableView.contentOffset.y<0)
    {
        //it means table view is pulled down like refresh

        return;
    }
    else if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
    {
        //        NSLog(@"hit bottom!");
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.menuTableView) {
        [self menuTableViewDidSelectRowAtIndexPath:indexPath];
    } else {
        [self listTableViewDidSelectRowAtIndexPath:indexPath];
    }
}

- (void)listTableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.segmentControl.selectedSegmentIndex == 3) return;
    
    NSDictionary *coupon = [[self currentItems] objectAtIndex:indexPath.row];
    CodeViewController *temp = [[CodeViewController alloc] initWithNibName:@"CodeViewController" bundle:nil];
    temp.hidesBottomBarWhenPushed=YES;
    temp.title = [coupon valueForKeyPath:@"team.product"];
    temp.shopname = [coupon valueForKeyPath:kProductId];// [self.id_bianhao objectAtIndex:row];
    temp.shopname_down = [coupon valueForKeyPath:kSecret];//[self.secret objectAtIndex:row];
    [temp consumed:[[coupon valueForKey:@"consume"] isEqualToString:@"Y"]];
    [self.navigationController pushViewController:temp animated:YES];
}

- (void)showListAtIndex:(NSUInteger)index
{
    [self forwardToList];
    [self.tableView reloadData];
}

- (IBAction)onMyCoupon:(id)sender
{
    if ([SESSION didLogin]) {
        self.title = @"我的优惠券";
        self.currentSegmentIndex = 0;
        [self showListAtIndex:0];
    }
}

- (void)menuTableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([SESSION didLogin]) {
        self.title = self.menuItems[indexPath.row];
        self.currentSegmentIndex = indexPath.row+1;
        [self showListAtIndex:indexPath.row+1];
    }
    [self.menuTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)loginViewController:(LoginViewController *)controller finishedWithObject:(id)obj success:(BOOL)success
{
    [self updateLoginButton];
    if (success) {
       [self loadData];
//        [APPDELEGATE setpageindex:1];
    }
}

- (IBAction)onSegmentChanged:(UISegmentedControl *)sender {
    CGPoint offset = self.tableView.contentOffset;
    [self.scrollPosition setObject:[NSValue valueWithCGPoint:offset] forKey:@(self.currentSegmentIndex)];
    self.currentSegmentIndex = sender.selectedSegmentIndex;
    NSValue *offsetValue = [self.scrollPosition objectForKey:@(sender.selectedSegmentIndex)];
    if (offsetValue) {
        [self.tableView setContentOffset:[offsetValue CGPointValue] animated:NO];
    } else {
        [self.tableView setContentOffset:CGPointZero animated:NO];
    }
    [self.tableView reloadData];
}

#pragma mark - menu related
- (void)forwardToList
{
    self.tableView.hidden = NO;
    self.menuTableView.hidden = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithTarget:self action:@selector(backToMenu)];
    [self.view bringSubviewToFront:self.tableView];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:transition forKey:@"transition"];
}

- (void)backToMenu
{
    self.tableView.hidden = YES;
    self.menuTableView.hidden = NO;
    self.navigationItem.leftBarButtonItem = nil;
    self.title = @"我的优惠券";
    [self.view bringSubviewToFront:self.menuTableView];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:transition forKey:@"transition"];
}

- (NSInteger)menuTableViewCellCount
{
    return self.menuItems.count;
}

- (UITableViewCell *)menuTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * kCellIdentifier = @"menu";
    UITableViewCell *cell = [self.menuTableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.menuItems[indexPath.row];
    return cell;
}
@end
