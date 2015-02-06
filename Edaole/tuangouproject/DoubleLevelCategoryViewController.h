//
//  DoubleLevelCategoryViewController.h
//  tuangouproject
//
//  Created by cui on 13-5-31.
//
//

#import "CategoryViewController.h"

@interface DoubleLevelCategoryViewController : CategoryViewController
@property (strong, readonly, nonatomic) UITableView *secondTableView;
@property (strong, nonatomic) id parentCategory;

@end
