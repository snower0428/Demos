//
//  OpenGLCh2ViewController001.m
//  OpenGLDemo
//
//  Created by leihui on 2020/3/26.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "OpenGLCh2ViewController001.h"

// This data type is used to store information for each vertex
typedef struct {
    
    GLKVector3 positionCoords;
}
SceneVertex;

// Define vertex data for a triangle to use in example
static const SceneVertex vertices[] = {
    
    {{-0.5f, -0.5f, 0.0}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0}}, // lower right corner
    {{-0.5f,  0.5f, 0.0}}  // upper left corner
};

@interface OpenGLCh2ViewController001 () {
    
    GLuint vertexBufferId;
}

@property (nonatomic, strong) GLKBaseEffect *baseEffect;

@end

@implementation OpenGLCh2ViewController001

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    
    // Create an OpenGL ES 2.0 context and provide it to the view
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Make the new context current
    [EAGLContext setCurrentContext:view.context];
    
    // Create a base effect that provides standard OpenGL ES 2.0
    // Shading Language programs and set constants to be used for
    // all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, // Red
                                                   1.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha
    
    // Set the background color stored in the current context
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f); // background color
    
    // STEP 1
    glGenBuffers(1, &vertexBufferId);
    
    // STEP 2
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferId);
    
    // STEP 3
    glBufferData(GL_ARRAY_BUFFER,   // Initialize buffer contents
                 sizeof(vertices),  // Number of bytes to copy
                 vertices,          // Address of bytes to copy
                 GL_STATIC_DRAW);   // Hint: cache in GPU memory
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [self.baseEffect prepareToDraw];
    
    // Clear Frame Buffer (erase previous drawing)
    glClear(GL_COLOR_BUFFER_BIT);
    
    // STEP 4
    // Enable use of positions from bound vertex buffer
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    // STEP 5
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,                    // three components per vertex
                          GL_FLOAT,             // data is floating point
                          GL_FALSE,             // no fixed point scaling
                          sizeof(SceneVertex),  // no gaps in data
                          NULL);                // NULL tells GPU to start at
                                                // beginning of bound buffer
    
    // STEP 6
    // Draw triangles using the first three vertices in the
    // currently bound vertex buffer
    glDrawArrays(GL_TRIANGLES,
                 0,  // Start with first vertex in currently bound buffer
                 3); // Use three vertices from currently bound buffer
}

- (void)dealloc {
    
    // Delete buffers that aren't needed when view is unloaded
    if (0 != vertexBufferId) {
        // STEP 7
       glDeleteBuffers (1, &vertexBufferId);
       vertexBufferId = 0;
    }
}

@end
