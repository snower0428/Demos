//
//  UIColor+ExpandedAdditions.m
//  Pods
//
//  Created by imac on 2017/3/21.
//
//

#import "UIColor+ExpandedAdditions.h"

@implementation UIColor(ExpandedAdditions)

- (CGColorSpaceModel)colorSpaceModel {
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (BOOL)canProvideRGBComponents {
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            return YES;
        default:
            return NO;
    }
}

- (CGFloat)red {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat)green {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
    return c[1];
}

- (CGFloat)blue {
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if (self.colorSpaceModel == kCGColorSpaceModelMonochrome) return c[0];
    return c[2];
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

- (CGFloat)luminance {
    NSAssert(self.canProvideRGBComponents, @"Must be a RGB color to use luminance");
    
    CGFloat r,g,b;
    if (![self red:&r green:&g blue:&b alpha:nil]) return 0.0f;
    
    // http://en.wikipedia.org/wiki/Luma_(video)
    // Y = 0.2126 R + 0.7152 G + 0.0722 B
    
    return r*0.2126f + g*0.7152f + b*0.0722f;
}

- (BOOL)red:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r,g,b,a;
    
    switch (self.colorSpaceModel) {
        case kCGColorSpaceModelMonochrome:
            r = g = b = components[0];
            a = components[1];
            break;
        case kCGColorSpaceModelRGB:
            r = components[0];
            g = components[1];
            b = components[2];
            a = components[3];
            break;
        default:	// We don't know how to handle this model
            return NO;
    }
    
    if (red) *red = r;
    if (green) *green = g;
    if (blue) *blue = b;
    if (alpha) *alpha = a;
    
    return YES;
}

#pragma mark - YUV

// Conversion with help from http://www.fourcc.org/fccyvrgb.php
- (CGFloat)yValue
{
    // RGB -> YUV conversion assumes 0-255 scale for components
    CGFloat r,g,b,a;
    if ( ![self getRed:&r green:&g blue:&b alpha:&a] ) {
        return -1;
    }
    
    r *= 255;
    g *= 255;
    b *= 255;
    
    CGFloat y = (0.257 * r) + (0.504 * g) + (0.098 * b) + 16;
    y = MIN(MAX(0,y),255);
    return y;
}

- (CGFloat)uValue
{
    // RGB -> YUV conversion assumes 0-255 scale for components
    CGFloat r,g,b,a;
    if ( ![self getRed:&r green:&g blue:&b alpha:&a] ) {
        return -1;
    }
    
    r *= 255;
    g *= 255;
    b *= 255;
    
    CGFloat u = -(0.148 * r) - (0.291 * g) + (0.439 * b) + 128;
    u = MIN(MAX(0,u),255);
    return u;
}

- (CGFloat)vValue
{
    // RGB -> YUV conversion assumes 0-255 scale for components
    CGFloat r,g,b,a;
    if ( ![self getRed:&r green:&g blue:&b alpha:&a] ) {
        return -1;
    }
    
    r *= 255;
    g *= 255;
    b *= 255;
    
    CGFloat v = (0.439 * r) - (0.368 * g) - (0.071 * b) + 128;
    v = MIN(MAX(0,v),255);
    return v;
}

#pragma mark -
#pragma mark new 算法

- (CGFloat)tmplumaY
{
    CGFloat r,g,b,a;
    if ( ![self getRed:&r green:&g blue:&b alpha:&a] ) {
        return 0;
    }
    return r*0.2989 + g*0.5866 + b*0.1145;
}

- (CGFloat)lumaFactor
{
    CGFloat r,g,b,a;
    if ( ![self getRed:&r green:&g blue:&b alpha:&a] ) {
        return -1;
    }
    
    float Cb = [self uuValue];
    float Cr = [self vvValue];
    float D10 = [self tmplumaY];
    
    double sinOut = sin(0.6+D10*1.2);
    sinOut = sinOut * -3.8;
    sinOut = sinOut +4.0;
    float D17 = 0.0;
    if (sinOut>0.0) {
        D17 = sinOut;
    }
    float colorChoose = 0.0;
    float CrD16 = fabsf(Cr);
    float CrD17 = fabsf(Cb);
    colorChoose = CrD16;
    if (CrD16<CrD17) {
        colorChoose = CrD17;
    }
    
    float D12 = colorChoose/0.1;
    float D18 = (1.0-D12);
    if (D12>1.0) {
        D18 = 0.0;
    }
    float lumaFactorDict = (D17*D18);//D18 = 0.8109648323839
    return lumaFactorDict;
}
- (CGFloat)yyValue
{
    float D10 = [self tmplumaY];
    float lumaFactorDict = [self lumaFactor];
    float yDict = D10*lumaFactorDict;
    return yDict;
}
- (CGFloat)uuValue
{
    CGFloat r,g,b,a;
    if ( ![self getRed:&r green:&g blue:&b alpha:&a] ) {
        return -1;
    }
    float r4 = (b - [self tmplumaY]);
    float Cb = 0.5647*r4;
    return Cb;
}
- (CGFloat)vvValue
{
    CGFloat r,g,b,a;
    if ( ![self getRed:&r green:&g blue:&b alpha:&a] ) {
        return -1;
    }
    float r3 = (r - [self tmplumaY]);
    float Cr = 0.7132*r3;
    return Cr;
}

@end
