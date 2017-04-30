//
//  DesignHelper.m
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/17.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "DesignHelper.h"

@interface DesignDefault : ACDesign
@end
@implementation DesignDefault
+ (NSDictionary *)design {
    return @{  };
}
@end

@implementation DesignHelper

+ (void)applyDesign:(DesignType)type {
    switch (type) {
        default:{
            [self setDesignClass:[DesignDefault class]];
            break;
        }
    }
}

@end
