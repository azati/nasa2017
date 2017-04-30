//
//  SCPolygonsHelper.h
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCPolygon.h"

@interface SCPolygonsHelper : NSObject
ACSINGLETON_H

- (void)loadPolygonsForCityId:(long)cityId completionHandler:(void (^)(NSArray<SCPolygon *> *polygons))completionHandler;
@end
