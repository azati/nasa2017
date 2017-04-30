//
//  SCPolygon.h
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import <DVAppCore/ACJsonObject.h>

#import "NSArray+SolarCity.h"

#import "SCDetail.h"

@interface SCPolygon : ACJsonObject
@property (nonatomic, strong, readonly) NSArray<NSArray<NSNumber *> *> *exterior;
@property (nonatomic, strong, readonly) NSArray<SCPolygon *> *interiorsPolygons;
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *centroid;
@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, readonly) double roofArea;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, readonly) BOOL isFlat;
@property (nonatomic, readonly) NSArray<SCDetail *> *details;
@property (nonatomic, strong, readonly) NSArray<SCValue *> *monthsInfo;
@end
