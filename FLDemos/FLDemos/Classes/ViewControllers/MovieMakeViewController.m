//
//  MovieMakeViewController.m
//  FLDemos
//
//  Created by leihui on 2020/3/2.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "MovieMakeViewController.h"
#import <LYMovieMake/LYMovieMakeLib.h>

@interface MovieMakeViewController ()

@property (nonatomic, strong) LYMovieMake *make;

@end

@implementation MovieMakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *btnMake = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMake.backgroundColor = [UIColor orangeColor];
    [btnMake setTitle:@"Make" forState:UIControlStateNormal];
    [self.view addSubview:btnMake];
    [btnMake addTarget:self action:@selector(makeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSave.backgroundColor = [UIColor orangeColor];
    [btnSave setTitle:@"Save" forState:UIControlStateNormal];
    [self.view addSubview:btnSave];
    [btnSave addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnMake mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(100);
        make.right.equalTo(btnSave.mas_left).offset(-10);
        make.width.equalTo(btnSave);
        make.height.equalTo(@(44));
    }];
    
    [btnSave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnMake.mas_right).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.height.equalTo(btnMake);
    }];
}

- (void)makeAction:(id)sender {
    
    LYMovieMake *make = [[LYMovieMake alloc] init];
    NSURL *urlColor = [[NSBundle mainBundle] URLForResource:@"color" withExtension:@"mp4"];
    NSURL *urlMask = [[NSBundle mainBundle] URLForResource:@"mask" withExtension:@"mp4"];
    LYMovieSlice *sliceColor = [[LYMovieSlice alloc] initWithURL:urlColor];
    LYMovieSlice *sliceMask = [[LYMovieSlice alloc] initWithURL:urlMask];
    sliceMask.transitionFilter = [[LYMovieTransitionFilterStack sharedTransitionFilterStack] filterOfType:TransitionFilterTypeSwipe];
    [make addSlice:sliceColor];
    [make addSlice:sliceMask];
    
    
    LYMovieFilterStack *filterStack = [[LYMovieFilterStack alloc] initWithDemoImage:[UIImage imageNamed:@"filter_raw"]];
    make.filter = [filterStack filterAtIndex:0];
    self.make = make;
    [self.view.layer addSublayer:make.playerLayer];
    make.playerLayer.frame = self.view.bounds;
    [make play];
}

- (void)saveAction:(id)sender {
    
    
}

@end
