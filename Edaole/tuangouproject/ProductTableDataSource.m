//
//  ProductTableDataSource.m
//  tuangouproject
//
//  Created by na on 13-4-5.
//
//

#import "ProductTableDataSource.h"
#import "ProductCell.h"
#import "UIImageView+WebCache.h"

#define kThrottle (3600*24L)

@implementation ProductTableDataSource

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.tableView = tableView;
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.products.count;
    if (count == 0) return self.showTipWhenEmpty;
    return self.products.count;// [self.titlearray count];
}

- (void)confiureDataCell:(ProductCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *good = [self.products objectAtIndex:indexPath.row];
    
    NSString *imageURL;
    if ([good[kCNDLargeImage] length]>0) {
        imageURL = good[kCNDLargeImage];
    }else{
        imageURL = ImageURL(good[kImage]);
        NSRange dot = [imageURL rangeOfString:@"." options:NSBackwardsSearch];
        if (dot.location != NSNotFound) {
            imageURL = [imageURL stringByReplacingCharactersInRange:dot withString:@"_index."];
        }
    }
    
    //    [cell.listimageview setImageWithURL:[NSURL URLWithString:imageURL]];
    
    [cell.listimageview sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    cell.nameLabel.text = good[kProductName];// [self.titlearray objectAtIndex:row];
    cell.boughtLabel.text =  [NSString stringWithFormat:@"%@人",good[kBoughtCount]];
    cell.summary.text = [NSString stringWithFormat:@"%@",good[kSummary]];
    if (good[@"team_jybt"]) {
        cell.summary.text = good[@"team_jybt"];
        cell.nameLabel.text = [good valueForKeyPath:kSellerName];
    }
    cell.price.text = [NSString stringWithFormat:@"%g",[good[kCurrentPrice] floatValue]];
    [cell.price sizeToFit];
    cell.value.left = cell.price.right + 5;
    cell.value.text = [NSString stringWithFormat:@"%g元",[good[kOrigPirce] floatValue]];
    [cell.value sizeToFit];
    cell.deleteLine.width = cell.value.width+2;
    cell.deleteLine.left = cell.value.left - 1;
    NSInteger beginTime=[[good valueForKey:@"begin_time"] intValue];
    cell.neuImage.hidden=[[NSDate date] timeIntervalSince1970]-beginTime<(kThrottle)?NO:YES;
}

//// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    ProductCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    [self confiureDataCell:cell atIndexPath:indexPath];
    return cell;
    
#warning 这地方没有复用cell，容易导致内存警告，并且逻辑比较乱，我重新写，故在这地方设置个warning
//    NSString *cellIdentifier = nil;
//    if (self.products.count == 0) {
//        cellIdentifier = @"EmptyCell";
//    } else {
//        cellIdentifier  = @"ProductCell";
//    }
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: cellIdentifier];
//    if (cell == nil){
//        if ([cellIdentifier isEqualToString:@"ProductCell"]) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProductCell class]) owner:self options:nil] lastObject];
//        } else {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            cell.textLabel.textAlignment = NSTextAlignmentCenter;
//            cell.textLabel.font = [UIFont systemFontOfSize:17];
//        }
//        cell.selectedBackgroundView = [UIView cellBackground];
//    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 180;
}

@end
