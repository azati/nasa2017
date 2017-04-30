//
//  SCMapVC.m
//  SolarCity
//
//  Created by Denis Vashkovski on 29/04/2017.
//  Copyright © 2017 itibo. All rights reserved.
//

#import "SCMapVC.h"

#import "SCCity.h"

#import "SCPolygonsHelper.h"

#import "SCGMSPolygon.h"

#import "SCPolygonsDrawingOperation.h"

#import "SCMapPanelView.h"
#import "SCBuildDetails.h"

#import <GoogleMaps/GoogleMaps.h>
#import <DVAppCore/ACPendingOperations.h>

@interface SCMapVC ()<GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet SCMapPanelView *viewPanelLeft;

@property (nonatomic, strong) NSArray<SCPolygon *> *polygons;
@property (nonatomic, strong) ACPendingOperations *pendingOperations;

@property (nonatomic, strong) NSMutableArray<SCGMSPolygon *> *visibleOverlays;

@property (nonatomic, strong) SCBuildDetails *buildDetailsVC;
@end

@implementation SCMapVC {
    CLLocationCoordinate2D _previousVisibleCenter;
}

+ (instancetype)ac_newInstance {
    return (SCMapVC *)[ACRouter getVCByName:NSStringFromClass([self class]) storyboardName:@"Main_iPad"];
}

#define ZOOM_DEFAULT 18.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pendingOperations = [[ACPendingOperations alloc] initWithName:@"com.itibo.SolarCity"
                                           maxConcurrentOperationCount:1];
    
    [self.viewPanelLeft initWithCity:self.city parentVC:self];
    
    [self.mapView setDelegate:self];
    [self.mapView setMapType:kGMSTypeSatellite];
    [self.mapView setMinZoom:ZOOM_DEFAULT maxZoom:ZOOM_DEFAULT];
    
    self.viewPanelLeft.layer.shadowColor = ACColorHex(@"000000").CGColor;
    self.viewPanelLeft.layer.shadowOffset = CGSizeMake(16., .0);
    self.viewPanelLeft.layer.shadowOpacity = .11;
    self.viewPanelLeft.layer.shadowRadius = 7;
    
    self.visibleOverlays = [NSMutableArray new];
    
    if (self.city) {
        [self ac_startLoadingProcess];
        [[SCPolygonsHelper getInstance] loadPolygonsForCityId:self.city.uniqueId
                                            completionHandler:
         ^(NSArray<SCPolygon *> *polygons) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.polygons = polygons;
                 
                 if (ACValidArray(self.polygons)) {
                     GMSCameraPosition *newPosition = [GMSCameraPosition cameraWithLatitude:self.city.centroid.sc_latitude
                                                                                  longitude:self.city.centroid.sc_longitude
                                                                                       zoom:ZOOM_DEFAULT
                                                                                    bearing:0.
                                                                               viewingAngle:0.];
                     [self.mapView animateToCameraPosition:newPosition];
                 }
                 
                 [self ac_stopLoadingProcess];
             });
         }];
    }
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay {
    if (![overlay isKindOfClass:[SCGMSPolygon class]]) return;
    
    SCPolygon *polygone = ((SCGMSPolygon *)overlay).polygon;
    
//    [UIAlertController showAlertInViewController:self
//                                       withTitle:nil
//                                         message:[NSString stringWithFormat:@"Index: %ld\nRoof area: %.3f\nType: %@\nName: %@\nisFlat: %@",
//                                                  polygone.uniqueId,
//                                                  polygone.roofArea,
//                                                  polygone.type,
//                                                  polygone.name,
//                                                  (polygone.isFlat ? @"Yes" : @"No")]
//                               cancelButtonTitle:@"OK"
//                          destructiveButtonTitle:nil
//                               otherButtonTitles:nil
//                                        tapBlock:nil];
    
//    [self.viewPanelLeft onMenuButtonTouch];
    
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(500.0, .0, 330., 410.)];
    [self.view addSubview:parentView];
    
    self.buildDetailsVC = [SCBuildDetails showForView:parentView data:polygone];
}

#define POLYGONS_DRAWING_OPERATION_NAME @"PolygonsDrawing"
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    [self.pendingOperations stopAll];
    
    NSOperation *operation = [[SCPolygonsDrawingOperation alloc] initWithMapView:self.mapView
                                                                   visibleRegion:[[GMSCoordinateBounds alloc] initWithRegion:self.mapView.projection.visibleRegion]
                                                                        polygons:self.polygons
                                                                 visiblePolygons:&_visibleOverlays
                                                           previousVisibleCenter:_previousVisibleCenter
                                                               completionHandler:
                              ^(CLLocationCoordinate2D previousVisibleCenter) {
                                  _previousVisibleCenter = previousVisibleCenter;
                                  [self.pendingOperations removeOperationByName:POLYGONS_DRAWING_OPERATION_NAME];
                              }];
    [self.pendingOperations addOperation:operation withKey:POLYGONS_DRAWING_OPERATION_NAME];
}

@end
