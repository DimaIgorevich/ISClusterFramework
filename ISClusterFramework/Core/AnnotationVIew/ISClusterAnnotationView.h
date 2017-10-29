//
//  ISClusterAnnotationView.h
//  ISClusterMapFrameworkExample
//
//  Created by dima on 14.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ISClusterDisplaySetting.h"

@interface ISClusterAnnotationView : MKAnnotationView

@property (assign, nonatomic) ISClusterDisplaySetting *displaySettings;

@property (assign, nonatomic) NSArray <MKAnnotationView *> *annotations;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
