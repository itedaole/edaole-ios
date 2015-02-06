//
//  NearbyViewController.m
//  tuangouproject
//
//  Created by cui on 13-5-26.
//
//

#import "NearbyViewController.h"
#import "SVProgressHUD.h"
#import "NearbyTableDataSource.h"
#import "UIBarButtonItem+Factory.h"
#import "ViewControllerManager.h"
#import "GeoConverter.h"

@interface NearbyViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *reverseGeocoder;
@property (strong, nonatomic) UILabel *userLocationView;
@end

@implementation NearbyViewController

+ (Class)dataSourceClass
{
    return [NearbyTableDataSource class];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;

        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (status == kCLAuthorizationStatusNotDetermined) {
                [_locationManager requestWhenInUseAuthorization];
            } else if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务被禁用" message:@"查看您附近的优惠" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
                [alert show];
            } /*else if (status == 4 kCLAuthorizationStatusAuthorizedWhenInUse) {
                [_locationManager requestAlwaysAuthorization];
            }*/
        }

        self.locationManager.desiredAccuracy = 100;
        self.reverseGeocoder = [[CLGeocoder alloc] init];
        self.tabBarItem.title = @"附近|nearby_h.png";
        self.tabBarItem.image = [UIImage imageNamed:@"nearby.png"];
    }
    
    return self;
}

#pragma mark - View
- (void)createUserLocationView
{
    UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    view.font = [UIFont systemFontOfSize:12];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleWidth;
    view.textAlignment = NSTextAlignmentLeft;
    view.textColor = [UIColor whiteColor];
    self.userLocationView = view;
}

- (void)setUserLocationString:(NSString *)string
{
    if (string.length > 0) {
        if (nil == self.userLocationView) {
            [self createUserLocationView];
            [self.view addSubview:self.userLocationView];
        }
        self.userLocationView.hidden = NO;
        self.userLocationView.bottom = self.view.height;
        self.userLocationView.text = [@" " stringByAppendingString: string];
    } else {
        self.userLocationView.hidden = YES;
    }
}

#pragma mark - DataLoading
- (NSMutableDictionary *)currentParams
{
    NSMutableDictionary *params = [super currentParams];
    params[@"lat"] = @(self.locationManager.location.coordinate.latitude);
    params[@"lng"] = @(self.locationManager.location.coordinate.longitude);
    params[@"orderby"]=@"range";
    params[@"coordType"]=@"Mars";//期望获取坐标系
    return params;
}

- (BOOL)isCoordinateValid
{
    CLLocation *location = self.locationManager.location;
    
    return ([location.timestamp timeIntervalSinceNow] > - 30 && // 30 seconds
            CLLocationCoordinate2DIsValid(location.coordinate) &&
            location.coordinate.latitude != 0 &&
            location.coordinate.longitude != 0);
}

- (void)loadData
{
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"定位失败" message:@"无法获取用户位置,请到设置中许可软件获取位置" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            if ([self isCoordinateValid]) {
                [self beginReverseGeocoding:self.locationManager.location];
                [super loadData];
            } else {
                [self.locationManager startUpdatingLocation];
                return;
            }
        }
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"定位失败" message:@"定位服务未打开，无法获取用户位置" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

#pragma mark - CLLocationManager
- (void)beginReverseGeocoding:(CLLocation *)newLocation
{
    [self.reverseGeocoder cancelGeocode];
    double lat, lon;
    mars_transform(newLocation.coordinate.latitude, newLocation.coordinate.longitude, &lat, &lon);
    // Beijing: 39.938172,116.3656
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    [self.reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            [self setUserLocationString:[NSString stringWithFormat:@"当前位置:%.6f, %.6f", newLocation.coordinate.latitude, newLocation.coordinate.longitude]];
        } else {
            CLPlacemark *placemark = placemarks[0];
            if (placemark.areasOfInterest.count > 0) {
                [self setUserLocationString:placemark.areasOfInterest.lastObject];
            } else {
                NSArray *searchPath =
                @[@"thoroughfare", @"subLocality",
                  @"locality", @"subAdministrativeArea",
                  @"administrativeArea"];
                NSMutableString *result = [NSMutableString stringWithCapacity:16];
                for (NSString *key in searchPath) {
                    NSString *value = [placemark valueForKey:key];
                    if (![value hasSuffix:@"省"]) {
                        if ([value length] > 0) {
                            [result insertString:value atIndex:0];
                        }
                    }
                }
                [self setUserLocationString:result];
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status > kCLAuthorizationStatusDenied) {
        [manager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];
    if (location.horizontalAccuracy <= manager.desiredAccuracy) {
        [manager stopUpdatingLocation];
    }
    [super loadData];
    [self beginReverseGeocoding:location];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//    [SVProgressHUD showErrorWithStatus:@"定位失败"];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"定位失败" message:@"无法获取用户位置" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark -

- (void)loadView
{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.superclass)
                                  owner:self options:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topbarView.hidden = YES;
    self.topbarView.height = 0;
    self.tableView.frame = self.view.bounds;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"地图"
                                                                     target:self
                                                                     action:@selector(onFlip:)];
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"排序" target:self action:@selector(onSort:)];
//    [self.sortViewController setItems:@[
//     [NSDictionary dictWithId:@"-range" name:@"由远到近"],
//     [NSDictionary dictWithId:@"range" name:@"由近到远"]]];
    self.navigationItem.leftBarButtonItem=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MapViewController *)mapViewController
{
    if (nil == _mapViewController) {
        _mapViewController = (MapViewController*)[[ViewControllerManager sharedInstance] mapViewController];
        _mapViewController.delegate = self;
    }
    return _mapViewController;
}

- (IBAction)onFlip:(UIButton *)sender
{
    if (!self.products) {
        return;
    }
    
    if (_mapViewController && [self.mapViewController isViewLoaded] && self.mapViewController.view.superview)
    {
        [self.mapViewController viewWillDisappear:YES];
        [self viewWillAppear:YES];
        [self.mapViewController.view removeFromSuperview];
        [sender setTitle:@"地图" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"列表" forState:UIControlStateNormal];
//        sender.title = @"列表";
        [self.mapViewController view]; // load view
        self.mapViewController.products=self.products;
        
        [self.mapViewController viewWillAppear:YES];
        [self viewWillDisappear:YES];
        [self.view addSubview:self.mapViewController.view];
        self.mapViewController.view.frame = self.view.bounds;
    }
    CATransition * transition = [CATransition animation];
    transition.delegate = self;
    transition.type = @"rippleEffect";
    [self.view.layer addAnimation:transition forKey:@"transition"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([self.mapViewController.view superview]) {
        [self.mapViewController viewDidAppear:YES];
        [self viewDidDisappear:YES];
    } else {
        [self.mapViewController viewDidDisappear:YES];
        [self viewDidAppear:YES];
    }
}
- (void)onSort:(UIButton *)sender
{
    if (self.sortViewController.view.superview) {
        [self.sortViewController.view removeFromSuperview];
    } else {
        CGRect frame = self.view.bounds;
        frame.size.width = self.view.bounds.size.width;
        frame.size.height = CGRectGetHeight(self.view.bounds) - frame.origin.y;
        
        CGRect tableF = self.sortViewController.tableView.frame;
        tableF.origin.x = CGRectGetMinX(self.sortViewController.view.bounds);
        tableF.size.width = CGRectGetWidth(self.sortViewController.view.bounds) / 2;
        
        self.sortViewController.view.frame = frame;
        self.sortViewController.tableView.frame = tableF;
        CGRect bounds = self.sortViewController.tableView.bounds;
        CGRect boundsFrom = bounds;
        boundsFrom.size.height = 0;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        animation.fromValue = [NSValue valueWithCGRect:boundsFrom];
        animation.toValue = [NSValue valueWithCGRect:bounds];
        [self.sortViewController viewWillAppear:NO];
        [self.view addSubview: self.sortViewController.view];
        [self.sortViewController.tableView.layer addAnimation:animation forKey:@"slidedown"];
    }
}

//- (void)category:(CategoryViewController *)controller didSelect:(id)item
//{
//    [super category:controller didSelect:item];
//
//    [(UIButton *)self.navigationItem.leftBarButtonItem.customView
//     setTitle:item[@"name"]
//     forState:UIControlStateNormal];
//}

#pragma mark - Partner Detail
- (void)showPartnerDetail:(id)partner
{
    NSString *pid = [partner valueForKey:@"id"];
    ListViewController *controller = (ListViewController*)[[ViewControllerManager sharedInstance] listViewController];
    controller.showTipWhenEmpty = YES;
    controller.hidesBottomBarWhenPushed = YES;
    controller.currentParams = [@{@"partnerid":pid} mutableCopy];
    [self.navigationController pushViewController:controller animated:YES];
    controller.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
}
#pragma mark - MapViewControllerDelegate
- (void)mapViewController:(MapViewController *)controller didTapProduct:(id)product
{
//    [self showPartnerDetail:partner];
    [self showProductDetail:product];
    
}

- (void)showProductDetail:(id)product
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailViewController.product = product;
    
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
