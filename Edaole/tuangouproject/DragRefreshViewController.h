//
//  DragRefreshViewController.h
//  tuangouproject
//
//  Created by cui on 13-6-7.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SRRefreshView.h"

@interface DragRefreshViewController : BaseViewController
<UITableViewDelegate, SRRefreshDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (readonly, strong, nonatomic) SRRefreshView *refreshView;
- (void)endRefresh;


@end

@interface DragRefreshViewController (Override)
- (void)onRefresh;
@end
