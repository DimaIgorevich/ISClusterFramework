//
//  MKMapView+ISCluster.h
//  ISClusterFramework
//
//  Created by dima on 29.10.17.
//  Copyright © 2017 InfiroomStudio. All rights reserved.
//

@import MapKit;
#import "ISClusterAnnotationView.h"

@interface MKMapView (ISCluster)

- (void)showClusterView:(ISClusterAnnotationView *)view animated:(BOOL)animated;

- (void)showClusterView:(ISClusterAnnotationView *)view edgePadding:(UIEdgeInsets)insets animated:(BOOL)animated;

@end
