//
//  GPUImageCustomThreeFilter.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/11.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageCustomThreeFilter.h"

NSString *const kGPUImageThreeCustomMaskShaderString = SHADER_STRING
(
    varying highp vec2 textureCoordinate;
    varying highp vec2 textureCoordinate2;
    varying highp vec2 textureCoordinate3;

    uniform sampler2D inputImageTexture;
    uniform sampler2D inputImageTexture2;
    uniform sampler2D inputImageTexture3;
 
    void main()
    {
        lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
        lowp vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2);
        lowp vec4 textureColor3 = texture2D(inputImageTexture3, textureCoordinate3);
      
        //Averages mask's the RGB values, and scales that value by the mask's alpha
        //
        //The dot product should take fewer cycles than doing an average normally
        //
        //Typical/ideal case, R,G, and B will be the same, and Alpha will be 1.0
        lowp float newAlpha = dot(textureColor3.rgb, vec3(.33333334, .33333334, .33333334)) * textureColor3.a;
        
        lowp float r = textureColor.r + textureColor2.r;
        lowp float g = textureColor.g + textureColor2.g;
        lowp float b = textureColor.b + textureColor2.b;
        gl_FragColor = vec4(r, g, b, 1.0);
//        gl_FragColor = vec4(textureColor2.xyz, newAlpha);
//        gl_FragColor = vec4(textureColor3);
    }
);

@implementation GPUImageCustomThreeFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageThreeCustomMaskShaderString]))
    {
        return nil;
    }
    
    return self;
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [super renderToTextureWithVertices:vertices textureCoordinates:textureCoordinates];
    glDisable(GL_BLEND);
}

@end
