//
//  OrderListViewController.m
//  tuangouproject
//
//  Created by stcui on 14-1-12.
//
//

#import "OrderListViewController.h"
#import "TuanQuanCustomCell.h"
#import "BaseViewController.h"
#import "Order.h"
#import "DetailViewController.h"
#import "ViewControllerManager.h"

NS_INLINE NSString *stringfy(id str) {
    if (str == [NSNull null] || str == nil) return @"";
    return [str description];
}

@interface OrderListViewController ()

@end

@implementation OrderListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 65;
    self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self listTableViewCellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *order = self.orders[indexPath.row];
    DetailViewController *controller = (DetailViewController*)[ViewControllerManager.sharedInstance detailViewController];
    controller.hidesBottomBarWhenPushed = YES;
    controller.product = order[@"team"];
//    ConfirmViewController *controller = [[ConfirmViewController alloc] initWithNibName:nil bundle:nil];
//    controller.hidesBottomBarWhenPushed = YES;
//    controller.product =
//    controller.count = [order[@"quantity"] integerValue];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UITableViewCell *)listTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    
    TuanQuanCustomCell *cell = (TuanQuanCustomCell *)[self.tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TuanQuanCustomCell" owner:self options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hang_xz.png"]];
    }
    
    NSDictionary *coupon = [self.orders objectAtIndex:indexPath.row];
    
    NSString *url;
    
    if ([[coupon valueForKeyPath:kCouponCDNImage] length]>0) {
        url=stringfy([coupon valueForKeyPath:kCouponCDNImage]);
    }else{
        url=ImageURL(stringfy([coupon valueForKeyPath:kCouponImage]));
    }
    
    [cell.listimageview sd_setImageWithURL:[NSURL URLWithString:url]];
    cell.nameLabel.text = stringfy([coupon valueForKeyPath:@"team.partner.title"]);// [self.titlearray objectAtIndex:row];
    
    cell.sellerLabel.text = [coupon valueForKeyPath:kCouponProduct];
    cell.value.text = [NSString stringWithFormat:@"有效期: %@前",[self convertStringTimestamp: coupon[kExpireTime] ]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

-(NSString *)convertStringTimestamp:(NSString *)time
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

@end
