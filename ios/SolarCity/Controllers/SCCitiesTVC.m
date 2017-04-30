//
//  SCCitiesTVC.m
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCCitiesTVC.h"

#import "SCCitiesHelper.h"

@interface SCCitiesTVC ()
@property (nonatomic, strong) NSArray<SCCity *> *cities;
@end

@implementation SCCitiesTVC

+ (instancetype)ac_newInstance {
    return (SCCitiesTVC *)[ACRouter getVCByName:NSStringFromClass([self class]) storyboardName:@"Main_iPad"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cities = [SCCitiesHelper getInstance].cities;
}

#pragma mark - UITableViewDataSource,
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 16.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"City Cell ID" forIndexPath:indexPath];
    
    UILabel *labelTitle = [cell ac_labelWithTag:1];
    [labelTitle setText:self.cities[indexPath.row].name];
    [labelTitle setFont:ACFont(SC_FONT_AVENIR_LT_STD_MEDIUM, 18.)];
    [labelTitle setTextColor:ACColorHex(@"000000")];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    
    [cell ac_setBackgroundClearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.sc_delegate && [self.sc_delegate respondsToSelector:@selector(sc_didSelectCity:)]) {
        [self.sc_delegate sc_didSelectCity:self.cities[indexPath.row]];
    }
}

@end
