//
//  CurrentLocation.m
//  tuangouproject
//
//  Created by stcui on 7/13/14.
//
//

#import "CurrentLocation.h"
@import CoreLocation;

@interface CurrentLocation () <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}
@end

@implementation CurrentLocation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        _locationManager.delegate = self;
    }
    return self;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorized) {
        
    } else {
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    if (location.horizontalAccuracy < 0) {
        return;
    }
    
}

@end
