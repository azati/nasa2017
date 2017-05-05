//
//  SCMainVC.m
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCMainVC.h"

#import "SCCitiesHelper.h"
#import "SCPolygonsHelper.h"

#import "SCCitiesTVC.h"
#import "SCMapVC.h"

@interface SCMainVC ()<SCCitiesTVCDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;

@property (weak, nonatomic) IBOutlet UIView *viewContainerRight;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelText;

@property (weak, nonatomic) IBOutlet UIView *viewContainerTextField;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCity;
@property (weak, nonatomic) IBOutlet UIButton *buttonGo;

@property (nonatomic, strong) UIPopoverController *citiesPopover;
@property (nonatomic) NSUInteger selectedCityIndex;
@end

@implementation SCMainVC

+ (instancetype)ac_newInstance {
    return (SCMainVC *)[ACRouter getVCByName:NSStringFromClass([self class]) storyboardName:@"Main_iPad"];
}

#define BUTTON_DROPDOWN_IMAGE_PADDING 8.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.viewContainerRight setBackgroundColor:ACColorHexA(@"ffffff", .96)];
    self.viewContainerRight.layer.shadowColor = ACColorHex(@"000000").CGColor;
    self.viewContainerRight.layer.shadowOffset = CGSizeMake(-16., .0);
    self.viewContainerRight.layer.shadowOpacity = .11;
    self.viewContainerRight.layer.shadowRadius = 7;
    
    [self.labelTitle setText:ACStringByKey(@"MVC_SOLAR_CITY")];
    [self.labelTitle setFont:ACFont(SC_FONT_AVENIR_LT_STD_HEAVY, 37.5)];
    [self.labelTitle setTextColor:ACColorHex(@"000000")];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    [paragraph setLineSpacing:9.];
    
    [self.labelText setAttributedText:
     [[NSAttributedString alloc] initWithString:ACStringByKey(@"MVC_TEXT")
                                     attributes:@{ NSForegroundColorAttributeName: ACColorHex(@"000000"),
                                                   NSFontAttributeName: ACFont(SC_FONT_AVENIR_LT_STD_BOOK, 17),
                                                   NSParagraphStyleAttributeName: paragraph }]];
    
    [self.viewContainerTextField ac_setBorderWidth:1. color:ACColorHex(@"a1a1a1")];
    [self.viewContainerTextField.layer setCornerRadius:5.];
    [self.textFieldCity setAttributedPlaceholder:
     [[NSAttributedString alloc] initWithString:ACStringByKey(@"MCV_WRITE_LOCATION_HERE")
                                     attributes:@{ NSForegroundColorAttributeName: ACColorHex(@"a1a1a1"),
                                                   NSFontAttributeName: ACFont(SC_FONT_AVENIR_LT_STD_BOOK, 17) }]];
    [self.textFieldCity addTarget:self action:@selector(onCityTextFieldEdited:) forControlEvents:UIControlEventEditingChanged];
    [self.textFieldCity setTintColor:ACColorHex(@"000000")];
    [self.textFieldCity setFont:ACFont(SC_FONT_AVENIR_LT_STD_BOOK, 17)];
    [self.textFieldCity setTextColor:ACColorHex(@"000000")];
    [self.textFieldCity setDelegate:self];
    
    [self.buttonGo setTitle:ACStringByKey(@"MVC_GO") forState:UIControlStateNormal];
    [self.buttonGo setTitleColor:ACColorHex(@"ffffff") forState:UIControlStateNormal];
    [self.buttonGo.titleLabel setFont:ACFont(SC_FONT_AVENIR_LT_STD_BOOK, 24)];
    [self.buttonGo setBackgroundColor:ACColorHex(@"448aef")];
    [self.buttonGo.layer setCornerRadius:5.];
    [self.buttonGo addTarget:self action:@selector(onGoButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
#warning TODO correct it
    [self ac_startLoadingProcess];
    [[SCPolygonsHelper getInstance] loadPolygonsForCityId:[SCCitiesHelper getInstance].cities.firstObject.uniqueId
                                        completionHandler:
     ^(NSArray<SCPolygon *> *polygons) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self ac_stopLoadingProcess];
         });
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self openPopoverForView:textField];
    return NO;
}

#pragma mark - Actions
- (void)onCityTextFieldEdited:(UITextField *)textField {
    [self openPopoverForView:textField];
}

- (void)onGoButtonTouch {
    SCMapVC *mapVC = [SCMapVC ac_newInstance];
    [mapVC setCity:[SCCitiesHelper getInstance].cities[self.selectedCityIndex]];
    
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark - SCCitiesTVCDelegate
- (void)sc_didSelectCity:(SCCity *)city {
    self.selectedCityIndex = [[SCCitiesHelper getInstance].cities indexOfObject:city];
    [self.textFieldCity setText:city.name];
    [self.citiesPopover dismissPopoverAnimated:YES];
}

#pragma mark - Utils
- (void)openPopoverForView:(UIView *)view {
    if (!self.citiesPopover) {
        SCCitiesTVC *citiesTVC = [SCCitiesTVC ac_newInstance];
        [citiesTVC setSCDelegate:self];
        
        self.citiesPopover = [[UIPopoverController alloc] initWithContentViewController:citiesTVC];
        self.citiesPopover.popoverContentSize = CGSizeMake(250., 150.);
    }
    
    if (!self.citiesPopover.popoverVisible) {
        [self.citiesPopover presentPopoverFromRect:[view convertRect:view.frame toView:self.view]
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionDown
                                          animated:YES];
    }
}

@end
