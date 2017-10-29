//
//  ISClusterDisplaySetting.h
//  ISClusterMapFrameworkExample
//
//  Created by dima on 14.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ISDisplayBackgroundStyle) {
    ISDisplayBackgroundStyleLogicGradient = 0,
    ISDisplayBackgroundStyleSolid
};

@interface ISClusterDisplaySetting : NSObject

@property (nonatomic) ISDisplayBackgroundStyle displayBackgroundStyle;

@property (assign, nonatomic) UIColor *markerBackgroundColor;

@property (assign, nonatomic) UIColor *markerBorderColor;

@property (assign, nonatomic) UIColor *markerTextColor;

@property (assign, nonatomic) UIFont *markerFont;

@property (nonatomic) CGSize scaleFactor;

@end
