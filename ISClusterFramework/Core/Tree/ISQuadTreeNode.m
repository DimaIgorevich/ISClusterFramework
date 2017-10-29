//
//  ISQuadTreeNode.m
//  ISClusterMapFrameworkExample
//
//  Created by dima on 14.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import "ISQuadTreeNode.h"

@implementation ISQuadTreeNode

#pragma mark - Lifecycle

- (id)init {
    if (self = [super init]) {
        self.count = 0;
        self.northEast = nil;
        self.northWest = nil;
        self.southEast = nil;
        self.southWest = nil;
        self.annotations = [[NSMutableArray alloc] initWithCapacity:kNodeCapacityDefault];
    }
    return self;
}

- (id)initWithBounds:(ISBounds)bounds {
    if (self = [self init]) {
        self.bounds = bounds;
    }
    return self;
}

#pragma mark - Helpers

- (BOOL)isLeaf {
    return self.northEast ? NO : YES;
}

- (void)subdivide {
    self.northEast = [[ISQuadTreeNode alloc] init];
    self.northWest = [[ISQuadTreeNode alloc] init];
    self.southEast = [[ISQuadTreeNode alloc] init];
    self.southWest = [[ISQuadTreeNode alloc] init];
    
    ISBounds bounds = self.bounds;
    CGFloat xMid = (bounds.xf + bounds.x0) / 2.f;
    CGFloat yMid = (bounds.yf + bounds.y0) / 2.f;
    
    self.northEast.bounds = ISBoundsMake(xMid, bounds.y0, bounds.xf, yMid);
    self.northWest.bounds = ISBoundsMake(bounds.x0, bounds.y0, xMid, yMid);
    self.southEast.bounds = ISBoundsMake(xMid, yMid, bounds.xf, bounds.yf);
    self.southWest.bounds = ISBoundsMake(bounds.x0, yMid, xMid, bounds.yf);
}

#pragma mark - Bounds

ISBounds ISBoundsMake(CGFloat x0, CGFloat y0, CGFloat xf, CGFloat yf) {
    ISBounds bounds;
    bounds.x0 = x0;
    bounds.y0 = y0;
    bounds.xf = xf;
    bounds.yf = yf;
    return bounds;
}

ISBounds ISBoundsForMapRect(MKMapRect mapRect) {
    CLLocationCoordinate2D topLeft = MKCoordinateForMapPoint(mapRect.origin);
    CLLocationCoordinate2D botRight = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)));
    
    CLLocationDegrees minLat = botRight.latitude;
    CLLocationDegrees maxLat = topLeft.latitude;
    
    CLLocationDegrees minLon = topLeft.longitude;
    CLLocationDegrees maxLon = botRight.longitude;
    
    return ISBoundsMake(minLat, minLon, maxLat, maxLon);
}

MKMapRect ISMapRectForBounds(ISBounds bounds) {
    MKMapPoint topLeft = MKMapPointForCoordinate(CLLocationCoordinate2DMake(bounds.x0, bounds.y0));
    MKMapPoint botRight = MKMapPointForCoordinate(CLLocationCoordinate2DMake(bounds.xf, bounds.yf));
    return MKMapRectMake(topLeft.x, botRight.y, fabs(botRight.x - topLeft.x), fabs(botRight.y - topLeft.y));
}

BOOL ISBoundsContainsCoordinate(ISBounds bounds, CLLocationCoordinate2D coordinate) {
    BOOL containsX = bounds.x0 <= coordinate.latitude && coordinate.latitude <= bounds.xf;
    BOOL containsY = bounds.y0 <= coordinate.longitude && coordinate.longitude <= bounds.yf;
    return containsX && containsY;
}

BOOL ISBoundsIntersectsBounds(ISBounds bounds1, ISBounds bounds2) {
    return (bounds1.x0 <= bounds2.xf && bounds1.xf >= bounds2.x0 && bounds1.y0 <= bounds2.yf && bounds1.yf >= bounds2.y0);
}

@end
