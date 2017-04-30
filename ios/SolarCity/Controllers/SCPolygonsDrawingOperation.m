//
//  SCPolygonsDrawingOperation.m
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCPolygonsDrawingOperation.h"

#import <DVAppCore/ACPendingOperations.h>

@interface SCPolygonsDrawingOperation()
@property (nonatomic, strong) NSArray<SCPolygon *> *polygons;
@property (nonatomic, strong) NSMutableArray<SCGMSPolygon *> *visiblePolygons;
@property (nonatomic) CLLocationCoordinate2D previousVisibleCenter;
@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) GMSCoordinateBounds *visibleRegion;
@property (nonatomic, strong) void (^completionHandler)(CLLocationCoordinate2D previousVisibleCenter);
@end

@implementation SCPolygonsDrawingOperation

- (instancetype)initWithMapView:(GMSMapView *)mapView
                  visibleRegion:(GMSCoordinateBounds *)visibleRegion
                       polygons:(NSArray<SCPolygon *> *)polygons
                visiblePolygons:(NSMutableArray<SCGMSPolygon *> *__strong *)visiblePolygons
          previousVisibleCenter:(CLLocationCoordinate2D)previousVisibleCenter
              completionHandler:(void (^)(CLLocationCoordinate2D))completionHandler {
    if (self = [super init]) {
        _mapView = mapView;
        _visibleRegion = visibleRegion;
        _polygons = polygons;
        _visiblePolygons = *visiblePolygons;
        _previousVisibleCenter = previousVisibleCenter;
        _completionHandler = completionHandler;
    }
    return self;
}

- (void)main {
    CLLocationCoordinate2D northEast = self.visibleRegion.northEast;
    CLLocationCoordinate2D southWest = self.visibleRegion.southWest;
    CLLocationCoordinate2D currentVisibleCenter = CLLocationCoordinate2DMake((northEast.latitude + southWest.latitude) / 2.,
                                                                             (northEast.longitude + southWest.longitude) / 2.);
    double minStep = (northEast.latitude - southWest.latitude) / 5;
    
    if (sqrt(pow(ABS(currentVisibleCenter.latitude - self.previousVisibleCenter.latitude), 2) +
             pow(ABS(currentVisibleCenter.longitude - self.previousVisibleCenter.longitude), 2)) > minStep) {
        [self.visiblePolygons enumerateObjectsUsingBlock:^(SCGMSPolygon * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![self.visibleRegion containsCoordinate:CLLocationCoordinate2DMake(obj.polygon.centroid.sc_latitude,
                                                                                   obj.polygon.centroid.sc_longitude)])  {
                [self executeInMainThread:^{
                    obj.map = nil;
                }];
                [self.visiblePolygons removeObject:obj];
            }
        }];
        
        for (NSUInteger polygonIndex = 0; polygonIndex < self.polygons.count; polygonIndex++) {
            if (self.isCancelled) {
                [self executeCompletionHandler];
                return;
            }
            
            SCPolygon *polygon = self.polygons[polygonIndex];
            
            if ([self.visibleRegion containsCoordinate:CLLocationCoordinate2DMake(polygon.centroid.sc_latitude,
                                                                                  polygon.centroid.sc_longitude)]) {
                if (![[self.visiblePolygons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:
                                                                         @"polygon.uniqueId == %ld",
                                                                         polygon.uniqueId]] firstObject]) {
                    [self executeInMainThread:^{
                        SCGMSPolygon *gmsPolygon = [SCGMSPolygon sc_polygon:polygon];
                        [gmsPolygon setFillColor:ACColorHexA((polygon.isFlat ? @"5dff32" : @"ff0000"), .66)];
                        [gmsPolygon setTappable:YES];
                        [gmsPolygon setTitle:@(polygon.isFlat).stringValue];
                        gmsPolygon.map = self.mapView;
                        
                        [self.visiblePolygons addObject:gmsPolygon];
                    }];
                }
            }
        }
        
        self.previousVisibleCenter = currentVisibleCenter;
    }
    
    [self executeCompletionHandler];
}

- (void)executeCompletionHandler {
    if (!self.completionHandler) return;
    
    [self executeInMainThread:^{
        self.completionHandler(self.previousVisibleCenter);
    }];
}

#pragma mark - Utils
- (void)executeInMainThread:(void (^)())handler {
    if (!handler) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        handler();
    });
}

@end
