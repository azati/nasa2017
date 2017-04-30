//
//  SCMapVC.h
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCTemplateVC.h"

@class SCCity;

@interface SCMapVC : SCTemplateVC
@property (nonatomic, strong) SCCity *city;
@end
