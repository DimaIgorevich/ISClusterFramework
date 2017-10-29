//
//  ISQuadTreeNode.h
//  ISClusterMapFrameworkExample
//
//  Created by dima on 14.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define kNodeCapacityDefault 8

typedef struct {
    CGFloat x0;
    CGFloat y0;
    CGFloat xf;
    CGFloat yf;
} ISBounds;

ISBounds ISBoundsMake(CGFloat x0, CGFloat y0, CGFloat xf, CGFloat yf);

ISBounds ISBoundsForMapRect(MKMapRect mapRect);
MKMapRect ISMapRectForBounds(ISBounds bounds);

BOOL ISBoundsContainsCoordinate(ISBounds bounds, CLLocationCoordinate2D coordinate);
BOOL ISBoundsIntersectsBounds(ISBounds bounds1, ISBounds bounds2);


@interface ISQuadTreeNode : NSObject

@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) ISBounds bounds;

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic, strong) ISQuadTreeNode *northEast;
@property (nonatomic, strong) ISQuadTreeNode *northWest;
@property (nonatomic, strong) ISQuadTreeNode *southEast;
@property (nonatomic, strong) ISQuadTreeNode *southWest;

- (id)initWithBounds:(ISBounds)bounds;

- (BOOL)isLeaf;

- (void)subdivide;

@end
