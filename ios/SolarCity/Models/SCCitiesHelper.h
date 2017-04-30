//
//  SCCitiesHelper.h
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCCity.h"

@interface SCCitiesHelper : NSObject
ACSINGLETON_H

@property (nonatomic, strong, readonly) NSArray<SCCity *> *cities;
@end
