//
//  AGLKVertexAttribArrayBuffer.h
//  OpenGLDemo
//
//  Created by leihui on 2020/3/26.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGLKVertexAttribArrayBuffer : NSObject

@property (nonatomic, assign, readonly) GLsizeiptr bufferSizeBytes;
@property (nonatomic, assign, readonly) GLsizei stride;
@property (nonatomic, assign, readonly) GLuint name;

- (id)initWithAttribStride:(GLsizei)stride
          numberOfVertices:(GLsizei)count
                     bytes:(const GLvoid *)dataPtr
                     usage:(GLenum)usage;

- (void)reinitWithAttribStride:(GLsizei)stride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr;

- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable;

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count;

+ (void)drawPreparedArraysWithMode:(GLenum)mode
                  startVertexIndex:(GLint)first
                  numberOfVertices:(GLsizei)count;

@end

NS_ASSUME_NONNULL_END
