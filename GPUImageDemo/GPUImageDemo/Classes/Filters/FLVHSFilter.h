//
//  FLVHSFilter.h
//  HMShaderFilterKit
//
//  Created by 敏 胡 on 17/3/14.
//  Copyright © 2017年 humin. All rights reserved.
//

@interface FLVHSFilter : GPUImageTwoInputFilter
{
    GLint timeUniform;
}
// time ranges from -1.0 to 1.0, with 0.0 as the normal level
@property(readwrite, nonatomic) CGFloat time;

- (id)initWithVideoURL:(NSURL *)url;

@end
