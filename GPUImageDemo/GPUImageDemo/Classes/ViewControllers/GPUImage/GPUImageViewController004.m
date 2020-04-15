//
//  GPUImageViewController004.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/4.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageViewController004.h"

@interface GPUImageViewController004 ()

@property (nonatomic, strong) GPUImagePicture *imagePicture;
@property (nonatomic, strong) GPUImageTiltShiftFilter *tiltShiftFilter;
@property (nonatomic, strong) GPUImageView *imageView;

@end

@implementation GPUImageViewController004

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self loadTiltShiftEffect];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.imageView];
    float rate = point.y / self.imageView.frame.size.height;
    [self.tiltShiftFilter setTopFocusLevel:rate - 0.1];
    [self.tiltShiftFilter setBottomFocusLevel:rate + 0.1];
    [self.imagePicture processImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Object Private Function

- (void)loadTiltShiftEffect
{
    //实例化GPUImageView
    GPUImageView *imageView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    imageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    //实例化GPUImagePicture
    self.imagePicture = [[GPUImagePicture alloc] initWithImage:getResource(@"test.jpg")];
    
    //实例化GPUImageTiltShiftFilter - 模拟倾斜移位滤镜效果
    self.tiltShiftFilter = [[GPUImageTiltShiftFilter alloc] init];
    self.tiltShiftFilter.blurRadiusInPixels = 40.0;
    [self.tiltShiftFilter forceProcessingAtSize:imageView.sizeInPixels];
    
    //add target
    [self.imagePicture addTarget:self.tiltShiftFilter];
    [self.tiltShiftFilter addTarget:imageView];
    [self.imagePicture processImage];

    //GPUImageContext相关的数据显示
    GLint size = [GPUImageContext maximumTextureSizeForThisDevice];
    GLint unit = [GPUImageContext maximumTextureUnitsForThisDevice];
    GLint vector = [GPUImageContext maximumVaryingVectorsForThisDevice];
    NSLog(@"%d %d %d", size, unit, vector);
}

@end
