//
//  MKMapView+ISCluster.m
//  ISClusterFramework
//
//  Created by dima on 29.10.17.
//  Copyright © 2017 InfiroomStudio. All rights reserved.
//

#import "MKMapView+ISCluster.h"

@implementation MKMapView (ISCluster)

- (void)showClusterView:(ISClusterAnnotationView *)view animated:(BOOL)animated {
    [self showClusterView:view edgePadding:UIEdgeInsetsZero animated:animated];
}

- (void)showClusterView:(ISClusterAnnotationView *)view edgePadding:(UIEdgeInsets)insets animated:(BOOL)animated {
    MKMapRect zoomRect = MKMapRectNull;
    for (id<MKAnnotation> annotation in view.annotations) {
        MKMapRect pointRect;
        pointRect.origin = MKMapPointForCoordinate(annotation.coordinate);
        pointRect.size = MKMapSizeMake(0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self setVisibleMapRect:zoomRect edgePadding:insets animated:animated];
}

@end
