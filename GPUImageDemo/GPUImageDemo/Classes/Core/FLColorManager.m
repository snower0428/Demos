//
//  FLColorManager.m
//  Pods
//
//  Created by imac on 2017/3/22.
//
//

#import "FLColorManager.h"
#import "UIColor+ExpandedAdditions.h"
#import "CCColorCube.h"

@implementation FLColorItem

- (CGFloat)red {
    return [self.color red];
}

- (CGFloat)green {
    return [self.color green];
}

- (CGFloat)blue {
    return [self.color blue];
}

- (CGFloat)alpha {
    return [self.color alpha];
}

- (CGFloat)lumaFactor
{
    return [self.color lumaFactor];
}
- (CGFloat)yyValue
{
    return [self.color yyValue];
}
- (CGFloat)uuValue
{
    return [self.color uuValue];
}
- (CGFloat)vvValue
{
    return [self.color vvValue];
}

@end

@interface FLColorManager()
- (FLColorItem *)colorComponentsForColor:(UIColor *)color;
- (void)removeKeyColorAtIndex:(int)index;
@end

@implementation FLColorManager

- (id)init
{
    if (self = [super init]) {
        self.keyColors = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

+ (id)getColorManager
{
    static dispatch_once_t pred = 0;
    static FLColorManager *library = nil;
    dispatch_once(&pred,^
                  {
                      library = [[FLColorManager alloc] init];
                  });
    return library;
}
- (FLColorItem *)colorComponentsForColor:(UIColor *)color
{
    FLColorItem *item = nil;
    if ([color isKindOfClass:[UIColor class]]) {
        item = [FLColorItem new];
        item.color = color;
    }
    return item;
}
- (void)resetKeyColors
{
    [self.keyColors removeAllObjects];
}
- (void)removeKeyColorAtIndex:(int)index
{
    if ([self.keyColors count] > index) {
        [self.keyColors removeObjectAtIndex:index];
    }
}
- (void)addKeyColor:(UIColor *)color
{
    FLColorItem *data = [self colorComponentsForColor:color];
    if (data != nil) {
        if ([self.keyColors count] >= 5) {
            [self removeKeyColorAtIndex:0];
        }
        [self.keyColors addObject:data];
    }
}
- (void)addKeyColorAtPixel:(CGPoint)point inImage:(UIImage *)image
{
    [self addKeyColor:[self colorAtPixel:point inImage:image]];
}

- (UIColor *)colorAtPixel:(CGPoint)point inImage:(UIImage *)image {
    
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return nil;
    }
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    NSLog(@"color r = %@ g = %@ b = %@ a = %@", @(red), @(green), @(blue), @(alpha));
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

//设置默认图片平均颜色
- (void)addDefaultKeyColorAtImage:(UIImage *)image
{
    [self resetKeyColors];
    
    CGSize size = image.size;
    CGFloat defaultThumbWith = 32.0f;
    float thumbScale = defaultThumbWith / size.width;
    UIImage *newImage = [self resizeImage:image withSize:CGSizeMake(defaultThumbWith, size.height * thumbScale)]; // 32*32
    CCColorCube *colorCube = [CCColorCube new]; //从图片中提取图片的主要色调
    NSArray *colorArray = [colorCube extractColorsFromImage:newImage flags:0 count:1];
    for (UIColor *color in colorArray) {
        if ([color isKindOfClass:[UIColor class]]) {
            [self addKeyColor:color];
        }
    }
    //[self addKeyColor:[self mostColorWithImage:image]];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    if (image && [image isKindOfClass:[UIImage class]])
    {
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:newImage.CGImage];
}

-(UIColor*)mostColorWithImage:(UIImage *)image{
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(50, 50);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            
            int offset = 4*(x*y);
            
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            
            NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
            [cls addObject:clr];
            
        }
    }
    CGContextRelease(context);
    
    
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        
        if ( tmpCount < MaxCount ) continue;
        
        MaxCount=tmpCount;
        MaxColor=curColor;
        
    }
    
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

@end
