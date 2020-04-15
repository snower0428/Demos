//
//  OpenGLCh2ViewController003.m
//  OpenGLDemo
//
//  Created by leihui on 2020/3/26.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "OpenGLCh2ViewController003.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

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

@interface OpenGLCh2ViewController003 ()

@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *vertexBuffer;

@end

@implementation OpenGLCh2ViewController003

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View controller's view is not a GLKView");
    
    // Create an OpenGL ES 2.0 context and provide it to the view
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Make the new context current
    [AGLKContext setCurrentContext:view.context];
    
    // Create a base effect that provides standard OpenGL ES 2.0
    // shading language programs and set constants to be used for
    // all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, // Red
                                                   1.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha
    
    // Set the background color stored in the current context
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f, // Red
                                                              0.0f, // Green
                                                              0.0f, // Blue
                                                              1.0f);// Alpha
    
    // Create vertex buffer containing vertices to draw
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex)
                                                                 numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                                                                            bytes:vertices
                                                                            usage:GL_STATIC_DRAW];
}

// GLKView delegate method: Called by the view controller's view
// whenever Cocoa Touch asks the view controller's view to
// draw itself. (In this case, render into a frame buffer that
// shares memory with a Core Animation Layer)
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
   [self.baseEffect prepareToDraw];
   
   // Clear back frame buffer (erase previous drawing)
   [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
   
   [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                          numberOfCoordinates:3
                                 attribOffset:offsetof(SceneVertex, positionCoords)
                                 shouldEnable:YES];
                                      
   // Draw triangles using the first three vertices in the
   // currently bound vertex buffer
   [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                       startVertexIndex:0
                       numberOfVertices:3];
}

- (void)dealloc {
    
    // Delete buffers that aren't needed when view is unloaded
    self.vertexBuffer = nil;
}

@end
