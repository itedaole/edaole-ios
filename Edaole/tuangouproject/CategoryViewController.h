//
//  CategoryViewController.h
//  tuangouproject
//
//  Created by  na on .
//
//

#import <UIKit/UIKit.h>

@protocol CategoryViewControllerDelegate;

@interface CategoryViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *allItemName;
@property (strong, nonatomic) NSString *url;
@property (assign, nonatomic) id <CategoryViewControllerDelegate> delegate;
@property (strong, readonly, nonatomic) UITableView *tableView;
@property (strong, readonly, nonatomic) NSMutableArray *categories;

- (id)initWithURL:(NSString *)url;
- (void)setViewFrame:(CGRect)frame;
/* @property items
 array of dicts keys: id, name
 */
- (void)setItems:(NSArray*)items;

// for subclassing
- (void)tableView:(UITableView *)tableView setDataForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@protocol CategoryViewControllerDelegate <NSObject>

- (void)category:(CategoryViewController *)controller didSelect:(id)item;

@end

@interface NSDictionary (CategoryViewController)
+ (NSDictionary *)dictWithId:(id)id name:(NSString *)name;
@end