//
//  SCPolygon.m
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCPolygon.h"

@implementation SCPolygon

#define EXTERIOR_KEY @"exterior"
#define INTERIORS_KEY @"interiors"
- (instancetype)initWithData:(NSDictionary *)data {
    if (self = [super initWithData:data]) {
        id exteriorPolygonData = [data ac_arrayForKey:EXTERIOR_KEY];
        if (ACValidArray(exteriorPolygonData)) {
            _exterior = exteriorPolygonData;
        }
        
        id interiorsPolygonsData = [data ac_arrayForKey:INTERIORS_KEY];
        if (ACValidArray(interiorsPolygonsData)) {
            NSMutableArray *interiorsPolygons = [NSMutableArray new];
            
            for (NSArray *polygonData in interiorsPolygonsData) {
                [interiorsPolygons addObject:[[SCPolygon alloc] initWithData:@{ EXTERIOR_KEY: polygonData }]];
            }
            
            _interiorsPolygons = ACValidArray(interiorsPolygons) ? [NSArray arrayWithArray:interiorsPolygons] : nil;
        }
        
        _centroid = [data ac_arrayForKey:@"centroid"];
        _type = [data ac_stringForKey:@"type"];
        _roofArea = [[data ac_numberForKey:@"roof_area"] doubleValue];
        _name = [data ac_stringForKey:@"name"];
        _isFlat = [data ac_boolForKey:@"is_flat"];
        
        _details = [ACJsonObject ac_arrayObjectsByData:[data ac_arrayForKey:@"details"]
                                            classModel:[SCDetail class]];
        _monthsInfo = [ACJsonObject ac_arrayObjectsPrefillByData:[data ac_arrayForKey:@"months_info"]
                                                      classModel:[SCValue class]];
    }
    return self;
}

@end
