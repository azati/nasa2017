//
//  DesignHelper.h
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/17.
//  Copyright © 2017 itibo. All rights reserved.
//

#import <ACDesignHelper.h>

typedef enum {
    DesignTypeDefault
} DesignType;

@interface DesignHelper : ACDesignHelper
+ (void)applyDesign:(DesignType)type;
@end

#define SC_FONT_AVENIR_LT_STD_BOOK @"AvenirLTStd-Book"
#define SC_FONT_AVENIR_LT_STD_LIGHT @"AvenirLTStd-Light"
#define SC_FONT_AVENIR_LT_STD_HEAVY @"AvenirLTStd-Heavy"
#define SC_FONT_AVENIR_LT_STD_MEDIUM @"AvenirLTStd-Medium"
#define SC_FONT_AVENIR_LT_STD_BLACK @"AvenirLTStd-Black"
