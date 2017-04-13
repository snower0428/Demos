
#import "SynthesizeSingleton.h"

@interface ResourcesManager : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ResourcesManager)

/*
 * 获取图片资源，高端设备可使用低端设备资源
 * iPhone6 Plus: -h@3x, -h@2x, -h@1x, @3x, @2x, @1x
 * iPhone5/iPhone6: -h@2x, -h@1x, @2x, @1x,
 * iPhone4: @2x, @1x
 */
- (UIImage *)imageWithName:(NSString *)name;
- (UIImage *)imageWithFileName:(NSString *)name;
- (UIImage *)imageWithCacheFileName:(NSString *)name;
- (UIImage *)imageWithFilePath:(NSString *)path;

- (UIImage *)imageWithName:(NSString *)name inAppGroupPath:(NSString *)path;

/*
 * 判断图片资源是否存在，高端设备可使用低端设备资源
 */
+ (NSString *)imageExistAtPath:(NSString *)path;

/*
 * 为资源地址添加设备适配后缀
 */
+ (NSString *)adaptDeviceImagePath:(NSString *)path withHeight:(BOOL)height;

@end
