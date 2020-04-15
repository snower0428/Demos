//
//  VPGPUImageBlendFilter.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/23.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "VPGPUImageBlendFilter.h"

NSString *const kVPGPUImageBlendFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main() {
    
    lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    lowp vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinate2);
    
    lowp vec3 color = vec3(textureColor2.r, textureColor2.g, textureColor2.b);
//    lowp float r = textureColor2.r;
//    lowp float g = textureColor2.g;
//    lowp float b = textureColor2.b;
//    lowp float a = textureColor2.a;
//    if (textureColor2.r == textureColor2.r &&
//        textureColor2.g == textureColor2.g &&
//        textureColor2.b == textureColor2.b) {
//        r = textureColor2.r * textureColor2.a + textureColor.r * (1.0 - textureColor2.a);
//        g = textureColor2.g * textureColor2.g + textureColor.g * (1.0 - textureColor2.g);
//        b = textureColor2.b * textureColor2.b + textureColor.b * (1.0 - textureColor2.b);
//        a = textureColor2.a * textureColor2.a + textureColor.a * (1.0 - textureColor2.a);
//    }
        if (textureColor2.r <= 0.01 && textureColor2.g <= 1.0 && textureColor2.b <= 0.01) {
            color = vec3(textureColor.r, textureColor.g, textureColor.b);
        }
        gl_FragColor = vec4(color, textureColor.a);
    }
);

@implementation VPGPUImageBlendFilter

- (id)init {
    
    if (!(self = [super initWithFragmentShaderFromString:kVPGPUImageBlendFragmentShaderString])) {
        return nil;
    }
    
    return self;
}

@end
