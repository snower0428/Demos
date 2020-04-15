//
//  GPUImageViewController001.m
//  GPUImageDemo
//
//  Created by leihui on 2020/3/4.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "GPUImageViewController001.h"

@interface GPUImageViewController001 ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GPUImageViewController001

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = self.view.frame;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_imageView];
    
    [self loadImage];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Private

- (void)loadImage {
    
    GPUImageSketchFilter *filter = [[GPUImageSketchFilter alloc] init];
    self.imageView.image = [filter imageByFilteringImage:getResource(@"test.jpg")];
}

@end
