//
//  ISAnnotaionLocation.m
//  ISClusterMapFrameworkExample
//
//  Created by dima on 14.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import "ISAnnotaionLocation.h"

@implementation ISAnnotaionLocation

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.coordinate = CLLocationCoordinate2DMake([[dict objectForKey:@"lat"] floatValue], [[dict objectForKey:@"long"] floatValue]);
    }
    return self;
}

@end
