//
//  CarouselViewController2.m
//  FLDemos
//
//  Created by leihui on 2020/2/20.
//  Copyright © 2020 ND WebSoft Inc. All rights reserved.
//

#import "CarouselViewController2.h"
#import "iCarousel.h"

@interface CarouselViewController2 () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, assign) CGSize cardSize;

@end

@implementation CarouselViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 一行代码搞定导航栏透明度
    [self wr_setNavBarBackgroundAlpha:0.f];
    // 一行代码搞定导航栏两边按钮颜色
    [self wr_setNavBarTintColor:[UIColor whiteColor]];
    // 一行代码搞定状态栏是 default 还是 lightContent
    [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    
    CGFloat cardWidth = [UIScreen mainScreen].bounds.size.width * 5.0f / 7.0f;
    self.cardSize = CGSizeMake(cardWidth, cardWidth * 16.f / 9.f);
    self.view.backgroundColor = [UIColor blackColor];
    
    self.carousel = [[iCarousel alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeCustom;
    _carousel.bounceDistance = 0.2f;
    [self.view addSubview:_carousel];
}

#pragma mark - iCarouselDataSource <NSObject>

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    
    return 15;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    
    UIView *cardView = view;
    if (!cardView) {
        cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cardSize.width, self.cardSize.height)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cardView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor whiteColor];
        [cardView addSubview:imageView];
        
        cardView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:imageView.frame cornerRadius:5.0f].CGPath;
        cardView.layer.shadowRadius = 3.0f;
        cardView.layer.shadowColor = [UIColor blackColor].CGColor;
        cardView.layer.shadowOpacity = 0.5f;
        cardView.layer.shadowOffset = CGSizeMake(0, 0);
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = imageView.bounds;
        layer.path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:5.0f].CGPath;
        imageView.layer.mask = layer;
        
        UILabel *label = [[UILabel alloc] initWithFrame:cardView.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.text = [@(index) stringValue];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:200];
        [cardView addSubview:label];
    }
    
    return cardView;
}

#pragma mark - iCarouselDelegate <NSObject>

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    
    CGFloat scale = [self scaleByOffset:offset];
    CGFloat translation = [self translationByOffset:offset];
    return CATransform3DScale(CATransform3DTranslate(transform, translation * self.cardSize.width, 0, offset), scale, scale, 1.0);
}

- (void)carouselDidScroll:(iCarousel *)carousel {
    
    for (UIView *view in carousel.visibleItemViews) {
        CGFloat offset = [carousel offsetForItemAtIndex:[carousel indexOfItemView:view]];
        if (offset < -3.0f) {
            view.alpha = 0.0f;
        } else if (offset < -2.0f) {
            view.alpha = offset + 3.0f;
        } else {
            view.alpha = 1.0f;
        }
    }
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    
    return self.cardSize.width;
}

#pragma mark - Private

// 形变是线性的就ok了
- (CGFloat)scaleByOffset:(CGFloat)offset {
    
    return offset * 0.04f + 1.0f;
}

// 位移通过得到的公式来计算
- (CGFloat)translationByOffset:(CGFloat)offset {
    
    CGFloat z = 5.0f / 4.0f;
    CGFloat n = 5.0f / 8.0f;
    
    // z/n是临界值 >=这个值时 我们就把itemView放到比较远的地方不让他显示在屏幕上就可以了
    if (offset >= z/n) {
        return 2.0f;
    }
    
    return 1 / (z - n * offset) - 1 / z;
}

@end
