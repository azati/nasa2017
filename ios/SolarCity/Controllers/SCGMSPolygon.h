//
//  SCGMSPolygon.h
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

#import "SCPolygon.h"

@interface SCGMSPolygon : GMSPolygon
+ (instancetype)sc_polygon:(SCPolygon *)polygon;

@property (nonatomic, strong, readonly) SCPolygon *polygon;
@end
