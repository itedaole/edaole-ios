//
//  MainListViewController.m
//  tuangouproject
//
//  Created by stcui on 14-1-1.
//
//

#import "MainListViewController.h"
#import "CatalogView.h"
#import "CategoryModel.h"

@interface MainListViewController () <CatalogViewDelegate>

@end

@implementation MainListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentSortBy = @{@"id":@"begin_time", @"name" : @"开始时间↓"};
    }
    return self;
}

inline static UIImage *image(int i) {
    return [UIImage imageNamed:[NSString stringWithFormat:@"category_%d", i]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[CategoryModel sharedInstance] addObserver:self forKeyPath:@"rootObject" options:NSKeyValueObservingOptionNew context:NULL];
    CatalogView *catalogView = [[[NSBundle mainBundle]loadNibNamed:@"CatalogView" owner:nil options:nil] lastObject];
    catalogView.delegate = self;
    self.tableView.tableHeaderView = catalogView;
    [self generateHeader];
    /*
    catalogView.items = @[
                          @[image(1), @"美食"],
                          @[image(2), @"美食"],
                          @[image(3), @"美食"],
                          @[image(4), @"美食"],
                          @[image(5), @"美食"],
                          @[image(6), @"美食"],
                          @[image(7), @"美食"],
                          @[image(8), @"美食"],
                          ];
     */
}

- (void)dealloc
{
    [[CategoryModel sharedInstance] removeObserver:self forKeyPath:@"rootObject"];
}

- (void)catalogView:(CatalogView *)view didItem:(NSArray *)item index:(NSInteger)index
{
    ListViewController *nextController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    nextController.hidesBottomBarWhenPushed = YES;

    if (index == 0) {// 头两个是全部与今日新单
//        nextController.currentCategory = @{@"id":[NSNull null], @"name": @"全部"};
    } else if (index == 1) {
        nextController.currentSortBy = @{@"id": @"begin_time", @"name": @"开始时间↓"};
    } else {
        nextController.currentCategory = [[CategoryModel sharedInstance].rootObject objectAtIndex:index-2];
    }
    [self.navigationController pushViewController:nextController animated:YES];
}

- (void)generateHeader
{
    int i = 0;
    NSArray *types = (NSArray *)[[CategoryModel sharedInstance]rootObject];
    
//    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:
//                             @[image((i++)+1), @"全部"],
//                             @[image((i++)+1), @"今日新单"],
//                             nil];
    
    NSMutableArray *items = [NSMutableArray array];
    NSInteger count = types.count;
    for (NSInteger j = 0; j < count && i < 8; ++j, ++i) {
        NSString *name  = types[j][@"name"];
        if (name) {
            [items addObject:@[image(i+3), name]];
        }
    }
    [(CatalogView *)self.tableView.tableHeaderView setItems:items];
    // relayout
    UIView *headerView = self.tableView.tableHeaderView;
    self.tableView.tableHeaderView = headerView;
//    [self.tableView setNeedsLayout];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self generateHeader];
}

- (void)onRefresh
{
    [super onRefresh];
    [[CategoryModel sharedInstance] loadFromNetwork];
}

@end
