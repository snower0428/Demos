//
//  GLKitViewController.m
//  OpenGLDemo
//
//  Created by leihui on 17/4/11.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "GLKitViewController.h"

@interface GLKitViewController ()

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *effect;

@end

@implementation GLKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor orangeColor];
	
	[self setupConfig];
	[self uploadVertexArray];
	[self uploadTexture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)setupConfig
{
	// 新建OpenGLES上下文
	self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];//2.0
	
	GLKView *view = (GLKView *)self.view;
	view.context = _context;
	view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
	
	[EAGLContext setCurrentContext:_context];
}

- (void)uploadVertexArray
{
	// 顶点数据，前三个是顶点坐标，后面两个是纹理坐标
	GLfloat squareVertexData[] = {
		0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
		0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
		-0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
		
		0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
		-0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
		-0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
	};
	
	// 顶点数据缓存
	GLuint buffer;
	glGenBuffers(1, &buffer);
	glBindBuffer(GL_ARRAY_BUFFER, buffer);
	glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);	// 顶点数据缓存
	glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat *)NULL+0);
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);// 纹理
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat *)NULL+3);
}

- (void)uploadTexture
{
	// 纹理贴图
	NSString *filePath = [NSString stringWithFormat:@"%@/Resource/Images", [[NSBundle mainBundle] resourcePath]];
	filePath = [filePath stringByAppendingPathComponent:@"test.jpg"];
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@"1", GLKTextureLoaderOriginBottomLeft, nil];
	GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
	
	// 着色器
	self.effect = [[GLKBaseEffect alloc] init];
	_effect.texture2d0.enabled = GL_TRUE;
	_effect.texture2d0.name = textureInfo.name;
}

#pragma mark - GLKViewDelegate

/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	//启动着色器
	[self.effect prepareToDraw];
	glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end
