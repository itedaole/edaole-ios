//
//  MapViewController.h
//  tuangouproject
//
//  Created by cui on 13-5-25.
//
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@protocol MapViewControllerDelegate;

@interface MapViewController : UIViewController <GMSMapViewDelegate>
@property (assign, nonatomic) id<MapViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *products;
@property (readonly, strong, nonatomic) GMSMapView *mapView;
@property (readonly,nonatomic,strong)NSCache *pointCache;
@end

@protocol MapViewControllerDelegate <NSObject>
@optional
- (void)mapViewController:(MapViewController *)controller didTapProduct:(id)product;
@end
