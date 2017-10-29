//
//  ISClusteringManager.h
//  ISClusterMapFrameworkExample
//
//  Created by dima on 14.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISQuadTreeNode.h"
#import "ISClusterAnnotation.h"
#import "ISClusterAnnotationView.h"

@class ISClusteringManager;

@protocol ISClusteringManagerDelgate <NSObject>

@optional
- (CGFloat)cellSizeFactorForCoordinator:(ISClusteringManager *)coordinator;

@end

@interface ISClusteringManager : NSObject

@property (nonatomic, assign) id<ISClusteringManagerDelgate> delegate;

@property (strong, nonatomic) ISClusterDisplaySetting *displaySettings;

- (id)initWithClusterDisplaySettings:(ISClusterDisplaySetting *)displaySettings;

- (id)initWithAnnotations:(NSArray *)annotations;

- (void)setAnnotations:(NSArray *)annotations;

- (void)addAnnotations:(NSArray *)annotations;

- (void)removeAnnotations:(NSArray *)annotations;

- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale;

- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale withFilter:(BOOL (^)(id<MKAnnotation>)) filter;

- (NSArray *)allAnnotations;

- (ISClusterAnnotationView *)clusterAnnotationViewWithAnnotation:(id<MKAnnotation>)annotation onMapView:(MKMapView *)mapView;

- (void)displayAnnotations:(NSArray *)annotations onMapView:(MKMapView *)mapView;

@end
