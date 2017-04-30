//
//  SCBuildDetails.m
//  SolarCity
//
//  Created by Denis Vashkovski on 30/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCBuildDetails.h"

#import "SCCalendarVC.h"

@interface SCBuildDetails ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIView *parentView;

@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSubTitle;
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (weak, nonatomic) IBOutlet UIButton *buttonCalendar;

@property (nonatomic, strong) SCPolygon *polygon;
@property (nonatomic, strong) SCCalendarVC *calendarVC;
@end

@implementation SCBuildDetails

+ (instancetype)ac_newInstance {
    return (SCBuildDetails *)[ACRouter getVCByName:NSStringFromClass([self class]) storyboardName:@"Main_iPad"];
}

+ (instancetype)showForView:(UIView *)parentView data:(SCPolygon *)polygon {
    [parentView setAlpha:.0];
    [parentView setClipsToBounds:YES];
    [parentView.layer setCornerRadius:4.];
    
    SCBuildDetails *buildDetails = [self ac_newInstance];
    buildDetails.polygon = polygon;
    buildDetails.parentView = parentView;
    
    UIView *buildDataView = [buildDetails.view viewWithTag:1];
    [buildDataView setClipsToBounds:YES];
    [buildDataView.layer setCornerRadius:4.];
    [parentView addSubview:buildDataView];
    
    [buildDataView ac_addConstraintsEqualSuperview];
    
    [parentView ac_setHidden:NO animate:YES];
    
    return buildDetails;
}

- (void)hide {
    [self.parentView ac_setHidden:YES animate:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.labelTitle setText:self.polygon.name];
    [self.labelTitle setFont:ACFont(SC_FONT_AVENIR_LT_STD_MEDIUM, 20.)];
    [self.labelTitle setTextColor:ACColorHex(@"000000")];
    [self.labelTitle setAdjustsFontSizeToFitWidth:YES];
    
    [self.buttonCancel setImage:[ACImageNamed(@"icon_close") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                     forState:UIControlStateNormal];
    [self.buttonCancel setTintColor:ACColorHex(@"000000")];
    [self.buttonCancel addTarget:self action:@selector(onButtonCancelTouch) forControlEvents:UIControlEventTouchUpInside];
    
    [self.labelSubTitle setText:[NSString stringWithFormat:@"%.2f′N %.2f′E",
                                 self.polygon.centroid.sc_latitude,
                                 self.polygon.centroid.sc_longitude]];
    [self.labelSubTitle setFont:ACFont(SC_FONT_AVENIR_LT_STD_MEDIUM, 20.)];
    [self.labelSubTitle setTextColor:ACColorHex(@"000000")];
    
    [self.tabelView ac_setBackgroundClearColor];
    [self.tabelView setDataSource:self];
    [self.tabelView setDelegate:self];
    
    [self.buttonCalendar setTitle:ACStringByKey(@"MPLVC_VIEW_CALENDAR") forState:UIControlStateNormal];
    [self.buttonCalendar setTitleColor:ACColorHex(@"448aef") forState:UIControlStateNormal];
    [self.buttonCalendar.titleLabel setFont:ACFont(SC_FONT_AVENIR_LT_STD_LIGHT, 12.5)];
    [self.buttonCalendar setImage:[ACImageNamed(@"icon_calendar") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                             forState:UIControlStateNormal];
    [self.buttonCalendar setTintColor:ACColorHex(@"448aef")];
    [self.buttonCalendar addTarget:self action:@selector(onCalendarButtonTouch) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.polygon.details.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCDetail *detail = self.polygon.details[indexPath.row];
    SCValue *firstValue = detail.values[0];
    SCValue *secondValue = (detail.values.count > 1) ? detail.values[1] : nil;
    
    return (ACValidStr(firstValue.units) || ACValidStr(secondValue.units)) ? 76. :  60.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCDetail *detail = self.polygon.details[indexPath.row];
    
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
    [cell.ac_separatorBottom setHidden:(indexPath.row == (self.polygon.details.count - 1))];
    
    [cell ac_setBackgroundClearColor];
    
    return cell;
}

- (void)onButtonCancelTouch {
    [self.parentView ac_setHidden:YES animate:YES];
}

- (void)onCalendarButtonTouch {
    self.calendarVC = [SCCalendarVC showForVC:self data:self.polygon.monthsInfo];
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
