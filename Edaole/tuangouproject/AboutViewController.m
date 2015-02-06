//
//  AboutViewController.m
//  SUSHIDO
//
//  Created by song liu on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "YijianViewController.h"
#import "ScannerViewController.h"
#import "TGURL.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"
#import "WebViewController.h"
#import "UIAlertView+Blocks.h"

@interface AboutViewController () <LoginViewControllerDelegate>
@property (nonatomic) BOOL shopDidLogin;
@property (nonatomic) NSDictionary * shop;
@end

@implementation AboutViewController
{
    ASIHTTPRequest *_checkUpdateReq;
}
@synthesize logincontroller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"更多|setting_h";
        self.navigationItem.title=@"更多";
        
        UIImage *imageTab = [UIImage imageNamed:@"setting.png"];
		self.tabBarItem.image = imageTab;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	
	tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                             style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor whiteColor];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	tableView.scrollEnabled = YES;
	[tableView setBackgroundColor:[UIColor clearColor]];

	[tableView reloadData];
	[self.view addSubview:tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *homepage = bundleInfo[@"Homepage"];
    NSString *weibo    = bundleInfo[@"Weibo"];
    
    namearray = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"软件版本    %@",[self getVersion]],
                 [NSString stringWithFormat: @"官网            %@", homepage],
                 @"商户登录", nil];
    
    if([weibo length]>10){
        [namearray addObject:[NSString stringWithFormat: @"官方微博      %@", weibo]];
    }
    
    namearray2 = [[NSMutableArray alloc] initWithObjects:@"意见反馈", nil];
    namearray3 = [[NSMutableArray alloc] initWithObjects:@"关于",@"检测更新", nil];
}

- (NSString *)getVersion
{
    NSString *ver = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    return ver;
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSUInteger row = [indexPath row];
    
    //    if (tvCell != nil) {
    //        [tvCell release];
    //    }
    
	//if (tvCell == nil) {
    UITableViewCell *tvCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"feedsListViewCell"];
	//}
	
    
    if(indexPath.section == 0)
    {
        tvCell.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
        if (row < namearray.count) {
            tvCell.textLabel.text = [NSString stringWithFormat:@"%@",[namearray objectAtIndex:row]];
        } else {
            tvCell.textLabel.text = @"消费优惠卷";
        }
        tvCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    else if(indexPath.section == 1)
    {
        /*
        tvCell.textLabel.text = [NSString stringWithFormat:@"%@",[namearray2 objectAtIndex:row]];
        tvCell.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
         */
        tvCell.textLabel.text = @"清除缓存";
    }
    else if(indexPath.section == 2){
        tvCell.textLabel.text = [NSString stringWithFormat:@"%@",[namearray3 objectAtIndex:row]];
        
    }
    else if(indexPath.section == 3)
    {
        tvCell.textLabel.text = [NSString stringWithFormat:@"退出登录"];
        //tvCell.textLabel.textAlignment = UITextAlignmentCenter;
        //tvCell.backgroundColor = [UIColor redColor];
        //tvCell.textLabel.textColor = [UIColor whiteColor];
    }
    else 
    {
        
    }
    
    [tvCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [tvCell setAccessoryType:UITableViewCellAccessoryNone];
    
    return tvCell;
	//	}
	//}
	//tvCell.textLabel.text = @"Mise à jour...";
	
	//return tvCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return 48.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tView {
	return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"关于";
    }
    else if (section == 1){
        return @"";
    }
    else if(section == 2){
        return @"";
    }
    else {
        return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 4+self.shopDidLogin;
    else if(section == 1)
        return 1;
    else if(section == 2)
        return 2;
    else if(section == 3)
        return 1;
    else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];	

    int row = [indexPath row];
    
    if (indexPath.section == 0) {
        
        //版本检测
        if(row == 0)
        {
            UIAlertView *uialert = [[UIAlertView alloc] initWithTitle:@"" message:@"当前已是最新版本" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil,nil];
            //uialert.delegate = self;
            [uialert show];
        }
        
        //商户登录
        if(row == 2)
        {
/*这是要干啥~~~
#ifdef DEBUG
            ScannerViewController *scanner = [[ScannerViewController alloc]  initWithDelegate:nil showCancel:YES OneDMode:NO];
            
            [self.view.window.rootViewController presentModalViewController:scanner animated:YES];
            return;
#endif
 */
            if (self.shopDidLogin) {
                namearray[3]=@"商户登录";
                self.shopDidLogin=!self.shopDidLogin;
                [tView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [NSData dataWithContentsOfURL:[NSURL URLWithString:TGURL(@"Partner/logout", nil)]];
                });
                [self performBlock:^{
                    [tableView reloadData];
                } afterDelay:0.3];
                return;
            }
            LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            login.showSNSLogin = NO;
            login.delegate = self;
            login.loginAction = @"Partner/login";
            [self.view.window.rootViewController presentModalViewController:login animated:YES];
            [login isNormalUser:NO];
            login.title=@"商户登录";
        } else if (row >= namearray.count) {
//            ScannerViewController *scanner = [[ScannerViewController alloc]  initWithDelegate:nil showCancel:YES OneDMode:NO];
//           
//            [self.view.window.rootViewController presentModalViewController:scanner animated:YES];

        }           
        return;
    }
    else if (indexPath.section == 1) {
        
        if(row == 0)
        {
            [SVProgressHUD show];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [[SDImageCache sharedImageCache] clearDisk];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"清理完成"];
                });
            });

            /*
            YijianViewController *temp = [[YijianViewController alloc]initWithNibName:@"YijianViewController" bundle:nil];
            [self.navigationController pushViewController:temp animated:YES];
             */
        }
        
        
    }
    else if(indexPath.section == 2)
    {
        if(row == 0)
        {
            NSString *urlStr = TGURL(@"Pages/help", nil);
            WebViewController *webViewController = [[WebViewController alloc] init];
            webViewController.hidesBottomBarWhenPushed = YES;
            [webViewController setUrl:urlStr];
            [self.navigationController pushViewController:webViewController animated:YES];
        } else if (row == 1) {
            // 检测更新
           
            NSString *ver = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
            NSString *urlStr = TGURL(@"Index/checkUpdate", @{@"ver":ver});
            [SVProgressHUD showWithStatus:@"检测中..."];
            _checkUpdateReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
            __weak __typeof(self) wself = self;
            [_checkUpdateReq setCompletionBlock:^{
                __strong AboutViewController *sself = wself;
                NSDictionary *resp = [sself->_checkUpdateReq.responseData objectFromJSONData];
                NSDictionary *data = resp[@"data"];
                if (data && [data[@"update"] boolValue]) {
                    NSDictionary *obj = data[@"description"];
                    NSString *ver = obj[@"ver"];
                    NSString *desc = [obj[@"description"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                    NSString *url = obj[@"url"];
                    NSString *message = [NSString stringWithFormat:@"最新版本: %@\n%@", ver, desc];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有版本更新" message:message delegate:sself cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                    [SVProgressHUD dismissWithCompletion:^{
                        [alert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex != alertView.cancelButtonIndex) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                            }
                        }];
                    }];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"已经是最新版"];
                }
                
                sself->_checkUpdateReq = nil;

            }];
            [_checkUpdateReq startAsynchronous];
        }
    }
    else if(indexPath.section == 3)
    {
        
    }
    else 
    {
        
    }
}



- (void)loginViewController:(LoginViewController *)controller finishedWithObject:(id)obj success:(BOOL)success
{
    self.shopDidLogin = success;
    self.shop = [obj valueForKeyPath:@"result"];
    namearray[3]=@"注销商户登录";
    [tableView reloadData];
}

@end
