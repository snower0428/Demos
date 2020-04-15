//
//  FLVHSFilter.m
//  HMShaderFilterKit
//
//  Created by 敏 胡 on 17/3/14.
//  Copyright © 2017年 humin. All rights reserved.
//

#import "FLVHSFilter.h"
#import "FLChromaKeyFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE

NSString *const kGPUImageFLVHSFilterFragmentShaderString = SHADER_STRING
(
precision highp float; varying vec2 textureCoordinate; varying vec2 textureCoordinate2; uniform sampler2D inputImageTexture; uniform sampler2D inputImageTexture2; uniform float time; const highp vec3 W = vec3(0.2125, 0.7154, 0.0721); highp float rand(vec2 co) { highp float a = 12.9898; highp float b = 78.233; highp float c = 43758.5453; highp float dt= dot(co.xy ,vec2(a,b)); highp float sn= mod(dt,3.14); return fract(sin(sn) * c); } vec4 rgbDistortion(vec2 uv, sampler2D texture, highp float magnitude) { float t = time; vec3 offsetX = vec3( uv.x ); offsetX.r += rand(vec2(t*0.03,uv.y*0.42)) * 0.001 + sin(rand(vec2(t*0.2, uv.y)))*magnitude; offsetX.g += rand(vec2(t*0.004,uv.y*0.002)) * 0.004 + sin(t*9.0)*magnitude; vec4 rgb = texture2D(texture, vec2(offsetX.r, uv.y)); return vec4( rgb.r, texture2D(texture, vec2(offsetX.g, uv.y)).g, texture2D(texture, vec2(offsetX.b, uv.y)).b, rgb.a ); } void main() { lowp vec4 videoTexture = texture2D(inputImageTexture2, textureCoordinate2); lowp vec4 color = rgbDistortion(textureCoordinate, inputImageTexture, 0.01); color.rgb = mix(vec3(dot(color.rgb, W)), color.rgb, 2.); gl_FragColor = mix(color, videoTexture, videoTexture.a) * color.a; }
 );
#endif

@interface FLVHSFilter()

@property(strong, nonatomic) GPUImageTransformFilter *textureVideo;
@property(strong, nonatomic) FLChromaKeyFilter *chromaKey;
@property(strong, nonatomic) NSURL *url;

@end

@implementation FLVHSFilter

@synthesize time = _time;

- (id)initWithVideoURL:(NSURL *)url
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageFLVHSFilterFragmentShaderString]))
    {
        return nil;
    }
    self.url = url;
    timeUniform = [filterProgram uniformIndex:@"time"];
    return self;
}

#pragma mark -
#pragma mark Accessors
- (void)setTime:(CGFloat)newValue
{
    _time = newValue;
    [self setFloat:newValue forUniform:timeUniform program:filterProgram];
}


#pragma mark -
#pragma mark base class

- (void)addTarget:(id<GPUImageInput>)newTarget;
{
    [super addTarget:newTarget];
    if (!self.textureVideo) {
        
        self.chromaKey = [[FLChromaKeyFilter alloc] init];//GPUImageChromaKeyFilter
        [self.chromaKey setThresholdSensitivity:1061158912];
        [self.chromaKey setSmoothing:1056964608];
        
        self.textureVideo = [[GPUImageTransformFilter alloc] init];
        
        [self.textureVideo addTarget:self.chromaKey];
        [self.chromaKey addTarget:self];
    }
}
- (void)removeAllTargets;
{
    [self.chromaKey removeAllTargets];
    [self.textureVideo removeAllTargets];
    [super removeAllTargets];
    [self endProcessing];
}
- (void)endProcessing
{
    [self.textureVideo endProcessing];
    [super endProcessing];
}
- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
{
    float fTime = CMTimeGetSeconds(frameTime);
    CGFloat newValue = fmodf(fTime, 6.0);
    [self setTime:newValue];
    [super newFrameReadyAtTime:frameTime atIndex:textureIndex];
}

@end
