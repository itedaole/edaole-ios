//
//  CityListViewController.m
//
//  Created by Big Watermelon on 11-11-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CityListViewController.h"
#import "ASIHTTPRequest.h"
#import "pinyin.h"
#import "SVProgressHUD.h"
//#import "EGORefreshTableHeaderView.h"

@interface CityListViewController () <ASIHTTPRequestDelegate, SRRefreshDelegate>
{
    SRRefreshView *_refreshHeaderView;
}
@property (nonatomic, strong) UIImageView* checkImgView;
@property NSUInteger curSection;
@property NSUInteger curRow;
@property NSUInteger defaultSelectionRow;
@property NSUInteger defaultSelectionSection;
@property (strong, nonatomic) ASIHTTPRequest *req;
@property (strong, nonatomic) NSDate *lastUpdate;
@property (strong, nonatomic) NSInvocation *autoCitySelectionInvocation;
@end

@implementation CityListViewController
@synthesize tbView;

#define CHECK_TAG 1110

static NSString * g_filePath = nil;
NS_INLINE NSString * filePath(void)
{
    if (nil == g_filePath) {
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        g_filePath = [cachePath stringByAppendingPathComponent:@"/city.plist"];
    }
    return g_filePath;
}

@synthesize cities, keys, checkImgView, curSection, curRow, delegate;
@synthesize defaultSelectionRow, defaultSelectionSection;
@synthesize bar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    self.req.delegate = nil;
    [self.req cancel];    
}

- (void)loadFromFile
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath()];
    if (dict) {
        self.keys = dict[@"keys"];
        self.cities = dict[@"cities"];
        NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath() error:nil];
        if (attr) {
            self.lastUpdate = attr[NSFileModificationDate];
        }
    }
}

- (void)saveToFile
{
    [@{@"cities": self.cities, @"keys":self.keys} writeToFile:filePath() atomically:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Data
- (void)findAndSelectCity:(NSString *)cityName
{
    if (!cityName) return;
    if (self.cities.count <= 1) {
        NSInvocation *invok = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(findAndSelectCity:)]];
        invok.selector = @selector(findAndSelectCity:);
        invok.target = self;
        [invok setArgument:&cityName atIndex:2];
        self.autoCitySelectionInvocation = invok;
        [self loadCityList];
        return;
    }
    self.autoCitySelectionInvocation = nil;
    NSInteger selectionRow = NSNotFound;
    NSInteger selectionSection = NSNotFound;
    NSArray *citySection;
    for (NSString* key in self.keys) {
        citySection = [cities objectForKey:key];
        for (NSInteger i = 0; i < citySection.count; ++i) {
            NSString *n = [citySection objectAtIndex:i][@"name"];
            if ([cityName hasPrefix:n] || [n hasPrefix:cityName]) {
                selectionRow = i;
                break;
            }
        }
        if (NSNotFound == selectionRow)
            continue;
        //found match recoard position
        selectionSection = [self.keys indexOfObject:key];
        break;
    }
    if (selectionRow != NSNotFound && selectionSection != NSNotFound) {
        NSString* key = [keys objectAtIndex:selectionSection];
        id city = [[cities objectForKey:key] objectAtIndex:selectionRow];
        [delegate citySelectionUpdate:city];
    }
}

- (void)loadCityList
{
    [SVProgressHUD showWithStatus:@"载入中..."];
    self.req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:TGURL(@"Tuan/cityList", nil)]];
    [self.req setDelegate:self];
    [self.req startAsynchronous];
}

- (void)selectCurrentCity
{
    NSString* defaultCity = [delegate getDefaultCity];
   
    if (defaultCity) {
        NSArray *citySection;
        self.defaultSelectionRow = NSNotFound;
        //set table index to this city if it existed
        for (NSString* key in self.keys) {
            citySection = [cities objectForKey:key];
            self.defaultSelectionRow = [[citySection valueForKeyPath:@"name"] indexOfObject:defaultCity];
            if (NSNotFound == defaultSelectionRow)
                continue;
            //found match recoard position
            self.defaultSelectionSection = [self.keys indexOfObject:key];
            break;
        }
    }
    
    
    [self.tbView reloadData];
    if (NSNotFound != defaultSelectionRow) {
        
        self.curSection = defaultSelectionSection;
        self.curRow = defaultSelectionRow;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:defaultSelectionRow inSection:defaultSelectionSection];
        [self.tbView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.req = nil;
    self.lastUpdate = [NSDate date];
    [SVProgressHUD dismiss];

    NSDictionary *resp = [request.responseData objectFromJSONData];
    if ([[resp valueForKey:@"status"] integerValue] != 1) {
        return;
    }

    NSArray *cityList = [resp valueForKey:@"result"];
    
    self.cities = [NSMutableDictionary dictionaryWithCapacity:32];
    for (NSDictionary *item in cityList) {
        char cap = pinyinFirstLetter([[item valueForKey:@"name"] characterAtIndex:0]);
        NSString *k = [NSString stringWithFormat:@"%c", cap];
        NSMutableArray *arr = [self.cities valueForKey:k];
        if (![arr isKindOfClass:[NSMutableArray class]]) {
            arr = [[NSMutableArray alloc] initWithCapacity:8];
            [self.cities setValue:arr forKey:k];
        }
        [arr addObject:item];
    }
    self.keys = [[self.cities allKeys] sortedArrayUsingSelector:
                 @selector(compare:)];
    NSMutableArray *tkeys = [self.keys mutableCopy];
    [tkeys insertObject:@" " atIndex:0];
    self.keys = tkeys;
    NSArray *arr = [NSArray arrayWithObject:@{@"name": @"全部"}];
    [self.cities setValue:arr forKey:@" "];
    
    [self selectCurrentCity];
    [_refreshHeaderView endRefresh];
    //    if (self.autoCitySelectionInvocation) {
//        [self.autoCitySelectionInvocation invoke];
//    }
    [self saveToFile];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [_refreshHeaderView endRefresh];
    self.req = nil;
    [SVProgressHUD dismiss];
}


- (void)onCancel
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        bar.height = 64;
        for (UIView *v in self.view.subviews) {
            if (v == bar) continue;
            v.top += 20;
            if (CGRectGetMaxY(v.frame) > self.view.height) {
                v.height = self.view.height - v.top;
            }
        }
    }
    
    UIButton *cancel = [UIButton cancelButtonWithTarget:self action:@selector(onCancel)];
    self.bar.topItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:cancel];
    
    _refreshHeaderView = [[SRRefreshView alloc] init];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.slimeMissWhenGoingBack = YES;
    _refreshHeaderView.slime.bodyColor = [UIColor barTintColor];
    _refreshHeaderView.slime.skinColor = [UIColor whiteColor];
    _refreshHeaderView.slime.lineWith = 1;
    _refreshHeaderView.slime.shadowBlur = 4;
    _refreshHeaderView.slime.shadowColor = [UIColor barTintColor];

    [tbView addSubview:_refreshHeaderView];
    
    [self loadFromFile];
    
    curRow = NSNotFound;
    

    bar.tintColor = [UIColor colorWithRed:240/255.0 green:40/255.0 blue:90/255.0 alpha:1.0];

    UIImageView *temp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    self.checkImgView = temp;
    checkImgView.tag = CHECK_TAG;
    if (self.keys == nil || self.cities == nil) {
        [self loadCityList];
    } else {
        [self selectCurrentCity];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.keys = nil;
    self.cities = nil;
    self.checkImgView = nil;
    self.tbView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onUnlimit:(id)sender
{
    [self.delegate citySelectionUpdate:nil];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [keys objectAtIndex:section];  
    NSArray *citySection = [cities objectForKey:key];
    return [citySection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSString *key = [keys objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    } else {
        /*
        for (UIView *view in cell.contentView.subviews) {
            if (view.tag == CHECK_TAG) {
                if (indexPath.section != curSection || indexPath.row != curRow)
                    checkImgView.hidden = true;
                else
                    checkImgView.hidden = false;
            }
        }*/
    }
    
    // Configure the cell...
    id info = [[cities objectForKey:key] objectAtIndex:indexPath.row];
    cell.textLabel.text = [info valueForKey:@"name"];
    
    if (indexPath.section == curSection && indexPath.row == curRow)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{  
    NSString *key = [keys objectAtIndex:section];  
    return key;  
}  

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView  
{  
    return keys;  
} 
#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView scrollViewDidEndDraging];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //clear previous
    NSIndexPath *prevIndexPath = [NSIndexPath indexPathForRow:curRow inSection:curSection];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:prevIndexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    curSection = indexPath.section;
    curRow = indexPath.row;
    
    //add new check mark
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self pressReturn:nil];
}

- (IBAction)pressReturn:(id)sender {
    //notify delegate user selection if it different with default
    if (curRow != NSNotFound) {
        id city = nil;
        if (curSection > 0) {
            NSString* key = [keys objectAtIndex:curSection];
            city = [[cities objectForKey:key] objectAtIndex:curRow];
        }
        [delegate citySelectionUpdate:city];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}
/*
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self loadCityList];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return nil != self.req;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return self.lastUpdate;
}
 */
@end
