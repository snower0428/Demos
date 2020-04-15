//
//  GPUImageRemap.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/24.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageRemap.h"

NSString *const kGPUImageRemapFragmentShaderString = SHADER_STRING
(

 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
  varying highp vec2 textureCoordinate3;

 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
  uniform sampler2D inputImageTexture3;

 /*
 x, y map orignally store floating point numbers in [0 imageWidth] and [0 imageHeight]
 then they are divided by imageWidth-1 and imageHeight-1 to be in [0 1]
 then they are converted to integer by multiply 1000000
 then an integer is put in the 4 byte of RGBA channel
 then each unsigned byte RGBA component is clamped to [0 1] and passed to fragment shader
 therefore, do the inverse in fragment shader to get original x, y coordinates
 */
 void main()
 {
     highp vec4 xAry0_1 = texture2D(inputImageTexture2, textureCoordinate2);
     highp vec4 xAry0_255=floor(xAry0_1*vec4(255.0)+vec4(0.5));
     //largest integer number we may see will not exceed 2000000, so 3 bytes are enough to carry our integer values
     highp float xint=xAry0_255.b*exp2(16.0)+xAry0_255.g*exp2(8.0)+xAry0_255.r;
     highp float x=xint/1000000.0;

     highp vec4 yAry0_1 = texture2D(inputImageTexture3, textureCoordinate3);
     highp vec4 yAry0_255=floor(yAry0_1*vec4(255.0)+vec4(0.5));
     highp float yint=yAry0_255.b*exp2(16.0)+yAry0_255.g*exp2(8.0)+yAry0_255.r;
     highp float y=yint/1000000.0;

     if (x<0.0 || x>1.0 || y<0.0 || y>1.0)
     {
         gl_FragColor = vec4(0,0,0,1);
     }
     else
     {
         highp vec2 imgTexCoord=vec2(y, x);
         gl_FragColor = texture2D(inputImageTexture, imgTexCoord);
     }
 }
);

@implementation GPUImageRemap

- (id)init
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageRemapFragmentShaderString]))
    {
        return nil;
    }
    return self;
}

@end
