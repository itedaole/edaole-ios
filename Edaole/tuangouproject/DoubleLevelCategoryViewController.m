//
//  DoubleLevelCategoryViewController.m
//  tuangouproject
//
//  Created by cui on 13-5-31.
//
//

#import "DoubleLevelCategoryViewController.h"

@interface DoubleLevelCategoryViewController ()
@property (strong, nonatomic) UITableView *secondTableView;
@property (strong, nonatomic) NSArray *subCategories;
@end

@implementation DoubleLevelCategoryViewController
- (UITableView *)secondTableView
{
    if (nil == _secondTableView) {
        CGRect frame = self.tableView.frame;
        frame.origin.x = self.view.width - frame.size.width;
        _secondTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _secondTableView.dataSource = self;
        _secondTableView.delegate = self;
        _secondTableView.rowHeight = self.tableView.rowHeight;
        _secondTableView.separatorStyle = self.tableView.separatorStyle;
    }
    return _secondTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    return [self.subCategories count];
}

- (void)tableView:(UITableView *)tableView setDataForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        [super tableView:tableView setDataForCell:cell atIndexPath:indexPath];
    } else {
        cell.textLabel.text = [self.subCategories[indexPath.row] valueForKey:@"name"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.secondTableView) {
        [self.delegate category:self didSelect:[self.subCategories objectAtIndex:indexPath.row]];
    } else {
        NSDictionary *parent = self.categories[indexPath.row];
        NSArray *sub = [parent valueForKey:@"subClasss"];
        if ([sub isKindOfClass:[NSArray class]] && [sub count] > 0) {
            self.parentCategory = parent;
            [self.view addSubview:self.secondTableView];
            self.subCategories = sub;
            [self.secondTableView reloadData];
        } else {
            self.parentCategory = nil;
            [self.secondTableView removeFromSuperview];
            [self.delegate category:self didSelect:parent];
        }
    }
}

@end
