//
//  SCCitiesTVC.h
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

@class SCCity;

@protocol SCCitiesTVCDelegate;

@interface SCCitiesTVC : UITableViewController
@property (nonatomic, weak, setter=setSCDelegate:) id<SCCitiesTVCDelegate> sc_delegate;
@end

@protocol SCCitiesTVCDelegate <NSObject>
- (void)sc_didSelectCity:(SCCity *)city;
@end
