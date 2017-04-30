//
//  SCCity.m
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCCity.h"

@implementation SCCity

- (instancetype)initWithData:(NSDictionary *)data {
    if (self = [super initWithData:data]) {
        _name = [data ac_stringForKey:@"name"];
        _centroid = [data ac_arrayForKey:@"centroid"];
        
        _coord = [data ac_stringForKey:@"coord"];
        _totalArea = [data ac_stringForKey:@"total_area"];
        
        _totalEnergyPerYear = [[SCValue alloc] initWithPrefillData:[data ac_dictionaryForKey:@"total_energy_per_year"]];
        _details = [ACJsonObject ac_arrayObjectsByData:[data ac_arrayForKey:@"details"]
                                            classModel:[SCDetail class]];
        _monthsInfo = [ACJsonObject ac_arrayObjectsPrefillByData:[data ac_arrayForKey:@"months_info"]
                                               classModel:[SCValue class]];
    }
    return self;
}

- (NSString *)mainDescription {
    return [NSString stringWithFormat:@"%@\n%@ %@",
            ACUnnilStr(self.coord),
            ACStringByKey(@"MPLVC_TOTAL_AREA"),
            ACUnnilStr(self.totalArea)];
}

@end
