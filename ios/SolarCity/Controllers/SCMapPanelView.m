//
//  SCMapPanelView.m
//  SolarCity
//
//  Created by Denis Vashkovski on 30/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCMapPanelView.h"

#import "SCCalendarVC.h"

@interface SCMapPanelView()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPanelLeftLeading;

@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonMenu;
@property (weak, nonatomic) IBOutlet UIButton *buttonMenuOnMap;

@property (weak, nonatomic) IBOutlet UIView *viewContainerMainDetails;
@property (weak, nonatomic) IBOutlet UILabel *labelMainDetailTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelMainDetailSubTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewMainDetailMapMini;
@property (weak, nonatomic) IBOutlet UILabel *labelMainDetailPerYear;
@property (weak, nonatomic) IBOutlet UILabel *labelMainDetailPerYearValue;

@property (weak, nonatomic) IBOutlet UIView *viewSeparatorAfterMainDetails;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewGradient;

@property (weak, nonatomic) IBOutlet UIButton *buttonViewCalendar;

@property (nonatomic, strong) SCCity *city;
@property (nonatomic, strong) UIViewController *parentVC;
@property (nonatomic, strong) SCCalendarVC *calendarVC;
@end

@implementation SCMapPanelView {
    BOOL _hiden;
}

- (void)initWithCity:(SCCity *)city parentVC:(UIViewController *)parentVC {
    self.city = city;
    self.parentVC = parentVC;
    
    // header
    [self.buttonBack setTitle:ACStringByKey(@"MPLVC_BACK") forState:UIControlStateNormal];
    [self.buttonBack setTitleColor:ACColorHex(@"000000") forState:UIControlStateNormal];
    [self.buttonBack.titleLabel setFont:ACFont(SC_FONT_AVENIR_LT_STD_BOOK, 14.)];
    [self.buttonBack setImage:[ACImageNamed(@"icon_back") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                     forState:UIControlStateNormal];
    [self.buttonBack setTintColor:ACColorHex(@"448aef")];
    [self.buttonBack addTarget:self action:@selector(onBackButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    [self.labelTitle setText:ACStringByKey(@"MPLVC_SOLAR_CITY")];
    [self.labelTitle setFont:ACFont(SC_FONT_AVENIR_LT_STD_HEAVY, 27.5)];
    [self.labelTitle setTextColor:ACColorHex(@"000000")];
    
    [self.buttonMenu setImage:[ACImageNamed(@"icon_menu") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                     forState:UIControlStateNormal];
    [self.buttonMenu setTintColor:ACColorHex(@"000000")];
    [self.buttonMenu addTarget:self action:@selector(onMenuButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonMenuOnMap setImage:[ACImageNamed(@"icon_menu") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                          forState:UIControlStateNormal];
    [self.buttonMenuOnMap setTintColor:ACColorHex(@"000000")];
    [self.buttonMenuOnMap addTarget:self action:@selector(onMenuButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonMenuOnMap setBackgroundColor:ACColorHexA(@"ffffff", .96)];
    [self.buttonMenuOnMap.layer setCornerRadius:ceilf(CGRectGetWidth(self.buttonMenuOnMap.frame) / 2.)];
    
    // main details
    [self.labelMainDetailTitle setText:self.city.name];
    [self.labelMainDetailTitle setFont:ACFont(SC_FONT_AVENIR_LT_STD_MEDIUM, 20.)];
    [self.labelMainDetailTitle setTextColor:ACColorHex(@"000000")];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    [paragraph setLineSpacing:10.];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.city.mainDescription
                                                                                attributes:@{ NSForegroundColorAttributeName: ACColorHex(@"000000"),
                                                                                              NSFontAttributeName: ACFont(SC_FONT_AVENIR_LT_STD_BOOK, 14.),
                                                                                              NSParagraphStyleAttributeName: paragraph}];
    [self.labelMainDetailSubTitle setAttributedText:attrStr];
    
    [self.imageViewMainDetailMapMini setImage:ACImageNamed([@"mini_map_" stringByAppendingString:ACUnnilStr(self.city.name).lowercaseString])];
    
    [self.labelMainDetailPerYear setText:ACStringByKey(@"MPLVC_ENERGY_PRODUCTION_TITLE")];
    [self.labelMainDetailPerYear setFont:ACFont(SC_FONT_AVENIR_LT_STD_MEDIUM, 15.)];
    [self.labelMainDetailPerYear setTextColor:ACColorHex(@"000000")];
    
    [self.labelMainDetailPerYearValue setAttributedText:[self attrStrForValue:self.city.totalEnergyPerYear]];
    
    // separator
    [self.viewSeparatorAfterMainDetails setBackgroundColor:ACColorHex(@"000000")];
    
    // table view
    [self.tableView ac_setBackgroundClearColor];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    UIColor *topColor = ACColorHexA(@"ffffff", .0);
    UIColor *bottomColor = ACColorHex(@"ffffff");
    NSArray *gradientColors = @[(id)topColor.CGColor, (id)bottomColor.CGColor ];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.viewGradient.bounds;
    gradientLayer.colors = gradientColors;
    gradientLayer.startPoint = CGPointMake(.5, .0);
    gradientLayer.endPoint = CGPointMake(.5, 1.);
    [self.viewGradient.layer addSublayer:gradientLayer];
    [self.viewGradient ac_setBackgroundClearColor];
    
    // footer
    [self.buttonViewCalendar setTitle:ACStringByKey(@"MPLVC_VIEW_CALENDAR") forState:UIControlStateNormal];
    [self.buttonViewCalendar setTitleColor:ACColorHex(@"448aef") forState:UIControlStateNormal];
    [self.buttonViewCalendar.titleLabel setFont:ACFont(SC_FONT_AVENIR_LT_STD_LIGHT, 12.5)];
    [self.buttonViewCalendar setImage:[ACImageNamed(@"icon_calendar") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                             forState:UIControlStateNormal];
    [self.buttonViewCalendar setTintColor:ACColorHex(@"448aef")];
    [self.buttonViewCalendar addTarget:self action:@selector(onCalendarButtonTouch) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.city.details.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCDetail *detail = self.city.details[indexPath.row];
    SCValue *firstValue = detail.values[0];
    SCValue *secondValue = (detail.values.count > 1) ? detail.values[1] : nil;
    
    return (ACValidStr(firstValue.units) || ACValidStr(secondValue.units)) ? 76. :  60.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCDetail *detail = self.city.details[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:((detail.values.count > 1)
                                                                          ? @"Description Double Values Cell ID"
                                                                          : @"Description Cell ID")
                                                            forIndexPath:indexPath];
    
    UILabel *labelTitle = [cell ac_labelWithTag:1];
    [labelTitle setText:detail.title];
    [labelTitle setFont:ACFont(SC_FONT_AVENIR_LT_STD_BOOK, 15.)];
    [labelTitle setTextColor:ACColorHex(@"000000")];
    
    UILabel *labelValue = [cell ac_labelWithTag:2];
    [labelValue setAttributedText:[self attrStrForValue:detail.values[0]]];
    
    if (detail.values.count > 1) {
        UILabel *labelSubValue = [cell ac_labelWithTag:3];
        [labelSubValue setAttributedText:[self attrStrForValue:detail.values[1]]];
    }
    
    [cell.ac_separatorBottom setColor:ACColorHex(@"a1a1a1")];
    [cell.ac_separatorBottom setHidden:(indexPath.row == (self.city.details.count - 1))];
    
    [cell ac_setBackgroundClearColor];
    
    return cell;
}

#pragma mark - Action
- (void)onBackButtonTouch {
    [self.parentVC.navigationController popViewControllerAnimated:YES];
}

- (void)onMenuButtonTouch {
    self.constraintPanelLeftLeading.constant = _hiden ? -CGRectGetWidth(self.frame) : .0;
    
    [UIView animateWithDuration:AC_ANIMATION_DURATION_DEFAULT animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        _hiden = !_hiden;
    }];
}

- (void)onCalendarButtonTouch {
    self.calendarVC = [SCCalendarVC showForVC:self.parentVC data:self.city.monthsInfo];
}

#pragma mark - Utils
- (NSAttributedString *)attrStrForValue:(NSString *)value units:(NSString *)units {
    NSString *firstPart = value;
    NSString *secondPart = units;
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    [paragraph setAlignment:NSTextAlignmentCenter];
    [paragraph setLineSpacing:6.];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",
                                                                                            ACUnnilStr(firstPart),
                                                                                            (ACValidStr(secondPart) ? @"\n" : @""),
                                                                                            ACUnnilStr(secondPart)]
                                                                                attributes:@{ NSForegroundColorAttributeName: ACColorHex(@"a1a1a1"),
                                                                                              NSFontAttributeName: ACFont(SC_FONT_AVENIR_LT_STD_BOOK, 12.),
                                                                                              NSParagraphStyleAttributeName: paragraph}];
    [attrStr addAttributes:@{ NSForegroundColorAttributeName: ACColorHex(@"000000"),
                              NSFontAttributeName: ACFont(SC_FONT_AVENIR_LT_STD_MEDIUM, 15.) }
                     range:NSMakeRange(0, firstPart.length)];
    
    return [[NSAttributedString alloc] initWithAttributedString:attrStr];
}

- (NSAttributedString *)attrStrForValue:(SCValue *)valueData {
    return [self attrStrForValue:valueData.valueToString
                           units:(ACValidStr(valueData.units)
                                  ? [NSString stringWithFormat:@"(%@)", valueData.units]
                                  : nil)];
}

@end
