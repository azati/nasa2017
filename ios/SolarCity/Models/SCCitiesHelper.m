//
//  SCCitiesHelper.m
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCCitiesHelper.h"

@implementation SCCitiesHelper
ACSINGLETON_M_INIT(initSCCitiesHelper)

- (void)initSCCitiesHelper {
    NSArray *citiesData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cities_data"
                                                                                         ofType:@"json"]].ac_jsonToCollectionObject;
    if (ACValidArray(citiesData)) {
        _cities = [ACJsonObject ac_arrayObjectsPrefillByData:citiesData classModel:[SCCity class]];
    }
}

@end
