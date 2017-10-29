//
//  ISMapViewController.m
//  ISClusterMapFrameworkExample
//
//  Created by dima on 13.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import "ISMapViewController.h"
#import "ISAnnotaionLocation.h"

@interface ISMapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) ISClusteringManager *clusteringManager;

@end

@implementation ISMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vMap.delegate = self;
    self.clusteringManager = [[ISClusteringManager alloc] init];
    self.clusteringManager.displaySettings.markerFont = [UIFont systemFontOfSize:14.f];
    self.clusteringManager.displaySettings.markerBorderColor = [UIColor whiteColor];
    self.clusteringManager.displaySettings.markerTextColor = [UIColor whiteColor];
    self.clusteringManager.displaySettings.displayBackgroundStyle = ISDisplayBackgroundStyleSolid;
    self.clusteringManager.displaySettings.markerBackgroundColor = [UIColor orangeColor];
    self.clusteringManager.displaySettings.scaleFactor = CGSizeMake(0.9, 1.2f);
    [self.clusteringManager addAnnotations:[self annotations]];
}

//TEST
- (NSArray *)annotations {
    NSArray *locations = @[
                           @{
                               @"lat" : @(48.47352),
                               @"long" : @(3.87426)
                               },
                           @{
                               @"lat" : @(52.59758),
                               @"long" : @(-1.93061)
                               },
                           @{
                               @"lat" : @(48.41370),
                               @"long" : @(3.43531)
                               },
                           @{
                               @"lat" : @(48.31921),
                               @"long" : @(18.10184)
                               },
                           @{
                               @"lat" : @(47.84302),
                               @"long" : @(22.81101)
                               },
                           @{
                               @"lat" : @(60.88622),
                               @"long" : @(26.83792)
                               },
                           @{
                               @"lat" : @(51.28181),
                               @"long" : @(22.47306)
                               },
                           @{
                               @"lat" : @(44.49111),
                               @"long" : @(4.27389)
                               }
                           ];
    NSMutableArray *annotations = [NSMutableArray array];
    for (NSDictionary *dict in locations) {
        [annotations addObject:[[ISAnnotaionLocation alloc] initWithDictionary:dict]];
    }
    return [annotations copy];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [[NSOperationQueue new] addOperationWithBlock:^{
        double scale = self.vMap.bounds.size.width / self.vMap.visibleMapRect.size.width;
        NSArray *annotations = [self.clusteringManager clusteredAnnotationsWithinMapRect:self.vMap.visibleMapRect withZoomScale:scale];

        [self.clusteringManager displayAnnotations:annotations onMapView:self.vMap];
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:ISClusterAnnotation.class]) {
        return [self.clusteringManager clusterAnnotationViewWithAnnotation:annotation onMapView:mapView];
    }

    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0) {
    if ([view isKindOfClass:ISClusterAnnotationView.class]) {
        [self.vMap showClusterView:view animated:YES];
    }
}

@end
