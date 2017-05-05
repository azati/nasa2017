//
//  SCMapPanelView.h
//  SolarCity
//
//  Created by Denis Vashkovski on 30/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCCity.h"

@interface SCMapPanelView : UIView
- (void)initWithCity:(SCCity *)city parentVC:(UIViewController *)parentVC;
- (void)onMenuButtonTouch;

- (BOOL)isMenuHidden;
@end
