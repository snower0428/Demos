//
//  DataItem.h
//  CoreAnimationDemo
//
//  Created by leihui on 17/3/31.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

#pragma mark - PointItem

@interface PointItem : NSObject

@property (nonatomic, strong) NSString *Root;		// value = point
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@end

#pragma mark - RectItem

@interface RectItem : NSObject

@property (nonatomic, strong) NSString *Root;		// value = rect
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

#pragma mark - CircleItem

@interface CircleItem : NSObject

@property (nonatomic, strong) NSString *Root;		// value = circle
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat radius;

@end

#pragma mark - PathItem

@interface PathItem : NSObject

@property (nonatomic, strong) NSString *Root;		// value = path
@property (nonatomic, strong) NSArray *__text;
@property (nonatomic, strong) NSArray *point;
@property (nonatomic, strong) RectItem *rect;
@property (nonatomic, strong) CircleItem *circle;
@property (nonatomic, strong) NSString *shape;		// value = rectangle, circle

@end

#pragma mark - PartItem

@interface PartItem : NSObject

@property (nonatomic, strong) NSString *Root;		// value = part
@property (nonatomic, strong) NSArray *__text;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) PathItem *path;
@property (nonatomic, assign) NSInteger zIndex;

@end

#pragma mark - FrameItem

@interface FrameItem : NSObject

@property (nonatomic, strong) NSString *Root;		// value = frame
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

#pragma mark - FillItem

@interface FillItem : NSObject

@property (nonatomic, strong) NSString *Root;		// value = fill
@property (nonatomic, strong) NSArray *__text;
@property (nonatomic, strong) FrameItem *frame;
@property (nonatomic, strong) NSString *mode;		// value = origin

@end

#pragma mark - MarginItem

@interface MarginItem : NSObject

@property (nonatomic, strong) NSString *Root;		// value = margin
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;

@end

#pragma mark - ImageItem

@interface ImageItem : NSObject

@property (nonatomic, strong) NSString *Root;		// value = image
@property (nonatomic, strong) NSArray *__text;
@property (nonatomic, strong) NSString *file;
@property (nonatomic, strong) FillItem *fill;
@property (nonatomic, strong) NSString *imageId;	// value = bg, img_0, img_EVH
@property (nonatomic, strong) MarginItem *margin;
@property (nonatomic, assign) NSInteger zIndex;

@end

#pragma mark - ColorItem

@interface ColorItem : NSObject

@property (nonatomic, strong) NSString *Root;		// value = color
@property (nonatomic, assign) CGFloat red;
@property (nonatomic, assign) CGFloat green;
@property (nonatomic, assign) CGFloat blue;
@property (nonatomic, assign) CGFloat alpha;

@end

#pragma mark - FontItem

@interface FontItem : NSObject

@property (nonatomic, strong) NSString *Root;		// value = color
@property (nonatomic, strong) NSString *name;

@end

#pragma mark - TextItem

@interface TextItem : NSObject

@property (nonatomic, strong) NSString *Root;		// value = text
@property (nonatomic, strong) NSArray *__text;
@property (nonatomic, strong) NSString *align;		// value = center
@property (nonatomic, strong) NSString *clickType;	// value = text, poi
@property (nonatomic, strong) ColorItem *color;
@property (nonatomic, strong) NSString *defaultValue;
@property (nonatomic, strong) FontItem *font;
@property (nonatomic, strong) NSString *format;		// value = yyyy.MM
@property (nonatomic, strong) FrameItem *frame;
@property (nonatomic, strong) NSString *textId;		// value = text1, txt_1, txt_0
@property (nonatomic, strong) NSString *locale;		// value = US
@property (nonatomic, assign) CGFloat maxSize;
@property (nonatomic, assign) CGFloat minSize;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, assign) CGFloat vSpace;
@property (nonatomic, strong) NSString *value;		// value = $(exifPlace)-表示位置, $(exifDate)-表示日期
@property (nonatomic, assign) NSInteger zIndex;

@end

#pragma mark - DataItem

@interface DataItem : NSObject

@property (nonatomic, strong) NSString *Root;		// value = style
@property (nonatomic, strong) NSArray *__text;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) FrameItem *frame;
@property (nonatomic, strong) ImageItem *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *part;
@property (nonatomic, strong) NSArray *text;
@property (nonatomic, strong) NSString *thumb;

@end
