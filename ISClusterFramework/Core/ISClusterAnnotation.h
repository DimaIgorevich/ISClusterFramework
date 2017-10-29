//
//  ISClusterAnnotation.h
//  ISClusterMapFrameworkExample
//
//  Created by dima on 14.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ISClusterAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) NSArray *annotations;

@end
