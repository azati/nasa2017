//
//  SCCalendarVC.h
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCTemplateVC.h"

#import "SCValue.h"

@interface SCCalendarVC : SCTemplateVC
AC_STANDART_CREATING_NOT_AVAILABLE(showForVC:data:)
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("init not available, call showForVC:data: instead")));
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil __attribute__((unavailable("init not available, call showForVC:data: instead")));

+ (instancetype)showForVC:(UIViewController *)parentVC data:(NSArray<SCValue *> *)data;
- (void)hide;
@end
