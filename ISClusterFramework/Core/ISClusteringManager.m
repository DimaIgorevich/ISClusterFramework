//
//  ISClusteringManager.m
//  ISClusterMapFrameworkExample
//
//  Created by dima on 14.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import "ISClusteringManager.h"
#import "ISQuadTree.h"

static NSString * const kFBClusteringManagerLockName = @"co.infinum.clusteringLock";

#pragma mark - Utility functions

NSInteger ISZoomScaleToZoomLevel(MKZoomScale scale) {
    double totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0;
    NSInteger zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom);
    NSInteger zoomLevel = MAX(0, zoomLevelAtMaxZoom + floor(log2f(scale) + 0.5));
    
    return zoomLevel;
}

CGFloat ISCellSizeForZoomScale(MKZoomScale zoomScale) {
    NSInteger zoomLevel = ISZoomScaleToZoomLevel(zoomScale);
    
    switch (zoomLevel) {
        case 13:
        case 14:
        case 15:
            return 64;
        case 16:
        case 17:
        case 18:
            return 32;
        case 19:
            return 16;
            
        default:
            return 88;
    }
}

@interface ISClusteringManager ()

@property (strong, nonatomic) ISQuadTree *tree;

@property (strong, nonatomic) NSRecursiveLock *lock;

@end

@implementation ISClusteringManager

- (id)init {
    self.displaySettings = [[ISClusterDisplaySetting alloc] init];
    return [self initWithAnnotations:nil];
}

- (id)initWithClusterDisplaySettings:(ISClusterDisplaySetting *)displaySettings {
    self.displaySettings = displaySettings;
    return [self initWithAnnotations:nil];
}

- (id)initWithAnnotations:(NSArray *)annotations {
    if (self = [super init]) {
        _lock = [NSRecursiveLock new];
        [self addAnnotations:annotations];
    }
    return self;
}

- (void)setAnnotations:(NSArray *)annotations {
    self.tree = nil;
    [self addAnnotations:annotations];
}

- (void)addAnnotations:(NSArray *)annotations {
    if (!self.tree) {
        self.tree = [[ISQuadTree alloc] init];
    }
    
    [self.lock lock];
    for (id<MKAnnotation> annotation in annotations) {
        [self.tree insertAnnotation:annotation];
    }
    [self.lock unlock];
}

- (void)removeAnnotations:(NSArray *)annotations {
    if (!self.tree) {
        return;
    }
    
    [self.lock lock];
    for (id<MKAnnotation> annotation in annotations) {
        [self.tree removeAnnotation:annotation];
    }
    [self.lock unlock];
}

- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale {
    return [self clusteredAnnotationsWithinMapRect:rect withZoomScale:zoomScale withFilter:nil];
}

- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale withFilter:(BOOL (^)(id<MKAnnotation>)) filter {
    double cellSize = ISCellSizeForZoomScale(zoomScale);
    if ([self.delegate respondsToSelector:@selector(cellSizeFactorForCoordinator:)]) {
        cellSize *= [self.delegate cellSizeFactorForCoordinator:self];
    }
    double scaleFactor = zoomScale / cellSize;
    
    NSInteger minX = floor(MKMapRectGetMinX(rect) * scaleFactor);
    NSInteger maxX = floor(MKMapRectGetMaxX(rect) * scaleFactor);
    NSInteger minY = floor(MKMapRectGetMinY(rect) * scaleFactor);
    NSInteger maxY = floor(MKMapRectGetMaxY(rect) * scaleFactor);
    
    NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];
    
    [self.lock lock];
    for (NSInteger x = minX; x <= maxX; x++) {
        for (NSInteger y = minY; y <= maxY; y++) {
            MKMapRect mapRect = MKMapRectMake(x/scaleFactor, y/scaleFactor, 1.0/scaleFactor, 1.0/scaleFactor);
            ISBounds mapBounds = ISBoundsForMapRect(mapRect);
            
            __block double totalLatitude = 0;
            __block double totalLongitude = 0;
            
            NSMutableArray *annotations = [[NSMutableArray alloc] init];
            
            [self.tree enumerateAnnotationsInBounds:mapBounds usingBlock:^(id<MKAnnotation> obj) {
                
                if(!filter || (filter(obj) == TRUE))
                {
                    totalLatitude += [obj coordinate].latitude;
                    totalLongitude += [obj coordinate].longitude;
                    [annotations addObject:obj];
                }
            }];
            
            NSInteger count = [annotations count];
            if (count == 1) {
                [clusteredAnnotations addObjectsFromArray:annotations];
            }
            
            if (count > 1) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalLatitude/count, totalLongitude/count);
                ISClusterAnnotation *cluster = [[ISClusterAnnotation alloc] init];
                cluster.coordinate = coordinate;
                cluster.annotations = annotations;
                [clusteredAnnotations addObject:cluster];
            }
        }
    }
    [self.lock unlock];
    
    return [NSArray arrayWithArray:clusteredAnnotations];
}

- (NSArray *)allAnnotations {
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    [self.lock lock];
    [self.tree enumerateAnnotationsUsingBlock:^(id<MKAnnotation> obj) {
        [annotations addObject:obj];
    }];
    [self.lock unlock];
    
    return annotations;
}

- (void)displayAnnotations:(NSArray *)annotations onMapView:(MKMapView *)mapView {
    NSMutableSet *before = [NSMutableSet setWithArray:mapView.annotations];
    MKUserLocation *userLocation = [mapView userLocation];
    if (userLocation) {
        [before removeObject:userLocation];
    }
    NSSet *after = [NSSet setWithArray:annotations];
    
    NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
    [toKeep intersectSet:after];
    
    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
    [toAdd minusSet:toKeep];
    
    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
    [toRemove minusSet:after];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [mapView addAnnotations:[toAdd allObjects]];
        [mapView removeAnnotations:[toRemove allObjects]];
    }];
}

- (ISClusterAnnotationView *)clusterAnnotationViewWithAnnotation:(id<MKAnnotation>)annotation onMapView:(MKMapView *)mapView{
    ISClusterAnnotationView *annotationView = (id)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass(ISClusterAnnotation.class)];
    if (!annotationView) {
        annotationView = [[ISClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass(ISClusterAnnotation.class)];
    }
    annotationView.displaySettings = self.displaySettings;
    annotationView.annotations = ((ISClusterAnnotation *)annotation).annotations;
    return annotationView;
}

@end
