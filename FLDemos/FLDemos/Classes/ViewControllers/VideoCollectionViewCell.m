//
//  VideoCollectionViewCell.m
//  FLDemos
//
//  Created by leihui on 2020/2/10.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "VideoCollectionViewCell.h"
#import <JPVideoPlayer/JPVideoPlayerKit.h>

@interface VideoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *videoPlayView;

@end

@implementation VideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Init
        self.imageView = [[YYAnimatedImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 4.f;
        [self addSubview:_imageView];
        
        self.videoPlayView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_videoPlayView];
    }
    return self;
}

- (void)setImageWithUrl:(NSString *)strUrl {
    _imageView.hidden = NO;
    _imageView.frame = self.bounds;
    
    //NSLog(@"strUrl:%@", strUrl);
    if ([strUrl hasPrefix:@"http:"] || [strUrl hasPrefix:@"https:"]) {
        NSURL *url = [NSURL URLWithString:strUrl];
        if (url == nil) {
            NSString *encodingUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
            url = [NSURL URLWithString:encodingUrl];
            if (url) {
                [_imageView yy_setImageWithURL:url options:YYWebImageOptionProgressive];
            }
        }
        else {
            [_imageView yy_setImageWithURL:url options:YYWebImageOptionProgressive];
        }
    }
    else {
        _imageView.image = [UIImage imageNamed:strUrl];
    }
}

- (void)playVideoWithUrl:(NSString *)strUrl {
    if (_videoPlayView) {
        [_videoPlayView jp_playVideoWithURL:[NSURL URLWithString:strUrl]];
    }
}

@end
