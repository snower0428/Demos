//
//  UIColor+ExpandedAdditions.h
//  Pods
//
//  Created by imac on 2017/3/21.
//
//

#import <UIKit/UIKit.h>

@interface UIColor(ExpandedAdditions)

@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) BOOL canProvideRGBComponents;

// With the exception of -alpha, these properties will function
// correctly only if this color is an RGB or white color.
// In these cases, canProvideRGBComponents returns YES.
@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly) CGFloat luminance;
@property (nonatomic, readonly) CGFloat yValue;
@property (nonatomic, readonly) CGFloat uValue;
@property (nonatomic, readonly) CGFloat vValue;

@property (nonatomic, readonly) CGFloat lumaFactor;
@property (nonatomic, readonly) CGFloat yyValue;
@property (nonatomic, readonly) CGFloat uuValue;
@property (nonatomic, readonly) CGFloat vvValue;

// Bulk access to RGB and HSB components of the color
// HSB components are converted from the RGB components
- (BOOL)red:(CGFloat *)r green:(CGFloat *)g blue:(CGFloat *)b alpha:(CGFloat *)a;

@end
