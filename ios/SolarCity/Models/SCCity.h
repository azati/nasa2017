//
//  SCCity.h
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import <DVAppCore/ACJsonObject.h>

#import "SCDetail.h"

@interface SCCity : ACJsonObject
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *centroid;

@property (nonatomic, strong, readonly) NSString *coord;
@property (nonatomic, strong, readonly) NSString *totalArea;

@property (nonatomic, strong, readonly) SCValue *totalEnergyPerYear;

@property (nonatomic, readonly) NSArray<SCDetail *> *details;
@property (nonatomic, strong, readonly) NSArray<SCValue *> *monthsInfo;

- (NSString *)mainDescription;
@end
