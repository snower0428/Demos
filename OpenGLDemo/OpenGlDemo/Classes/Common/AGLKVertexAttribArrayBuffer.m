//
//  AGLKVertexAttribArrayBuffer.m
//  OpenGLDemo
//
//  Created by leihui on 2020/3/26.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@interface AGLKVertexAttribArrayBuffer ()

@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;
@property (nonatomic, assign) GLsizei stride;
@property (nonatomic, assign) GLuint name;

@end

@implementation AGLKVertexAttribArrayBuffer

- (id)initWithAttribStride:(GLsizei)stride
          numberOfVertices:(GLsizei)count
                     bytes:(const GLvoid *)dataPtr
                     usage:(GLenum)usage {
    
    NSParameterAssert(0 < stride);
    NSAssert((0 < count && NULL != dataPtr) || (0 == count && NULL == dataPtr), @"data must not be NULL or count > 0");
    
    if (self = [super init]) {
        _stride = stride;
        _bufferSizeBytes = stride * count;
    }
    
    // STEP 1
    glGenBuffers(1, &_name);
    // STEP 2
    glBindBuffer(GL_ARRAY_BUFFER, _name);
    // STEP 3
    glBufferData(GL_ARRAY_BUFFER,   // Initialize buffer contents
                 _bufferSizeBytes,  // Number of bytes to copy
                 dataPtr,           // Address of bytes to copy
                 usage);            // Hint: cache in GPU memory
       
    NSAssert(0 != _name, @"Failed to generate name");
    
    return self;
}

// This method loads the data stored by the receiver.
- (void)reinitWithAttribStride:(GLsizei)stride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr {
    
    NSParameterAssert(0 < stride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    NSAssert(0 != _name, @"Invalid name");
    
    self.stride = stride;
    self.bufferSizeBytes = stride * count;
    
    // STEP 2
    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    // STEP 3
    glBufferData(GL_ARRAY_BUFFER,   // Initialize buffer contents
                 _bufferSizeBytes,  // Number of bytes to copy
                 dataPtr,           // Address of bytes to copy
                 GL_DYNAMIC_DRAW);
}

// A vertex attribute array buffer must be prepared when your
// application wants to use the buffer to render any geometry.
// When your application prepares an buffer, some OpenGL ES state
// is altered to allow bind the buffer and configure pointers.
- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable {
    
    NSParameterAssert((0 < count) && (count < 4));
    NSParameterAssert(offset < self.stride);
    NSAssert(0 != _name, @"Invalid name");

    // STEP 2
    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    
    if(shouldEnable) {
        // Step 4
        glEnableVertexAttribArray(index);
    }

    // Step 5
    glVertexAttribPointer(index,                // Identifies the attribute to use
                          count,                // number of coordinates for attribute
                          GL_FLOAT,             // data is floating point
                          GL_FALSE,             // no fixed point scaling
                          (self.stride),        // total num bytes stored per vertex
                          NULL + offset);       // offset from start of each vertex to
                                                // first coord for attribute
#ifdef DEBUG
    {   // Report any errors
        GLenum error = glGetError();
        if(GL_NO_ERROR != error) {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
}

// Submits the drawing command identified by mode and instructs
// OpenGL ES to use count vertices from the buffer starting from
// the vertex at index first. Vertex indices start at 0.
- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count {
    
    NSAssert(self.bufferSizeBytes >= ((first + count) * self.stride), @"Attempt to draw more vertex data than available.");
    
    // Step 6
    glDrawArrays(mode, first, count);
}

// Submits the drawing command identified by mode and instructs
// OpenGL ES to use count vertices from previously prepared
// buffers starting from the vertex at index first in the
// prepared buffers
+ (void)drawPreparedArraysWithMode:(GLenum)mode
                  startVertexIndex:(GLint)first
                  numberOfVertices:(GLsizei)count {
    // Step 6
    glDrawArrays(mode, first, count);
}

// This method deletes the receiver's buffer from the current
// Context when the receiver is deallocated.
- (void)dealloc {
    
    // Delete buffer from current context
    if (0 != _name) {
        // Step 7
        glDeleteBuffers (1, &_name);
        _name = 0;
    }
}

@end
