//
//  SCDetail.h
//  SolarCity
//
//  Created by Denis Vashkovski on 30/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import <DVAppCore/ACJsonObject.h>

#import "SCValue.h"

@interface SCDetail : ACJsonObject
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSArray<SCValue *> *values;
@end
