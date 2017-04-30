//
//  SCGMSPolygon.m
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCGMSPolygon.h"

@implementation SCGMSPolygon

+ (instancetype)sc_polygon:(SCPolygon *)polygon {
    return [[self alloc] initWithPolygon:polygon];
}

- (instancetype)initWithPolygon:(SCPolygon *)polygon {
    if (self = [super init]) {
        _polygon = polygon;
        
        NSMutableArray *holes = [NSMutableArray new];
        for (SCPolygon *holePolygonData in polygon.interiorsPolygons) {
            [holes addObject:[self pathWithData:holePolygonData.exterior]];
        }
        
        self.path = [self pathWithData:polygon.exterior];
        self.holes = [NSArray arrayWithArray:holes];
    }
    return self;
}

#pragma mark - Utils
- (GMSPath *)pathWithData:(NSArray<NSArray<NSNumber *> *> *)coords {
    GMSMutablePath *path = [GMSMutablePath path];
    for (NSArray *coordData in coords) {
        [path addCoordinate:CLLocationCoordinate2DMake(coordData.sc_latitude, coordData.sc_longitude)];
    }
    
    return [[GMSPath alloc] initWithPath:path];
}

@end
