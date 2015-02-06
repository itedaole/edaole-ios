//
//  ProductTableDataSource.h
//  tuangouproject
//
//  Created by na on 13-4-5.
//
//

#import <Foundation/Foundation.h>

@interface ProductTableDataSource : NSObject <UITableViewDataSource>
@property (unsafe_unretained, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *products;
@property (assign, nonatomic) BOOL showTipWhenEmpty;
@end
