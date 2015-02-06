//
//  Annotation.h
//  tuangouproject
//
//  Created by cui on 13-5-30.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Annotation : NSObject <MKAnnotation, NSCopying>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (strong, nonatomic) id product;

@end
