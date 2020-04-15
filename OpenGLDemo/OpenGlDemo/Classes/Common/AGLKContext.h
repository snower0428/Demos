//
//  AGLKContext.h
//  OpenGLDemo
//
//  Created by leihui on 2020/3/26.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGLKContext : EAGLContext {
    
    GLKVector4 clearColor;
}

@property (nonatomic, assign, readwrite) GLKVector4 clearColor;

- (void)clear:(GLbitfield)mask;
- (void)enable:(GLenum)capability;
- (void)disable:(GLenum)capability;
- (void)setBlendSourceFunction:(GLenum)sfactor destinationFunction:(GLenum)dfactor;

@end

NS_ASSUME_NONNULL_END
