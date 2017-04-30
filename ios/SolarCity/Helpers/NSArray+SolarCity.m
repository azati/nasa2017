//
//  NSArray+SolarCity.m
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "NSArray+SolarCity.h"

@implementation NSArray(SolarCity)

- (double)sc_latitude {
    return [self sc_arrayValidAsCoordinate] ? [[self objectAtIndex:0] doubleValue] : .0;
}

- (double)sc_longitude {
    return [self sc_arrayValidAsCoordinate] ? [[self objectAtIndex:1] doubleValue] : .0;
}

#pragma mark - Utils
- (BOOL)sc_arrayValidAsCoordinate {
    return self.count == 2;
}

@end
