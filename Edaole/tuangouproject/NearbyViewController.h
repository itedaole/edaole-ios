//
//  NearbyViewController.h
//  tuangouproject
//
//  Created by cui on 13-5-26.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ListViewController.h"
#import "MapViewController.h"

@interface NearbyViewController : ListViewController
<MapViewControllerDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) MapViewController *mapViewController;

@end
