//
//  SCValue.m
//  SolarCity
//
//  Created by Denis Vashkovski on 30/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCValue.h"

@implementation SCValue

- (NSString *)valueToString {
    return (ACValidStr(self.formatter)
            ? [NSString stringWithFormat:self.formatter, self.value]
            : nil);
}

@end
