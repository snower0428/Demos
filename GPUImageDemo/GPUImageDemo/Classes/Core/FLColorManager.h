//
//  FLColorManager.h
//  Pods
//
//  Created by imac on 2017/3/22.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FLColorItem : NSObject

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;
@property (nonatomic, readonly) CGFloat alpha;

@property (nonatomic, readonly) CGFloat lumaFactor;
@property (nonatomic, readonly) CGFloat yyValue;
@property (nonatomic, readonly) CGFloat uuValue;
@property (nonatomic, readonly) CGFloat vvValue;

@end

@interface FLColorManager : NSObject

@property(retain, nonatomic) NSMutableArray<FLColorItem *> *keyColors; // @synthesize keyColors;

+ (id)getColorManager;
- (void)resetKeyColors;
//设置当前颜色
- (void)addKeyColor:(UIColor *)color;
- (void)addKeyColorAtPixel:(CGPoint)point inImage:(UIImage *)image;
//设置默认图片平均颜色
- (void)addDefaultKeyColorAtImage:(UIImage *)image;
@end
