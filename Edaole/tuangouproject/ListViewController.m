//
//  ListViewController.m
//  tuangouproject
//
//  Created by liu song on 13-3-5.
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import "ListViewController.h"
#import "ASIHTTPRequest.h"
#import "DDXMLDocument.h"
#import <CoreData/CoreData.h>
#import "ProductCell.h"
#import "SVProgressHUD.h"
#import "SearchViewController.h"
#import "DetailViewController.h"
#import "CategoryViewController.h"
#import "DoubleLevelCategoryViewController.h"
#import "NSDictionary+RequestEncoding.h"
#import "LoadingFooter.h"
#import "ProductTableDataSource.h"
#import <MapKit/MapKit.h>
#import "CityListViewController.h"
#import "iConsole.h"
#import "GeoConverter.h"

#define kThrottle (3600*24L)
static NSString * const LOADING_TEXT = @"加载中...";
static NSString * const kCityKey     = @"city";

@interface ListViewController ()
@property (strong, nonatomic) ProductTableDataSource *dataSource;
@property (nonatomic, strong) NSDictionary *currentCity;
@property (nonatomic, strong) NSDictionary *parentCategory;
@property (nonatomic) NSInteger pageCount;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) LoadingFooter *loadingFooter;
@property (nonatomic) BOOL reloadActionFlag;
@property (nonatomic, strong) CategoryViewController *categoryViewController;
@property (nonatomic, strong) CategoryViewController *sortViewController;
@property BOOL loadingMore;
@property (strong, nonatomic) CityListViewController *cityListViewController;
@property (strong, nonatomic) CLGeocoder *geoCoder;
@end

@implementation ListViewController
+ (Class)dataSourceClass
{
    return [ProductTableDataSource class];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.geoCoder = [[CLGeocoder alloc] init];
        self.dataSource = [[[self.class dataSourceClass] alloc] init];
        self.currentPage = 1;
        self.tabBarItem.title = @"优惠|purchase_h.png";
        self.navigationItem.title =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        
        UIImage *imageTab = [UIImage imageNamed:@"purchase.png"];
		self.tabBarItem.image = imageTab;
        
        self.categoryViewController = [[DoubleLevelCategoryViewController alloc] initWithURL:TGURL(@"Tuan/typeList", nil)];
        self.categoryViewController.name = @"分类";
        self.categoryViewController.allItemName = @"全部";
        self.categoryViewController.delegate = self;
        
        self.sortViewController = [[CategoryViewController alloc] initWithURL:nil];
        self.sortViewController.name = @"排序";
        self.sortViewController.allItemName = @"默认排序";
        [self.sortViewController setItems:@[
         [NSDictionary dictWithId:@"-team_price" name:@"价格↑"],
         [NSDictionary dictWithId:@"team_price" name:@"价格↓"],
         [NSDictionary dictWithId:@"now_number" name:@"购买数↓"],
         [NSDictionary dictWithId:@"-now_number" name:@"购买数↑"],
         [NSDictionary dictWithId:@"begin_time" name:@"开始时间↓"],
         [NSDictionary dictWithId:@"-begin_time" name:@"开始时间↑"]]];
        
        self.sortViewController.delegate = self;
        //  update the last update date
    }
    return self;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismiss];
    
    [self serchviewmiss];
    searchbar.text = @"";
    NSDictionary *rootDic = [request.responseData objectFromJSONData];
    
    if([[NSString stringWithFormat:@"%@", [rootDic objectForKey:@"status"]] isEqualToString: @"-1" ])
    {
        NSLog(@"---------cookies 验证失败～～----------");
        return;
    }
    
    if (self.currentPage == 1) {
        id temp =[rootDic valueForKeyPath:@"result.data"];
        if ([temp isKindOfClass:[NSArray class]]) {
            self.products = [temp mutableCopy];            
        }else{
            self.products=nil;
        }
    } else {
        NSArray *existingIds = [self.products valueForKeyPath:kProductId];
        NSArray *products = [rootDic valueForKeyPath:@"result.data"];
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [products enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
            id productId = [obj valueForKeyPath:kProductId];
            if ([existingIds containsObject:productId]) {
                NSInteger index = [existingIds indexOfObject:productId];
                [self.products replaceObjectAtIndex:index withObject:obj];
            } else {
                [set addIndex:idx];
            }
        }];
        NSArray *newItems = [products objectsAtIndexes:set];
        [self.products addObjectsFromArray:newItems];
    }
    self.pageCount = [[rootDic valueForKeyPath:@"result.exitf.page_count"] integerValue];
    self.dataSource.products = self.products;
    CGPoint offset = CGPointZero;
    if (self.loadingMore) {
        self.loadingMore = NO;
        offset = self.tableView.contentOffset;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    [self endRefresh];
    if (! CGPointEqualToPoint(offset, CGPointZero)) {
        [self.tableView setContentOffset:offset animated:NO];
    }

    [self.tableView reloadData];
    self.loading = NO;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //NSError *error = [request error];
    NSString *resString = [request responseString];
    [SVProgressHUD dismiss];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];;
    
    NSLog(@"---------requestfailed-------%@----",resString);
    [self endRefresh];
    self.loading = NO;
    self.loadingMore = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentCity = [[NSUserDefaults standardUserDefaults] objectForKey:kCityKey];
//    if (_refreshHeaderView == nil) {
//        
//        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - 65, self.view.frame.size.width, 65)];
//        view.delegate = self;
//        [self.tableView addSubview:view];
//        _refreshHeaderView = view;
//        
//    }
    if (self.doLocate) {
        if (nil == _manager) {
            _manager = [[CLLocationManager alloc] init];
            _manager.desiredAccuracy = kCLLocationAccuracyKilometer;
            _manager.delegate = self;
        }
        [self findCurrentCityAndUpdateView];
    }
//    UIButton *bn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [bn setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:bn];
//    [bn addTarget:self action:@selector(onSearch:) forControlEvents:UIControlEventTouchUpInside];

    self.tableView.separatorColor = [UIColor colorWithWhite:0.933 alpha:1];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.loadingFooter = [[LoadingFooter alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 40)];

    //搜索框
    searchbar.tintColor = [UIColor colorWithRed:240/255.0 green:40/255.0 blue:90/255.0 alpha:1.0];
    searchbar.delegate = self;
    searchbar.showsCancelButton = NO;
    searchbar.keyboardType = UIKeyboardTypeDefault;
    //城市选择
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索"
//                                                                  style:UIBarButtonItemStylePlain
//                                                                 target:self
//                                                                 action:@selector(searchtuangou)];
//	self.navigationItem.rightBarButtonItem = leftItem;
//	[leftItem release];
    
    self.chooseCity=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.chooseCity.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
//    [self.chooseCity setBackground:@"bar_button" highlight:@"bar_button_hilight"];
    NSString *cityName=self.currentCity ? [self.currentCity valueForKey:@"name"] : @"全部";
    [self.chooseCity setTitle:cityName forState:UIControlStateNormal];
    [self.chooseCity addTarget:self action:@selector(citylist) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:self.chooseCity];
    self.chooseCity.titleEdgeInsets=UIEdgeInsetsMake(0,0, 0, 10);
    self.chooseCity.size = CGSizeMake(55, 30);
    UIImageView *icon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_homepage_navArrow"] ];
    [self.chooseCity addSubview:icon];
    icon.tag=1999;
    icon.alpha=0.8;
    icon.left=self.chooseCity.width-15;
    icon.top=self.chooseCity.height/2-3;

    //请求优惠列表
    [self loadData];
    if (self.hidesTopMenu) {
        self.topbarView.hidden = YES;
        self.tableView.top = self.topbarView.top;
        self.tableView.bottom = CGRectGetMaxY(self.tableView.bounds);
    }
    [self.topbarView.categoryButton addTarget:self
                                       action:@selector(onCategory:)
                             forControlEvents:UIControlEventTouchUpInside];
    [self.topbarView.sortButton addTarget:self
                                    action:@selector(onSort:)
                          forControlEvents:UIControlEventTouchUpInside];
    if (self.currentSortBy) {
        [self.topbarView.sortButton setTitle:self.currentSortBy[@"name"] forState:UIControlStateNormal];
    }
    self.tableView.dataSource = self.dataSource;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers[0] != self && self.navigationItem.leftBarButtonItem != self.backBarButtonItem) {
        self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
    }
}

- (void)findCurrentCityAndUpdateView
{
    CLLocationCoordinate2D coord = _manager.location.coordinate;
    if ((coord.longitude < 0.001 || coord.latitude < 0.001)  ||
        [_manager.location.timestamp timeIntervalSinceNow] >= 1800)
    {
        [_manager startUpdatingLocation];
    } else {
        [self _decodeWithCoordinate:_manager.location];
    }
}

- (void)_decodeWithCoordinate:(CLLocation *)location
{
    double mgLat, mgLon;
    mars_transform(location.coordinate.latitude, location.coordinate.longitude, &mgLat, &mgLon);
    CLLocation *marsLocation = [[CLLocation alloc] initWithLatitude:mgLat longitude:mgLon];
    [self.geoCoder reverseGeocodeLocation:marsLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            [iConsole log:@"位置反解析失败: %@", error];
        } else {
            CLPlacemark *placemark = placemarks[0];
            [iConsole log:@"解析至: %@", placemark.locality];
            
            NSString *city = [placemarks[0] locality];
            if (city) {
                [self.cityListViewController findAndSelectCity:city];
            }
        }
    }];
}

//搜索优惠
-(void)searchtuangou
{
    SearchViewController *detailViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [self.view.window.rootViewController presentModalViewController:detailViewController animated:YES];
}

- (CityListViewController *)cityListViewController
{
    if (nil == _cityListViewController) {
        _cityListViewController = [[CityListViewController alloc] initWithNibName:@"CityListViewController" bundle:nil];
        _cityListViewController.delegate = self;
    }
    return _cityListViewController;
}

//城市列表
-(void)citylist
{
    [self.view.window.rootViewController presentModalViewController:self.cityListViewController animated:YES];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];
    [iConsole log:@"定位至: %.6f,%.6f", location.coordinate.latitude, location.coordinate.longitude];
    [manager stopUpdatingLocation];
    [self _decodeWithCoordinate:location];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [iConsole log:@"定位失败"];
}

#pragma mark - Navigation
- (void)showProductDetail:(id)product
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailViewController.product = product;
    
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)showProductDetailWithId:(id)productId
{
    [SVProgressHUD show];
    NSString *urlStr = TGURL(@"Tuan/goodById", @{@"id":productId});
    NSURL *url = [NSURL URLWithString:urlStr];
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *weakReq = req;
    [req setCompletionBlock:^{
        BOOL succ = NO;
        id productInfo = [weakReq.responseData objectFromJSONData];
        
        if ([productInfo isKindOfClass:[NSDictionary class]]) {
            NSDictionary *product = productInfo[@"result"];
            if ([product isKindOfClass:[NSDictionary class]]) {
                [SVProgressHUD dismiss];
                succ = YES;
                [self showProductDetail:product];
            }
        }
        if (!succ) {
            [SVProgressHUD showErrorWithStatus:@"没有获取优惠详情，请稍后再试"];
        }
    }];
    [req setFailedBlock:^{
        [SVProgressHUD showErrorWithStatus:@"没有获取优惠详情，请稍后再试"];
    }];
    [req startAsynchronous];
}

//#pragma mark - UITableViewDelegate
//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
//{
//#ifdef DEBUG
//   [iConsole show];
//    [iConsole performSelector:@selector(hide) withObject:nil afterDelay:5];
//#endif
//    return YES;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showProductDetail:self.products[indexPath.row]];
}

#pragma mark - Action
- (void)onSearch:(id)sender
{
    SearchViewController *search = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [self.view.window.rootViewController presentModalViewController:[[UINavigationController alloc] initWithRootViewController: search] animated:YES];
    /*
    [self.tableView setContentOffset:CGPointZero animated:YES];
    [searchbar becomeFirstResponder];
     */
}

- (void)onCategory:(UIButton *)sender
{
    [self.sortViewController.view removeFromSuperview];
    if (self.categoryViewController.view.superview) {
        [self.categoryViewController.view removeFromSuperview];
    } else {
        CGRect frame = sender.frame;
        frame.origin.y = CGRectGetMaxY(frame);
        frame.size.width = self.view.bounds.size.width;
        frame.size.height = CGRectGetHeight(self.view.bounds) - frame.origin.y;
        [self.categoryViewController setViewFrame: frame];

        CGRect bounds = self.categoryViewController.tableView.bounds;

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, bounds.size.width, 0)];
        animation.toValue = [NSValue valueWithCGRect:bounds];
        [self.categoryViewController viewWillAppear:NO];
        [self.view addSubview: self.categoryViewController.view];
        [self.categoryViewController.tableView.layer addAnimation:animation forKey:@"slidedown"];
    }
}

- (void)onSort:(UIButton *)sender
{
    [self.categoryViewController.view removeFromSuperview];
    if (self.sortViewController.view.superview) {
        [self.sortViewController.view removeFromSuperview];
    } else {
        CGRect frame = self.view.bounds;
        frame.origin.y = CGRectGetMaxY(sender.frame);
        frame.size.width = self.view.bounds.size.width;
        frame.size.height = CGRectGetHeight(self.view.bounds) - frame.origin.y;
        
        CGRect tableF = self.sortViewController.tableView.frame;
        tableF.origin.x = CGRectGetMidX(self.sortViewController.view.bounds);
        tableF.size.width = sender.frame.size.width;

        self.sortViewController.view.frame = frame;
        self.sortViewController.tableView.frame = tableF;
        CGRect bounds = self.sortViewController.tableView.bounds;
        CGRect boundsFrom = bounds;
        boundsFrom.size.height = 0;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        animation.fromValue = [NSValue valueWithCGRect:boundsFrom];
        animation.toValue = [NSValue valueWithCGRect:bounds];
        [self.sortViewController viewWillAppear:NO];
        [self.view addSubview: self.sortViewController.view];
        [self.sortViewController.tableView.layer addAnimation:animation forKey:@"slidedown"];
    }
}


#pragma mark - Accessors
- (void)setShowTipWhenEmpty:(BOOL)showTipWhenEmpty
{
    _showTipWhenEmpty = showTipWhenEmpty;
    self.dataSource.showTipWhenEmpty = showTipWhenEmpty;
}

- (void)setCurrentSortBy:(NSDictionary *)currentSortBy
{
    _currentSortBy = currentSortBy;
    [self.topbarView.sortButton setTitle:[currentSortBy valueForKey:@"name"]
                                forState:UIControlStateNormal];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[super scrollViewDidScroll:scrollView];

    //判断uitableview滑到了底，用来做分页显示
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
    {
        if (!self.reloadActionFlag) {
            self.reloadActionFlag = YES;
            [self loadMore];
        }
//        NSLog(@"hit bottom!");
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate) {
        self.reloadActionFlag = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.reloadActionFlag = NO;
}

#pragma mark - Data Loading
- (NSMutableDictionary *)currentParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:_currentParams];
    
    if (self.currentCategory) {
        NSMutableString *ID =[[self.currentCategory valueForKey:@"id"] mutableCopy];
        if (self.parentCategory) {
            [ID insertString:[[self.parentCategory valueForKey:@"id"] stringByAppendingString:@"@"]
                     atIndex:0];
        }
        [params setValue:ID
                  forKey:@"type"];
    }
    if (self.currentCity) {
        [params setValue:[self.currentCity valueForKey:@"id"]
                  forKey:@"city_id"];
    }
    if (self.sortBy) {
        params[@"orderby"] = self.sortBy;
    }
    return params;
}

- (void)loadData
{
    if (self.loading) return;
    self.loading = YES;
    self.currentPage = 1;

    //请求优惠列表
    
    NSURL *url_leixing = [NSURL URLWithString: TGURL(@"Tuan/goodsList", [self currentParams])];

    if ([self.products count] == 0) {
        [SVProgressHUD showWithStatus:LOADING_TEXT];
    }
    ASIHTTPRequest *request_leixing = [ASIHTTPRequest requestWithURL:url_leixing];
    [request_leixing setDelegate:self];
    [request_leixing startAsynchronous];
    [self.tableView reloadData];
}

- (void)loadMore
{
//    if (self.currentPage >= self.pageCount) return;
    if (self.loading) return;
    self.loading = YES;
    self.loadingMore = YES;
    NSURL *url_leixing = nil;
    //请求优惠列表
    NSDictionary *params = [self currentParams];
    [params setValue:@(++self.currentPage) forKey:@"page"];
    url_leixing = [NSURL URLWithString: TGURL(@"Tuan/goodsList", params)];

    self.tableView.tableFooterView = self.loadingFooter;
    [self.loadingFooter setLoading:YES];

    ASIHTTPRequest *request_leixing = [ASIHTTPRequest requestWithURL:url_leixing];
    [request_leixing setDelegate:self];
    [request_leixing startAsynchronous];
}

#pragma mark - Drag Refresh
- (void)onRefresh
{
    self.currentPage = 0;
    [self loadData];
}

#pragma mark - CityListViewControllerDelegate
- (void) citySelectionUpdate:(NSDictionary*)selectedCity
{
    if ([self.currentCity isEqualToDictionary:selectedCity]) return;
    [self.products removeAllObjects];
    [self.tableView reloadData];
    
    self.currentCity = selectedCity;
    [[NSUserDefaults standardUserDefaults] setObject:selectedCity forKey:kCityKey];
    NSString *cityName=selectedCity ? [selectedCity valueForKey:@"name"] : @"全部";
    CGSize size=[cityName sizeWithFont:self.chooseCity.titleLabel.font];
    self.chooseCity.width=size.width+20;
    UIImageView *icon=(UIImageView*)[self.chooseCity viewWithTag:1999];
    icon.left=self.chooseCity.width-12;
    icon.top=self.chooseCity.height/2-3;
    [self.chooseCity setTitle:cityName forState:UIControlStateNormal];
    [self loadData];
}

- (NSString*) getDefaultCity
{
    return [self.currentCity valueForKeyPath:@"name"];
}
- (NSString *)sortBy
{
    return self.currentSortBy[@"id"];
}

#pragma mark - Category
- (void)category:(CategoryViewController *)controller didSelect:(id)item
{
    [controller.view removeFromSuperview];
    if (controller == self.categoryViewController) {
        self.parentCategory = [(DoubleLevelCategoryViewController *)controller parentCategory];
        if ([item valueForKey:@"id"] == [NSNull null]) {item = nil;}
        if (item == self.currentCategory) return;
        NSString *title = item ? [item valueForKey:@"name"] : controller.name;
        [self.topbarView.categoryButton setTitle:title
                                        forState:UIControlStateNormal];
        self.currentCategory = item;
        [self loadData];
    } else {
        id sortBy = [item valueForKey:@"id"];
        if ([sortBy isKindOfClass:[NSNull class]]) {
            sortBy = nil;
        }        
        if (self.sortBy != sortBy) {
            self.currentSortBy = item;
            [self.tableView setContentOffset:CGPointZero animated:NO];
            [self loadData];
            [self.topbarView.sortButton setTitle:[item valueForKey:@"name"]
                                        forState:UIControlStateNormal];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark UISearchBar protocol delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    searchbar.showsScopeBar = YES;
    [searchbar sizeToFit];
    [searchbar setShowsCancelButton:YES animated:YES];
    
        
    if(search_background == nil)
        search_background = [[UIView alloc] initWithFrame:CGRectMake(0,44, 320, 460-44)];
    search_background.alpha = 0.0;
    search_background.backgroundColor = [UIColor blackColor];
    [self.view addSubview:search_background];
    
    
    //改变UISearchBar取消按钮字体
    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    
    /*******手势*********/
    UITapGestureRecognizer *serchviewmiss =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serchviewmiss)];

    // Set required taps and number of touches
    //
    [serchviewmiss setNumberOfTapsRequired:1];
    [serchviewmiss setNumberOfTouchesRequired:1];
    
    // Add the gesture to the view
    [search_background addGestureRecognizer:serchviewmiss];
    /******************/
    
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    search_background.alpha = 0.7;
    [UIView commitAnimations];
    
    
    return YES;
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
    //UISearchBar按钮上的取消事件
    [self serchviewmiss];
    
    searchBar.text = nil;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchbar.showsScopeBar = NO;
    [searchbar sizeToFit];
    [searchbar setShowsCancelButton:NO animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    return YES;
}

- (void)serchviewmiss
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    if(search_background!=nil)
        search_background.alpha = 0.0;
    [UIView commitAnimations];
    
    [searchbar resignFirstResponder];
}


//search代理delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"-------------%@--------",searchBar.text);
    NSString *url = nil;
    if (self.currentCity) {
        url = TGURL(@"Tuan/goodsList", @{@"key":searchBar.text});
    } else {
        url = TGURL(@"Tuan/goodsList",
                  @{@"key": searchBar.text,
                  @"city_id" : [self.currentCity valueForKey:@"id"]});
    }
    
    //请求优惠列表
    ASIHTTPRequest *request_leixing = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request_leixing setDelegate:self];
    [request_leixing startAsynchronous];
    
}

- (void)viewDidUnload {
    [self setTopbarView:nil];
    [super viewDidUnload];
}
@end
