//
//  NearbyTableDataSource.m
//  tuangouproject
//
//  Created by cui on 13-5-31.
//
//

#import "NearbyTableDataSource.h"
#import "ProductCell.h"
@implementation NearbyTableDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCell *cell = (ProductCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    /*
    double range = [[self.products[indexPath.row] valueForKeyPath:kRange] doubleValue];
    NSString *unit = @"米";
    if (range >= 10000000) {
        range /= 10000000;
        unit = @"万公里";
    } else if (range >= 1000000) {
        range /= 1000000;
        unit = @"千公里";
    } else if (range >= 1000) {
        range /= 1000;
        unit = @"公里";
    }
    cell.rangeLabel.text = [NSString stringWithFormat: @"%.0lf%@", range, unit];
     */
    return cell;
}
@end
