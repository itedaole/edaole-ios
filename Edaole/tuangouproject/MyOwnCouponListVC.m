//
//  MyOwnCouponListVC.m
//  tuangouproject
//
//  Created by Jinsongzhuang on 1/29/15.
//
//
// 我的团购列表
#import "MyOwnCouponListVC.h"
#import "MyOwnCouponCell.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"

#import "MyCouponListModel.h"
#import "BuySuccessVC.h"

@interface MyOwnCouponListVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyOwnCouponListVC
{
    UITableView *_couponTableView;
    NSMutableArray *_datasource;
}

- (void)tableView
{
    _couponTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _couponTableView.dataSource = self;
    _couponTableView.delegate = self;
    
    _datasource = [[NSMutableArray alloc] init];
    
    [_couponTableView registerNib:[UINib nibWithNibName:@"MyOwnCouponCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    _couponTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    
    [self.view addSubview:_couponTableView];
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
    
    self.title = @"我的优惠券";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureNavBar];
    [self tableView];
    [self startNetWorkRequest];
}

#pragma mark -
#pragma mark -发起网络请求
- (void)startNetWorkRequest
{
    NSString *loginURL = TGURL(@"User/getCouponNew", @{@"user_id": [SESSION user_id]});
    
    [SVProgressHUD showWithStatus:@"获取中..." ];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:loginURL]];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    NSDictionary *rootDic = [request.responseData objectFromJSONData];
    
    MyCouponListModel *listModel = [[MyCouponListModel alloc] initWithDictionary:rootDic error:nil];
    
    if (listModel.status == -1)
    {
        [SVProgressHUD showErrorWithStatus:@"获取失败"];
    }
    else
    {
        _datasource.array = listModel.result;
        [_couponTableView reloadData];
    }
    
    //[self setItemsInfoWithDictionary:[rootDic objectForKey:@"result"]];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD showErrorWithStatus:@"获取失败"];
    
    // 重置信息（清除获取信息）
    //[self resetItemsInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOwnCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [cell setCellInfoWithModel:_datasource[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProductItemModel *itemModel = _datasource[indexPath.row];
    
    BuySuccessVC *buysuccessVC = [[BuySuccessVC alloc] initWithNibName:@"BuySuccessVC" bundle:nil];
    buysuccessVC.groupId = [NSString stringWithFormat:@"%d",itemModel.id];
    buysuccessVC.hidesBottomBarWhenPushed = YES;
    buysuccessVC.isHidenAutomaticShare = YES;
    
    [self.navigationController pushViewController:buysuccessVC animated:YES];
}

- (void)navigationBarBackbuttonOnclick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
