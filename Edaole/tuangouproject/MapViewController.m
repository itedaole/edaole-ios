//
//  MapViewController.m
//  tuangouproject
//
//  Created by cui on 13-5-25.
//
//

#import "MapViewController.h"
#import "Annotation.h"
#import "SVProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "TGURL.h"

@interface MapViewController () <CLLocationManagerDelegate>
@property (assign, nonatomic) ASIHTTPRequest *request;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic,assign)BOOL finisLocate;
@property (strong, nonatomic) NSArray *markers;
@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"周边";
        self.locationManager = [[CLLocationManager alloc] init];

        self.locationManager.desiredAccuracy = 100;
        self.locationManager.delegate = self;
        
        self.locationManager.distanceFilter=100.0f;//设置距离筛选器
        _pointCache=[[NSCache alloc] init];
        self.finisLocate=NO;
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    
    _mapView = [[GMSMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_mapView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mapView.myLocationEnabled=YES;
    [self.locationManager startUpdatingLocation];
//    [self performSelector:@selector(updateView) withObject:nil afterDelay:0.5];
    [self updateView];
//    [self updateView];
//    if (!self.partners) {
//        [self loadData];
//    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.mapView.myLocationEnabled = NO;
    [self.locationManager stopUpdatingLocation];
//    [self removeannota];
    [self.pointCache removeAllObjects];
}

//- (void)setPartners:(NSArray *)products
//{
//    if (_partners == products) return;
//    _partners = products;
//}

- (void)removeannota{
    for (GMSMarker *marker in self.markers) {
        marker.map = nil;
    }
    self.markers = nil;
}

- (void)updateView
{
    @synchronized(self) {
        CLLocationDegrees tempLon = 0, tempLat = 0;
        NSInteger cnt = 0;
        [self removeannota];
        NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:self.products.count];
        for (NSDictionary *item in self.products) {
            NSDictionary *prd=item[@"partner"];
            if (!prd) {
                return;
            }
            double lat = [[prd valueForKeyPath:kLat] doubleValue];

            double lon = [[prd valueForKeyPath:kLon] doubleValue];

            while (YES) {
                NSString *key=[NSString stringWithFormat:@"%f,%f",lat,lon];
                if ([self.pointCache objectForKey:key]) {
                    lat+=0.00005;
                    lon+=0.00003;
                }else{
                    [self.pointCache setObject:@YES forKey:key];
                    break;
                }
            }
            
            
            tempLon +=lon;
            tempLat +=lat;
            if (lat > 90) {
                double tmp = lat;
                lat = lon;
                lon = tmp;
            }
            if (lat > 0 && lon > 0) {
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lon);
                if (CLLocationCoordinate2DIsValid(coord)) {
                    ++cnt;
                    GMSMarker *marker = [GMSMarker markerWithPosition:coord];
                    marker.title = [prd valueForKeyPath:@"title"];
                    marker.snippet = item[@"product"];
                    marker.userData = item;
                    marker.map = self.mapView;
/*
                    Annotation *mark = [[Annotation alloc]init];
                    mark.product = item;
                    mark.coordinate = coord;
                    mark.title = [prd valueForKeyPath:@"title"];
                    mark.subtitle=item[@"product"];
                    [mark setAccessibilityViewIsModal:YES];
 */
                    [annotations addObject:marker];
                }
            }
        }
        self.markers = annotations;
        if (cnt == 0)
        {
            MKCoordinateSpan theSpan;
            theSpan.latitudeDelta=0.05;
            theSpan.longitudeDelta=0.05;
            MKCoordinateRegion theRegion;
            theRegion.center=[[self.locationManager location] coordinate];
            theRegion.span=theSpan;
            
            GMSCameraPosition *position = [GMSCameraPosition cameraWithLatitude:theRegion.center.latitude
                                                                    longitude:theRegion.center.longitude
                                                                         zoom:6];

            [self.mapView setCamera:position];
//            [self.mapView setRegion:theRegion animated:YES];
            return;
        }
        
//        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(tempLat/cnt,tempLon/cnt);
        CLLocationCoordinate2D center;
        if (self.finisLocate) {
            center = self.mapView.myLocation.coordinate;
        }else{
            center = CLLocationCoordinate2DMake(tempLat/cnt,tempLon/cnt);
        }
        
        MKCoordinateSpan span;
        span.latitudeDelta = 0.012;
        span.longitudeDelta = span.latitudeDelta;
        MKCoordinateRegion region =  MKCoordinateRegionMake(center, span);
        //        [self.mapView setRegion:region animated:YES];
        GMSCameraPosition *position = [GMSCameraPosition cameraWithLatitude:region.center.latitude
                                                                  longitude:region.center.longitude
                                                                       zoom:6];
        
        [self.mapView setCamera:position];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta=0.02;
    theSpan.longitudeDelta=0.02;
    MKCoordinateRegion theRegion;
    theRegion.center=[[manager location] coordinate];
    theRegion.span=theSpan;
//    [self.mapView setRegion:theRegion animated:YES];
    GMSCameraPosition *position = [GMSCameraPosition cameraWithLatitude:theRegion.center.latitude
                                                              longitude:theRegion.center.longitude
                                                                   zoom:6];
    
    [self.mapView setCamera:position];

    NSLog(@"--得到位置--:%@",locations);
    [manager stopUpdatingLocation];
    self.finisLocate=YES;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
//    [self loadData];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"定位失败"];
    [manager stopUpdatingLocation];
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView
didTapInfoWindowOfMarker:(GMSMarker *)marker;
{
    if ([self.delegate respondsToSelector:@selector(mapViewController:didTapProduct:)]) {
        [self.delegate mapViewController:self didTapProduct:marker.userData];
    }
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation) {
        return nil;
    }
    MKPinAnnotationView *pinView = nil;
    static NSString *defaultPinID = @"custom pin";
    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil )
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        [pinView setDraggable:NO];
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    pinView.pinColor = MKPinAnnotationColorRed;
    
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{

}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"mapViewDidFinishLoadingMap");
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([self.delegate respondsToSelector:@selector(mapViewController:didTapProduct:)]) {
        [self.delegate mapViewController:self didTapProduct:[(Annotation*)view.annotation product]];
    }
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(NA, 4_0){
}

//
//- (void)loadData
//{
//    if (self.request) return;
//    self.request = [ASIHTTPRequest requestWithURL:
//                    [NSURL URLWithString:TGURL(@"Partner/ls",
//                                             @{@"lat": @(self.locationManager.location.coordinate.latitude),
//                                             @"lng": @(self.self.locationManager.location.coordinate.longitude),
//                                               @"range": @1000})]];
//
//    self.request.delegate = self;
//    [self.request startAsynchronous];
//}
//
//- (void)loadDataByMap
//{
//    if (self.request) return;
//    CLLocationCoordinate2D center = self.mapView.region.center;
//    MKCoordinateSpan span = self.mapView.region.span;
//    CLLocation *leftTop = [[CLLocation alloc] initWithLatitude:center.latitude - span.latitudeDelta
//                                                     longitude:center.longitude - span.longitudeDelta];
//    CLLocation *rightBottom = [[CLLocation alloc] initWithLatitude:center.latitude + span.latitudeDelta
//                                                         longitude:center.longitude + span.longitudeDelta];
//    CLLocationDistance distance = [leftTop distanceFromLocation:rightBottom];
//    self.request = [ASIHTTPRequest requestWithURL:
//                    [NSURL URLWithString:TGURL(@"Partner/ls",
//                                               @{@"lat": @(center.latitude),
//                                               @"lng": @(center.longitude),
//                                               @"range": @(distance)})]];
//
//    self.request.delegate = self;
//    [self.request startAsynchronous];
//}
//
//#pragma mark - Request Delegate
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    NSDictionary *resp = [request.responseData objectFromJSONData];
//    NSArray *list = resp[@"result"];
//    if (list) {
//        self.partners = list;
//    }
//    self.request = nil;
//    [self updateView];
//}
//
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    self.request = nil;
//}

@end
