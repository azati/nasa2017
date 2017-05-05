//
//  SCPolygonsHelper.m
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCPolygonsHelper.h"

@interface SCPolygonsHelper()
@property (nonatomic, strong) NSDictionary<NSNumber *, NSString *> *dataFileNames;
@end

@implementation SCPolygonsHelper
ACSINGLETON_M

- (NSDictionary<NSNumber *,NSString *> *)dataFileNames {
    if (!_dataFileNames) {
        _dataFileNames = @{ @(0): @"grodno_buildings_with_estimates_small" };
    }
    return _dataFileNames;
}

- (void)loadPolygonsForCityId:(long)cityId completionHandler:(void (^)(NSArray<SCPolygon *> *))completionHandler {
    if (cityId < 0) {
        completionHandler(nil);
        return;
    }
    
    [[NSOperationQueue new] addOperationWithBlock:^{
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.dataFileNames[@(cityId)]
                                                                                      ofType:@"json"]];
        NSArray *polygonsData = data.ac_jsonToCollectionObject;
        
        NSMutableArray *polygons = [NSMutableArray new];
        for (NSDictionary *polygonData in polygonsData) {
            [polygons addObject:[[SCPolygon alloc] initWithData:polygonData]];
        }
        
        _polygons = ACValidArray(polygons) ? [NSArray arrayWithArray:polygons] : nil;
        
        if (completionHandler) {
            completionHandler(_polygons);
        }
    }];
}

@end
