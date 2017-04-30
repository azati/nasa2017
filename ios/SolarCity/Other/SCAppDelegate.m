//
//  SCAppDelegate.m
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/17.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCAppDelegate.h"

#import "DesignHelper.h"

#import <GoogleMaps/GoogleMaps.h>

@interface SCAppDelegate ()

@end

@implementation SCAppDelegate

AC_EXTERN_STRING_M_V(NMGoogleMapAPIKey, @"AIzaSyANDgmdN547aNL3y48bO3gTZ07s1gdh_Sc")

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    [GMSServices provideAPIKey:NMGoogleMapAPIKey];
    
    [self initGlobalDesign];
    
    return YES;
}

- (UIInterfaceOrientationMask)ac_interfaceOrientationsDefault {
    return UIInterfaceOrientationMaskLandscape;
}

- (void)initGlobalDesign {
    [DesignHelper applyDesign:DesignTypeDefault];
}

@end
