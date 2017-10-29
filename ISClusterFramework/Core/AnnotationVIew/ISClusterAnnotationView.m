//
//  ISClusterAnnotationView.m
//  ISClusterMapFrameworkExample
//
//  Created by dima on 14.10.17.
//  Copyright © 2017 dima. All rights reserved.
//

#import "ISClusterAnnotationView.h"
#import "ISClusterAnnotation.h"

NSInteger const kISClusterAnnotationViewLabelNumberOfLinesDefault = 1;
CGFloat const ISScaleFactorAlphaDefault = 0.3f;
CGFloat const ISScaleFactorBetaDefault = 0.4f;

CGPoint ISRectCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGRect ISCenterRect(CGRect rect, CGPoint center) {
    CGRect r = CGRectMake(center.x - rect.size.width/2.0,
                          center.y - rect.size.height/2.0,
                          rect.size.width,
                          rect.size.height);
    return r;
}

CGFloat ISScaledValueForValue(CGFloat value, CGSize scaleFactor) {
    return 1.0 / (1.0 + expf(-1 * ((scaleFactor.width > 0.f)? scaleFactor.width : ISScaleFactorAlphaDefault) * powf(value, (scaleFactor.height > 0.f) ? scaleFactor.height : ISScaleFactorBetaDefault)));
}

@interface ISClusterAnnotationView ()

@property (strong, nonatomic) UILabel *lblCount;

@end

@implementation ISClusterAnnotationView

#pragma mark - Lifecycle

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.frame = CGRectMake(0,0,44,44);
        self.backgroundColor = [UIColor clearColor];
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.lblCount = [[UILabel alloc] initWithFrame:self.frame];
    self.lblCount.backgroundColor = [UIColor clearColor];
    self.lblCount.textAlignment = NSTextAlignmentCenter;
    self.lblCount.shadowColor = [UIColor clearColor];
    self.lblCount.shadowOffset = CGSizeMake(0, 0);
    self.lblCount.adjustsFontSizeToFitWidth = YES;
    self.lblCount.numberOfLines = kISClusterAnnotationViewLabelNumberOfLinesDefault;
    self.lblCount.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:self.lblCount];
}

#pragma mark - Setters

- (void)setAnnotations:(NSArray<MKAnnotationView *> *)annotations {
    _annotations = annotations;
    self.lblCount.textColor = self.displaySettings.markerTextColor;
    self.lblCount.font = self.displaySettings.markerFont;
    if (self.annotations.count != 1) {
        self.lblCount.hidden = NO;
        CGRect newBounds = CGRectMake(0, 0, roundf(44 * ISScaledValueForValue(self.annotations.count, self.displaySettings.scaleFactor)), roundf(44 * ISScaledValueForValue(self.annotations.count, self.displaySettings.scaleFactor)));
        self.frame = ISCenterRect(newBounds, self.center);
        CGRect newLabelBounds = CGRectMake(0, 0, newBounds.size.width / 1.3, newBounds.size.height / 1.3);
        self.lblCount.frame = ISCenterRect(newLabelBounds, ISRectCenter(newBounds));
        self.lblCount.text = [@(self.annotations.count) stringValue];
    } else {
        CGRect newBounds = CGRectMake(0, 0, roundf(44 * ISScaledValueForValue(self.annotations.count, self.displaySettings.scaleFactor)), roundf(44 * ISScaledValueForValue(self.annotations.count, self.displaySettings.scaleFactor)));
        self.frame = ISCenterRect(newBounds, self.center);
        CGRect newLabelBounds = CGRectMake(0, 0, newBounds.size.width / 1.3, newBounds.size.height / 1.3);
        self.lblCount.frame = ISCenterRect(newLabelBounds, ISRectCenter(newBounds));
        self.lblCount.text = @"";
        self.lblCount.hidden = YES;
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    UIColor *outerCircleStrokeColor = [UIColor colorWithWhite:0 alpha:0.25];
    UIColor *innerCircleStrokeColor = [self innerStrokeColor];
    UIColor *innerCircleFillColor = [self innerFillColor];
    
    CGRect circleFrame = CGRectInset(rect, 4, 4);
    
    [outerCircleStrokeColor setStroke];
    CGContextSetLineWidth(context, 5.0);
    CGContextStrokeEllipseInRect(context, circleFrame);
    
    [innerCircleStrokeColor setStroke];
    CGContextSetLineWidth(context, 4);
    CGContextStrokeEllipseInRect(context, circleFrame);
    
    [innerCircleFillColor setFill];
    CGContextFillEllipseInRect(context, circleFrame);
}

#pragma mark - Helpers

- (UIColor *)innerStrokeColor {
    if (self.displaySettings.markerBorderColor) {
        return self.displaySettings.markerBorderColor;
    }
    
    return [UIColor whiteColor];
}

- (UIColor *)innerFillColor {
    switch (self.displaySettings.displayBackgroundStyle) {
        case ISDisplayBackgroundStyleLogicGradient:
            return [self innerGradientFillColor];
            break;
        case ISDisplayBackgroundStyleSolid:
            return self.displaySettings.markerBackgroundColor;
            break;
    }
    return [UIColor redColor];
}

- (UIColor *)innerGradientFillColor {
    if (self.annotations.count > 0 && self.annotations.count <= 20) {
        return [UIColor redColor];
    }
    if (self.annotations.count > 20 && self.annotations.count <= 50) {
        return [UIColor greenColor];
    }
    if (self.annotations.count > 50 && self.annotations.count <= 100) {
        return [UIColor orangeColor];
    }
    
    return [UIColor blueColor];
}

@end
