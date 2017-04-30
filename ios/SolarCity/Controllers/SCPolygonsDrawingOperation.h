//
//  SCPolygonsDrawingOperation.h
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCGMSPolygon.h"

#import <GoogleMaps/GoogleMaps.h>

@interface SCPolygonsDrawingOperation : NSOperation
- (instancetype)initWithMapView:(GMSMapView *)mapView
                  visibleRegion:(GMSCoordinateBounds *)visibleRegion
                       polygons:(NSArray<SCPolygon *> *)polygons
                visiblePolygons:(NSMutableArray<SCGMSPolygon *> * __strong *)visiblePolygons
          previousVisibleCenter:(CLLocationCoordinate2D)previousVisibleCenter
              completionHandler:(void (^)(CLLocationCoordinate2D previousVisibleCenter))completionHandler;
@end
