//
//  CategoryViewController.m
//  tuangouproject
//
//  Created by  na on .
//
//

#import "CategoryViewController.h"
#import "ASIHTTPRequest.h"

@interface CategoryViewController () <ASIHTTPRequestDelegate>
@property (unsafe_unretained, nonatomic) ASIHTTPRequest *req;
@property (strong, nonatomic) NSMutableArray *categories;
@end

@implementation CategoryViewController

- (id)initWithURL:(NSString *)url
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)dealloc
{
    [self.req cancel];
}

- (void)loadView
{
    UIButton *btn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [btn addTarget:self action:@selector(onHide:) forControlEvents:UIControlEventTouchUpInside];
    self.view = btn;
}

- (void)setViewFrame:(CGRect)frame
{
    self.view.frame = frame;
    self.tableView.height = self.view.height;
}

- (void)onHide:(id)sender
{
    [self.view removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    CGRect f = self.view.bounds;
    f.size.width /= 2;
    _tableView = [[UITableView alloc] initWithFrame:f style:UITableViewStylePlain];
    _tableView.layer.anchorPoint = CGPointMake(0.5,0);
    self.tableView.frame = f;
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 35;
    [self.view addSubview:self.tableView];

    self.tableView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
    self.tableView.layer.borderWidth = 1.0f;

    if (self.url) {
        if (!self.req) {
            ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.url]];
            req.delegate = self;
            self.req = req;
            [req startAsynchronous];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.req && self.url) {
        ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.url]];
        req.delegate = self;
        self.req = req;
        [req startAsynchronous];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)categories
{
    if (nil == _categories) {
        _categories = [@[@{@"id":[NSNull null], @"name":self.allItemName}] mutableCopy];
    }
    return _categories;
}

- (void)setItems:(NSArray*)items
{
    [self.categories removeAllObjects];
    [self.categories addObject:[NSDictionary dictWithId:nil name:self.allItemName]];
    [self.categories addObjectsFromArray:items];
    [self.tableView reloadData];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.req = nil;
    NSDictionary *resp = [request.responseData objectFromJSONData];
    if ([[resp valueForKey:@"status"] integerValue] == 1) {
        NSArray *newCategories = [resp valueForKey:@"result"];
        
        if (! [[self.categories subarrayWithRange:NSMakeRange(1, self.categories.count -1)] isEqualToArray:newCategories]) {
            self.categories = [newCategories mutableCopy];
            [self.categories insertObject:@{@"id":[NSNull null], @"name":self.allItemName} atIndex:0];
            [self.tableView reloadData];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    self.req = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (void)tableView:(UITableView *)tableView setDataForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    id obj = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.text = [obj valueForKey:@"name"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    [self tableView:tableView setDataForCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate category:self didSelect:[self.categories objectAtIndex:indexPath.row]];
}

#pragma mark -
- (void)load
{
    
}

- (void)save
{
    
}

@end

@implementation NSDictionary (CategoryViewController)
+ (NSDictionary *)dictWithId:(id)id name:(NSString *)name
{
    id = id ? id : [NSNull null];
    return @{@"id": id, @"name" : name};
}
@end