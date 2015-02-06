//
//  GeoConverter.h
//  tuangouproject
//
//  Created by stcui on 7/13/14.
//
//

#import <Foundation/Foundation.h>

__BEGIN_DECLS
// World Geodetic system -> Mars Geodetic System
void mars_transform(double wgLat, double wgLon, double *mgLat, double *mgLon);
__END_DECLS