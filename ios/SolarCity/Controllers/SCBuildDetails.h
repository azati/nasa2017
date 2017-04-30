//
//  SCBuildDetails.h
//  SolarCity
//
//  Created by Denis Vashkovski on 30/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCTemplateVC.h"

#import "SCPolygon.h"

@interface SCBuildDetails : SCTemplateVC
+ (instancetype)showForView:(UIView *)parentView data:(SCPolygon *)polygon;
- (void)hide;
@end
