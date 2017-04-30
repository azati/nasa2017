//
//  SCValue.h
//  SolarCity
//
//  Created by Denis Vashkovski on 30/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import <DVAppCore/ACJsonObject.h>

@interface SCValue : ACJsonObject
@property (nonatomic, readonly) double value;
@property (nonatomic, strong, readonly) NSString *units;
@property (nonatomic, strong, readonly) NSString *formatter;

- (NSString *)valueToString;
@end
