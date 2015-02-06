//
//  DragRefreshViewController.m
//  tuangouproject
//
//  Created by cui on 13-6-7.
//
//

#import "DragRefreshViewController.h"
#import "SRRefreshView.h"

@interface DragRefreshViewController ()

@end

@implementation DragRefreshViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.tableView];
    }
    _refreshView = [[SRRefreshView alloc] init];
    self.refreshView.delegate = self;
    self.refreshView.slimeMissWhenGoingBack = YES;
    self.refreshView.slime.bodyColor = [UIColor barTintColor];
    self.refreshView.slime.skinColor = [UIColor whiteColor];
    self.refreshView.slime.lineWith = 1;
    self.refreshView.slime.shadowBlur = 4;
    self.refreshView.slime.shadowColor = [UIColor barTintColor];
    
    [self.tableView addSubview:self.refreshView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView scrollViewDidEndDraging];
}

#pragma mark - Refresh Control
- (void)endRefresh
{
    [self.refreshView endRefresh];
}

#pragma mark - SRRefreshViewDelegate
- (void)slimeRefreshStartRefresh:(SRRefreshView*)refreshView;
{
    if ([self respondsToSelector:@selector(onRefresh)]) {
        [self onRefresh];
    } else {
        [self endRefresh];
    }
}

@end
