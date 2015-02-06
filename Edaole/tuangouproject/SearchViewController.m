//
//  SearchViewController.m
//  tuangouproject
//
//  Created by liu song on 13-3-5.
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import "SearchViewController.h"
#import "ASIHTTPRequest.h"
#import "SVProgressHUD.h"
#import "NSDictionary+RequestEncoding.h"
#import "LoadingFooter.h"
#import "ProductCell.h"
#import "DetailViewController.h"
#import "ProductTableDataSource.h"
#import "UIButton+Conf.h"
#import "SearchKeywordModel.h"
#import "SearchKeywordView.h"

#define kThrottle (3600*24L)

static NSString * const LOADING_TEXT = @"加载中...";

@interface SearchViewController () <SearchKeywordViewDelegate, UISearchBarDelegate>
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger pageCount;
@property (strong, nonatomic) NSMutableArray *products;
@property (nonatomic, strong) LoadingFooter *loadingFooter;
@property (nonatomic, strong) ProductTableDataSource *dataSource;
@property (nonatomic, assign) BOOL searchState;
@property (strong, nonatomic) SearchKeywordModel *keywordModel;
@property (strong, nonatomic) SearchKeywordView  *keywordView;
@end

@implementation SearchViewController

@synthesize bar;
@synthesize searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSource = [ProductTableDataSource new];
        self.keywordModel = [SearchKeywordModel sharedInstance];
        [self.keywordModel loadFromNetwork];
        [self.keywordModel addObserver:self forKeyPath:@"rootObject" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [self.keywordModel removeObserver:self forKeyPath:@"rootObject"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchDisplayController.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.title = @"搜索";
    bar.tintColor = [UIColor barTintColor];
    
    self.navigationItem.leftBarButtonItem = self.backItem;

    searchBar.tintColor = [UIColor barTintColor] ?: [UIColor whiteColor];
    searchBar.delegate = self;
    self.loadingFooter = [[LoadingFooter alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 20)];
    UIButton *cancle=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    cancle.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancle setBackground:@"bar_button" highlight:@"bar_button_hilight"];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:cancle];
    self.tableView.dataSource = self.dataSource;
    
    SearchKeywordView *keywordView = [[SearchKeywordView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 0) edgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    keywordView.delegate = self;
    keywordView.keywords = (NSArray *)self.keywordModel.rootObject;
    [keywordView sizeToFit];
    self.tableView.tableHeaderView = keywordView;
    self.keywordView = keywordView;
}

- (IBAction)dismiss:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary *)currentParams
{
    return [@{@"key" : self.searchBar.text, @"page":@(self.currentPage)} mutableCopy];
}

- (void)loadData {
    if (self.loading) return;
    self.loading = YES;
    self.currentPage = 1;
    NSURL *url = nil;
    //请求团购列表
    
    url = [NSURL URLWithString:TGURL(@"Tuan/goodsList", [self currentParams])];
    if ([self.products count] == 0) {
        [SVProgressHUD showWithStatus:LOADING_TEXT];
    }
    ASIHTTPRequest *request_leixing = [ASIHTTPRequest requestWithURL:url];
    [request_leixing setDelegate:self];
    [request_leixing startAsynchronous];
    
//	[self reloadTableViewDataSource];
}

- (void)loadMore
{
    if (self.loading) return;
    self.loading = YES;
    self.currentPage += 1;
    NSURL *url = nil;
    //请求团购列表
    
    url = [NSURL URLWithString:TGURL(@"Tuan/goodsList", [self currentParams])];
    if ([self.products count] == 0) {
        [SVProgressHUD showWithStatus:LOADING_TEXT];
    }
    ASIHTTPRequest *request_leixing = [ASIHTTPRequest requestWithURL:url];
    [request_leixing setDelegate:self];
    [request_leixing startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.loading = NO;
    self.tableView.tableFooterView = nil;
    
    NSDictionary *rootDic = [request.responseData objectFromJSONData];
    
    if([[[rootDic objectForKey:@"status"] description] isEqualToString: @"1" ])
    {
        [SVProgressHUD dismiss];
        NSLog(@"---------cookies 验证成功～～----------");
        return;
    }
    
    if([[NSString stringWithFormat:@"%@", [rootDic objectForKey:@"status"]] isEqualToString: @"-1" ])
    {
        [SVProgressHUD dismiss];
        NSLog(@"---------cookies 验证失败～～----------");
        return;
    }
    
    if (self.currentPage == 1) {
        self.products = [[rootDic valueForKeyPath:@"result.data"] mutableCopy];
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
    if (self.products.count == 0) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat: @"没有找到和\"%@\"相关的优惠", self.searchBar.text]];
    } else {
        [self.searchBar endEditing:YES];
        [SVProgressHUD dismiss];
    }
    self.pageCount = [[rootDic valueForKeyPath:@"result.exitf.page_count"] integerValue];
    self.dataSource.products = self.products;
    [self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    self.loading = NO;
    //NSError *error = [request error];
    [SVProgressHUD dismiss];
    self.tableView.tableFooterView = nil;
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setBackItem:nil];
    [super viewDidUnload];
}

#pragma mark - KeywordViewDelegate
- (void)searchKeywordView:(SearchKeywordView *)keywordView didSelectKeyword:(NSString *)keyword
{
    self.searchBar.text = keyword;
    [self searchBarSearchButtonClicked:self.searchBar];
    self.tableView.tableHeaderView = nil;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.keywordView setKeywords:(NSArray*)self.keywordModel.rootObject];
    [self.tableView setNeedsLayout];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //判断uitableview滑到了底，用来做分页显示
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
    {
        [self loadMore];
        //        NSLog(@"hit bottom!");
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *headInfoViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    headInfoViewController.product = self.products[indexPath.row];
    
    headInfoViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:headInfoViewController animated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.products removeAllObjects];
    [self.tableView reloadData];
    [self loadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.tableView.tableHeaderView =  searchText.length == 0 ? self.keywordView : nil;
}

@end
