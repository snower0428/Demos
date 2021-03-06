//
//  FLChromaKeyBlendFilter.h
//  Pods
//
//  Created by imac on 2017/3/17.
//
//

typedef void(^keyColorCallback)(UIImage *arg1);

@interface FLChromaKeyBlendFilter : GPUImageTwoInputFilter
{
    GLint keyColorsUniform;
    GLint keyLumaFactorUniform;
    GLint thresholdSensitivityUniform;
    GLint smoothingUniform;
    GLint maxBlendUniform;
    GLint displacementUniform;
    GLint blendUniform;
    
    float *keyColorsArray;
    float *keyLumaFactorArray;
    keyColorCallback keyColorCallback;
    BOOL shouldAutokey;
    struct CGPoint colorAtPoint;
    float _thresholdSensitivity;
    float _smoothing;
    float _blend;
    float _maxBlend;
    float _displacement;
}
@property(nonatomic) float smoothing; // @synthesize smoothing=_smoothing;
@property(nonatomic) float thresholdSensitivity; // @synthesize thresholdSensitivity=_thresholdSensitivity;

- (void)addKeyColorAtPoint:(CGPoint)point withCallback:(keyColorCallback)block;
- (void)detectKeyColorWithCallback:(keyColorCallback)block;
- (void)addDefaultKeyColorAtImage:(UIImage *)image;
- (void)addKeyColor:(UIColor *)color;
- (void)addKeyColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end
