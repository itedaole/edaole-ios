//
//  CurrentLocation.h
//  tuangouproject
//
//  Created by stcui on 7/13/14.
//
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface CurrentLocation : NSObject
@property (readonly, nonatomic) NSString *locationDisplayName;
@property (readonly, nonatomic) CLLocation *currentLocation;
@end
