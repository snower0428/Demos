//
//  VPGPUImageMaskFilter.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/23.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "VPGPUImageMaskFilter.h"

NSString *const kVPGPUImageMaskShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2);
     
     //Averages mask's the RGB values, and scales that value by the mask's alpha
     //
     //The dot product should take fewer cycles than doing an average normally
     //
     //Typical/ideal case, R,G, and B will be the same, and Alpha will be 1.0
     lowp float newAlpha = dot(textureColor2.rgb, vec3(.33333334, .33333334, .33333334)) * textureColor2.a;
          
     gl_FragColor = vec4(textureColor.xyz, newAlpha);
//     gl_FragColor = vec4(textureColor2);
 }
);

@implementation VPGPUImageMaskFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kVPGPUImageMaskShaderString]))
    {
        return nil;
    }
    
    return self;
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//    glBlendFunc(GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);
    [super renderToTextureWithVertices:vertices textureCoordinates:textureCoordinates];
    glDisable(GL_BLEND);
}

@end
