//
//  FLChromaKeyFilter.m
//  HMShaderFilterKit
//
//  Created by 敏 胡 on 17/3/14.
//  Copyright © 2017年 humin. All rights reserved.
//

#import "FLChromaKeyFilter.h"
#import "FLColorManager.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE

NSString *const kGPUImageFLChromaKeyFilterFragmentShaderString = SHADER_STRING
(
 precision highp float;
 varying highp vec2 textureCoordinate;
 uniform float thresholdSensitivity;
 uniform float smoothing;
 uniform float maxBlend;
 uniform float keyColors[4 * 3];
 uniform float keyLumaFactor[4];
 uniform sampler2D inputImageTexture;
 vec3 rgb2yuv(vec3 color)
{
    float Y = 0.2989 * color.r + 0.5866 * color.g + 0.1145 * color.b;
    float Cb = 0.5647 * (color.b - Y);
    float Cr = 0.7132 * (color.r - Y);
    return vec3(Y, Cb, Cr);
}
 float chromakey(float lumaFactor, vec3 p, vec3 m)
{
    if (m.x < 0.)
    {
        return 1.;
    }
    p.x *= lumaFactor;
    return distance(p, m);
}
 void main()
{
    vec4 overlayer = texture2D(inputImageTexture, textureCoordinate);
    vec3 yuvPixel = rgb2yuv(overlayer.rgb);
    float blendValue = overlayer.a;
    blendValue = min( blendValue, chromakey(keyLumaFactor[0], yuvPixel, vec3(keyColors[0], keyColors[1], keyColors[2])) );
    float s = smoothing * .16;
    float t = thresholdSensitivity * .2;
    float dropoff = clamp(t - s / 2., 0., 1.);
    float range = dropoff + s;
    blendValue = smoothstep(dropoff, range, blendValue);
    gl_FragColor = vec4(overlayer.rgb, blendValue) * blendValue;
}
);
#endif

@interface FLChromaKeyFilter()

@property(nonatomic) float displacement; // @synthesize displacement=_displacement;
@property(nonatomic) float maxBlend; // @synthesize maxBlend=_maxBlend;
@property(nonatomic) float blend; // @synthesize blend=_blend;

@end

@implementation FLChromaKeyFilter

- (id)init
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageFLChromaKeyFilterFragmentShaderString]))
    {
        return nil;
    }
    keyColorsUniform = [filterProgram uniformIndex:@"keyColors"];
    keyLumaFactorUniform = [filterProgram uniformIndex:@"keyLumaFactor"];
    thresholdSensitivityUniform = [filterProgram uniformIndex:@"thresholdSensitivity"];
    smoothingUniform = [filterProgram uniformIndex:@"smoothing"];
    maxBlendUniform = [filterProgram uniformIndex:@"maxBlend"];
    displacementUniform = [filterProgram uniformIndex:@"displacement"];
    blendUniform = [filterProgram uniformIndex:@"blend"];
    
    [self setThresholdSensitivity:0.15];
    [self setSmoothing:0.3];
    [self setMaxBlend:1065353216];
    [self updateKeyColors];
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    free(keyColorsArray);
    free(keyLumaFactorArray);
    if (firstInputFramebuffer != nil) {
        [[GPUImageContext sharedFramebufferCache] returnFramebufferToCache:firstInputFramebuffer];
    }
}

- (void)setThresholdSensitivity:(float)thresholdSensitivity
{
    _thresholdSensitivity = thresholdSensitivity;
    [self setFloat:thresholdSensitivity forUniform:thresholdSensitivityUniform program:filterProgram];
}
- (void)setSmoothing:(float)smoothing
{
    _smoothing = smoothing;
    [self setFloat:smoothing forUniform:smoothingUniform program:filterProgram];
}
- (void)setMaxBlend:(float)maxBlend
{
    _maxBlend = maxBlend;
    [self setFloat:maxBlend forUniform:maxBlendUniform program:filterProgram];
}

- (void)addKeyColorAtPoint:(CGPoint)point withCallback:(keyColorCallback)block
{
    [self useNextFrameForImageCapture];
    __weak typeof (self) weakSelf = self;
    self.frameProcessingCompletionBlock = ^(GPUImageOutput *output, CMTime time){
        output.frameProcessingCompletionBlock = nil; //断开，否则一直循环调用
        UIImage * image = [output imageFromCurrentFramebuffer];
        [weakSelf updateKeyColorAtPoint:point inImage:image];
        if ([NSThread isMainThread]) {
            block(image);
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(image);
            });
        }
    };
}
- (void)detectKeyColorWithCallback:(keyColorCallback)block
{
    [self runAutoKeyColor];
}
- (void)updateKeyColors
{
    NSArray<FLColorItem *> *keyColors = [[FLColorManager getColorManager] keyColors];
    if ([keyColors count] > 0) {
        for (FLColorItem *item in keyColors) {
            [self setKeyColorWithRed:item.yyValue green:item.uuValue blue:item.vvValue alpha:item.lumaFactor];
        }
    }
    else {
        [self setKeyColorWithRed:-2 green:-2 blue:-2 alpha:0];
        //[self setKeyColorWithRed:0.1545223 green:-0.0002646653 blue:-0.001571815 alpha:0.2036946];
    }
}

- (void)setKeyColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    float keyColors[4 * 3] = {red, green, blue, -2, -2, -2, -2, -2, -2, -2, -2, -2};
    [self setFloatArray:keyColors length:12 forUniform:keyColorsUniform program:filterProgram];
    float keyLumaFactor[4] = {alpha, 0, 0, 0};
    [self setFloatArray:keyLumaFactor length:4 forUniform:keyLumaFactorUniform program:filterProgram];
}

- (void)updateKeyColorAtPoint:(CGPoint)point inImage:(UIImage *)image
{
    [[FLColorManager getColorManager] addKeyColorAtPixel:point inImage:image];
    [self updateKeyColors];
}

- (void)addDefaultKeyColorAtImage:(UIImage *)image
{
    [[FLColorManager getColorManager] addDefaultKeyColorAtImage:image];
    [self updateKeyColors];
}

- (void)addKeyColor:(UIColor *)color
{
    [[FLColorManager getColorManager] addKeyColor:color];
    [self updateKeyColors];
}
- (void)addKeyColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    [self addKeyColor:color];
}

- (void)runAutoKeyColor
{
    UIImage *image = [firstInputFramebuffer newCGImageFromFramebufferContents];
    if (image != nil) {
        [self addDefaultKeyColorAtImage:image];
    }
}

@end
