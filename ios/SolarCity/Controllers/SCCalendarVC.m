//
//  SCCalendarVC.m
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCCalendarVC.h"

#import "SCValue.h"

@interface SCCalendarVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *viewContainer;

@property (weak, nonatomic) IBOutlet UIView *viewContainerTop;
@property (weak, nonatomic) IBOutlet UILabel *labelTopTitle;

@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;

@property (weak, nonatomic) IBOutlet UIView *viewSeparator;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewCalendar;

@property (nonatomic, strong) NSArray<SCValue *> *data;
@end

@implementation SCCalendarVC

+ (instancetype)ac_newInstance {
    return (SCCalendarVC *)[ACRouter getVCByName:NSStringFromClass([self class]) storyboardName:@"Main_iPad"];
}

#define HORIZONTAL_PADDING 147.
#define VERTICAL_PADDING 124.
+ (instancetype)showForVC:(UIViewController *)parentVC data:(NSArray<SCValue *> *)data {
    UIView *viewContainer = [[UIView alloc] initWithFrame:CGRectMake(.0, .0, AC_SCREEN_WIDTH, AC_SCREEN_HEIGHT)];
    [viewContainer setBackgroundColor:ACColorHexA(@"000000", .5)];
    [viewContainer setAlpha:1.];
    [parentVC.view addSubview:viewContainer];
    
    SCCalendarVC *calendarVC = [self ac_newInstance];
    [calendarVC setViewContainer:viewContainer];
    calendarVC.data = data;
    
    UIView *calendarView = [calendarVC.view viewWithTag:1];
    [calendarView setClipsToBounds:YES];
    [calendarView.layer setCornerRadius:4.];
    [viewContainer addSubview:calendarView];
    
    [calendarView ac_addConstraintsSuperviewWithInsets:UIEdgeInsetsMake(VERTICAL_PADDING,
                                                                        HORIZONTAL_PADDING,
                                                                        VERTICAL_PADDING,
                                                                        HORIZONTAL_PADDING)];
    
    [viewContainer ac_setHidden:NO animate:YES];
    
    return calendarVC;
}

- (void)hide {
    [self.viewContainer ac_setHidden:YES animate:YES];
    [UIView animateWithDuration:.3 animations:^{
        [self.viewContainer setAlpha:.0];
    } completion:^(BOOL finished) {
        [self.viewContainer removeFromSuperview];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.labelTopTitle setText:ACStringByKey(@"CVC_TOP_TITLE")];
    [self.labelTopTitle setFont:ACFont(SC_FONT_AVENIR_LT_STD_MEDIUM, 15.)];
    [self.labelTopTitle setTextColor:ACColorHex(@"000000")];
    
    [self.buttonCancel addTarget:self action:@selector(onCancelButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    [self.viewSeparator setBackgroundColor:ACColorHex(@"a1a1a1")];
    
    [self.collectionViewCalendar setDataSource:self];
    [self.collectionViewCalendar setDelegate:self];
    [self.collectionViewCalendar setBackgroundColor:ACColorHex(@"a1a1a1")];
    [self.collectionViewCalendar setScrollEnabled:NO];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ceilf((AC_SCREEN_WIDTH - HORIZONTAL_PADDING * 2 - 3.) / 4.) - 1.,
                      ceilf((MIN(AC_SCREEN_WIDTH, AC_SCREEN_HEIGHT) - VERTICAL_PADDING * 2 - 2. - 70.) / 3.) - 1.);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Month Cell ID"
                                                                           forIndexPath:indexPath];
    
    UILabel *labelTitle = [cell ac_labelWithTag:1];
    [labelTitle setText:[[NSDate ac_date:[NSString stringWithFormat:@"%d", indexPath.item + 1]
                              dateFormat:@"MM"] ac_stringWithFormat:@"MMMM"].uppercaseString];
    [labelTitle setFont:ACFont(SC_FONT_AVENIR_LT_STD_BOOK, 12.)];
    [labelTitle setTextColor:ACColorHex(@"a1a1a1")];
    
    UILabel *labeldata = [cell ac_labelWithTag:2];
    [labeldata setAttributedText:[self attrStrForValue:self.data[indexPath.row]]];
    
    [cell setBackgroundColor:ACColorHex(@"ffffff")];
    
    return cell;
}

#pragma mark - Actions
- (void)onCancelButtonTouch {
    [self hide];
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
