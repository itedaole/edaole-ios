//
//  ListViewController.h
//  tuangouproject
//
//  Created by liu song on 13-3-5.
//  Copyright (c) 2013年 liu song. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EGORefreshTableHeaderView.h"
#import "UIImageView+WebCache.h"
#import "CityListViewController.h"
#import "CategoryViewController.h"
#import "CategoryView.h"
#import "DragRefreshViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ListViewController : DragRefreshViewController
<CityListViewControllerProtocol, CLLocationManagerDelegate, UISearchBarDelegate,
CategoryViewControllerDelegate>
{
    IBOutlet UISearchBar *searchbar;
    CLLocationManager *_manager;
    UIView *search_background;
}
@property (assign, nonatomic) BOOL hidesTopMenu;
@property BOOL loading; // network loading
@property BOOL doLocate;
@property (nonatomic, strong) NSMutableArray *products;
@property (unsafe_unretained, nonatomic) IBOutlet CategoryView *topbarView;
@property (nonatomic, readonly) CategoryViewController *sortViewController;
@property (strong, nonatomic) NSMutableDictionary *currentParams;
@property (nonatomic, strong) NSDictionary *currentCategory;
@property (nonatomic, strong) NSDictionary *currentSortBy;
//@property (nonatomic, strong) NSString *sortBy;
@property (nonatomic,strong)UIButton *chooseCity;
@property (nonatomic, assign) BOOL showTipWhenEmpty;

+ (Class)dataSourceClass; // for subclassing
- (void)loadData;
- (void)showProductDetail:(id)product;
- (void)showProductDetailWithId:(id)productId;
@end
