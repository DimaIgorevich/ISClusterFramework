//
//  ISQuadTree.h
//  ISClusterMapFrameworkExample
//
//  Created by dima on 14.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISQuadTreeNode.h"

@interface ISQuadTree : NSObject

@property (nonatomic, strong) ISQuadTreeNode *rootNode;

- (BOOL)insertAnnotation:(id<MKAnnotation>)annotation;

- (BOOL)removeAnnotation:(id<MKAnnotation>)annotation;

- (void)enumerateAnnotationsInBounds:(ISBounds)bounds usingBlock:(void (^)(id<MKAnnotation> obj))block;

- (void)enumerateAnnotationsUsingBlock:(void (^)(id<MKAnnotation> obj))block;

@end
