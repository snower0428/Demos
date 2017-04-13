

#import "ResourcesManager.h"

@interface ResourcesManager()

@property (nonatomic, copy) NSString *defaultSkinPath;
@property (nonatomic, strong) NSMutableDictionary *cacheDict;

@end

@implementation ResourcesManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ResourcesManager)

- (id)init
{
	if (self = [super init]) {
		self.defaultSkinPath = [NSString stringWithFormat:@"%@/Resource/Images", [[NSBundle mainBundle] resourcePath]];
	}
	return self;
}

- (UIImage *)imageWithName:(NSString *)name
{
	if(name == nil) {
		return nil;
	}
	
	return [self imageWithFilePath:[[NSBundle mainBundle] pathForResource:[name stringByDeletingPathExtension] ofType:[name pathExtension]]];
}

- (UIImage *)imageWithFileName:(NSString *)name
{
	if(name == nil)
		return nil;
	
	return [self imageWithFilePath:[_defaultSkinPath stringByAppendingPathComponent:name]];
}

- (UIImage *)imageWithCacheFileName:(NSString *)name
{
	UIImage *image = nil;
	if (!_cacheDict)
	{
		self.cacheDict = [NSMutableDictionary dictionary];
	}
	if (_cacheDict) {
		image = [_cacheDict objectForKey:name];
	}
	if (![image isKindOfClass:[UIImage class]])
	{
		image = [self imageWithFileName:name];
		[_cacheDict setObject:image forKey:name];
	}
	return image;
}

- (UIImage *)imageWithFilePath:(NSString *)path
{
	if(path == nil)
		return nil;
	
	UIImage * result = nil;
	
	//优先读取-h后缀文件，其中h为屏幕分辨率高度
	NSString *newPath = [[self class] getDeviceFileName:path];
	result = [UIImage imageWithContentsOfFile:newPath];
	if (result != nil) {
		return result;
	}
	
	//再读取原名称文件
	result = [UIImage imageWithContentsOfFile:path];
	if (result != nil) {
		return result;
	}
	
	if ([path rangeOfString:@"@2x"].location != NSNotFound) {
		NSString *newPath = [path stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
		result = [UIImage imageWithContentsOfFile:newPath];
	} else {
		NSString *extension = [path pathExtension];
		NSString *newPath = [path stringByDeletingPathExtension];
		newPath = [NSString stringWithFormat:@"%@@2x.%@", newPath, extension];
		result = [UIImage imageWithContentsOfFile:newPath];
	}
	
	return result;
}

- (UIImage *)imageWithName:(NSString *)name inAppGroupPath:(NSString *)path
{
	UIImage *image = [[[self class] sharedInstance] imageWithFileName:name];
	if (image) {
		return image;
	}
	else {
		NSString *filePath = [path stringByAppendingPathComponent:name];
		return [[ResourcesManager sharedInstance] imageWithFilePath:filePath];
	}
}

+ (NSString *)imageExistAtPath:(NSString *)path {
	if (!path) {
		return nil;
	}
	
	BOOL scan = YES;
	NSString *result = nil;
	if (!iPhone4) {
		NSString *newPath = [self getDeviceFileName:path];
		result = [self imageExistAtPath:newPath scanSuffix:scan];
	}
	if (!result) {
		result = [self imageExistAtPath:path scanSuffix:scan];
	}
	
	return result;
}

/*
 * 为资源地址添加设备适配后缀
 */
+ (NSString *)adaptDeviceImagePath:(NSString *)path withHeight:(BOOL)height {
	if ([NSString isEmptyString:path]) {
		return path;
	}
	
	if (!kIsHDMachine) {
		return path;
	} else if (iPhone4) {
		return [self filePath:path addSuffix:@"@2x"];
	} else {
		NSString *suffix = @"";
		if (height) {
			suffix = [suffix stringByAppendingFormat:@"-%.fh", SCREEN_HEIGHT];
		}
		
		if (iPhone5 ||
			([GBDeviceInfo deviceInfo].model == GBDeviceModeliPhone6) ||
			([GBDeviceInfo deviceInfo].model == GBDeviceModeliPhone6s) ||
			([GBDeviceInfo deviceInfo].model == GBDeviceModeliPhone7)) {
			suffix = [suffix stringByAppendingString:@"@2x"];
		} else {
			suffix = [suffix stringByAppendingString:@"@3x"];
		}
		return [self filePath:path addSuffix:suffix];
	}
}

#pragma mark - private

+ (NSString *)getDeviceFileName:(NSString *)name
{
	if (name != nil && !iPhone4)
	{
		NSString *fileEx = [name pathExtension];
		NSString *fileName = [name stringByDeletingPathExtension];
		if (fileName && fileEx) {
			return [[fileName stringByAppendingFormat:@"-%.fh", SCREEN_HEIGHT] stringByAppendingPathExtension:fileEx];
		} else {
			return name;
		}
	}
	return name;
}

+ (NSString *)imageExistAtPath:(NSString *)path scanSuffix:(BOOL)scan {
	if (!path) {
		return nil;
	}
	
	NSString *result = nil;
	if (scan) {
		if (iPhone4 ||
			iPhone5 ||
			([GBDeviceInfo deviceInfo].model == GBDeviceModeliPhone6) ||
			([GBDeviceInfo deviceInfo].model == GBDeviceModeliPhone6s) ||
			([GBDeviceInfo deviceInfo].model == GBDeviceModeliPhone7)) {
			result = [self imageExistAtPath:path withSuffix:@"@2x"];
			if (!result) {
				result = [self imageExistAtPath:path withSuffix:nil];
			}
		} else {
			result = [self imageExistAtPath:path withSuffix:@"@3x"];
			if (!result) {
				result = [self imageExistAtPath:path withSuffix:@"@2x"];
				if (!result) {
					result = [self imageExistAtPath:path withSuffix:nil];
				}
			}
		}
	} else {
		if (!kIsHDMachine) {
			result = [self imageExistAtPath:path withSuffix:nil];
		} else if (iPhone4 ||
				   iPhone5 ||
				   ([GBDeviceInfo deviceInfo].model == GBDeviceModeliPhone6 ||
					([GBDeviceInfo deviceInfo].model == GBDeviceModeliPhone6s) ||
					([GBDeviceInfo deviceInfo].model == GBDeviceModeliPhone7))) {
					   result = [self imageExistAtPath:path withSuffix:@"@2x"];
				   } else {
					   result = [self imageExistAtPath:path withSuffix:@"@3x"];
				   }
	}
	return result;
}

+ (NSString *)imageExistAtPath:(NSString *)path withSuffix:(NSString *)suffix {
	NSFileManager *fileMgr = [NSFileManager defaultManager];
	NSString *newPath = [self filePath:path addSuffix:suffix];
	if (newPath) {
		if ([fileMgr fileExistsAtPath:newPath]) {
			return newPath;
		}
	} else {
		if ([fileMgr fileExistsAtPath:path]) {
			return path;
		};
	}
	return nil;
}

+ (NSString *)filePath:(NSString *)filePath addSuffix:(NSString *)suffix {
	if (suffix) {
		NSString *newPath = [filePath stringByDeletingPathExtension];
		NSString *pathEx = [filePath pathExtension];
		if (newPath && pathEx) {
			newPath = [[newPath stringByAppendingString:suffix] stringByAppendingPathExtension:pathEx];
			return newPath;
		}
	}
	return filePath;
}

@end
