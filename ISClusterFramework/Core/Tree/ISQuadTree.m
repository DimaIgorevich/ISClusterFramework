//
//  ISQuadTree.m
//  ISClusterMapFrameworkExample
//
//  Created by dima on 14.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import "ISQuadTree.h"

@implementation ISQuadTree

- (id)init {
    if (self = [super init]) {
        self.rootNode = [[ISQuadTreeNode alloc] initWithBounds:ISBoundsForMapRect(MKMapRectWorld)];
    }
    return self;
}

- (BOOL)insertAnnotation:(id<MKAnnotation>)annotation {
    return [self insertAnnotation:annotation toNode:self.rootNode];
}

- (BOOL)removeAnnotation:(id<MKAnnotation>)annotation {
    return [self removeAnnotation:annotation fromNode:self.rootNode];
}

- (BOOL)removeAnnotation:(id<MKAnnotation>)annotation fromNode:(ISQuadTreeNode *)node {
    if (!ISBoundsContainsCoordinate(node.bounds, annotation.coordinate)) {
        return NO;
    }
    
    if ([node.annotations containsObject:annotation]) {
        [node.annotations removeObject:annotation];
        node.count--;
        return YES;
    }
    
    if ([self removeAnnotation:annotation fromNode:node.northEast]) return YES;
    if ([self removeAnnotation:annotation fromNode:node.northWest]) return YES;
    if ([self removeAnnotation:annotation fromNode:node.southEast]) return YES;
    if ([self removeAnnotation:annotation fromNode:node.southWest]) return YES;
    
    return NO;
}


- (BOOL)insertAnnotation:(id<MKAnnotation>)annotation toNode:(ISQuadTreeNode *)node {
    if (!ISBoundsContainsCoordinate(node.bounds, annotation.coordinate)) {
        return NO;
    }
    
    if (node.count < kNodeCapacityDefault) {
        node.annotations[node.count++] = annotation;
        return YES;
    }
    
    if ([node isLeaf]) {
        [node subdivide];
    }
    
    if ([self insertAnnotation:annotation toNode:node.northEast]) return YES;
    if ([self insertAnnotation:annotation toNode:node.northWest]) return YES;
    if ([self insertAnnotation:annotation toNode:node.southEast]) return YES;
    if ([self insertAnnotation:annotation toNode:node.southWest]) return YES;
    
    return NO;
}

- (void)enumerateAnnotationsInBounds:(ISBounds)bounds usingBlock:(void (^)(id<MKAnnotation> obj))block {
    [self enumerateAnnotationsInBounds:bounds withNode:self.rootNode usingBlock:block];
}

- (void)enumerateAnnotationsUsingBlock:(void (^)(id<MKAnnotation>))block {
    [self enumerateAnnotationsInBounds:ISBoundsForMapRect(MKMapRectWorld) withNode:self.rootNode usingBlock:block];
}

- (void)enumerateAnnotationsInBounds:(ISBounds)bounds withNode:(ISQuadTreeNode*)node usingBlock:(void (^)(id<MKAnnotation>))block {
    if (!ISBoundsIntersectsBounds(node.bounds, bounds)) {
        return;
    }
    
    NSArray *tempArray = [node.annotations copy];
    
    for (id<MKAnnotation> annotation in tempArray) {
        if (ISBoundsContainsCoordinate(bounds, annotation.coordinate)) {
            block(annotation);
        }
    }
    
    if ([node isLeaf]) {
        return;
    }
    
    [self enumerateAnnotationsInBounds:bounds withNode:node.northEast usingBlock:block];
    [self enumerateAnnotationsInBounds:bounds withNode:node.northWest usingBlock:block];
    [self enumerateAnnotationsInBounds:bounds withNode:node.southEast usingBlock:block];
    [self enumerateAnnotationsInBounds:bounds withNode:node.southWest usingBlock:block];
}

@end
