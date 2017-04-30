//
//  SCDetail.m
//  SolarCity
//
//  Created by Denis Vashkovski on 30/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCDetail.h"

@implementation SCDetail

- (instancetype)initWithData:(NSDictionary *)data {
    if (self = [super initWithData:data]) {
        _title = [data ac_stringForKey:@"title"];
        _values = [ACJsonObject ac_arrayObjectsPrefillByData:[data ac_arrayForKey:@"values"]
                                                  classModel:[SCValue class]];
    }
    return self;
}

@end
