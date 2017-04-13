

#import "ResourcesManager.h"

@interface ResourcesManager()

@property (nonatomic, strong) NSMutableDictionary *cacheDict;

+ (NSString *)getDeviceFileName:(NSString *)name;

+ (NSString *)imageExistAtPath:(NSString *)path scanSuffix:(BOOL)scan;
+ (NSString *)imageExistAtPath:(NSString *)path withSuffix:(NSString *)suffix;
+ (NSString *)filePath:(NSString *)filePath addSuffix:(NSString *)suffix;

@end

@implementation ResourcesManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ResourcesManager)

- (id)init
{
	if (self = [super init])
	{
		m_defaultSkinPath = [[[self class] defaultSkinPath] copy];
	}
	return self;
}

-(void)dealloc
{
	//[m_defaultSkinPath release];
    m_defaultSkinPath = nil;
	[super dealloc];
}

+ (NSString *)defaultSkinPath
{
    return [NSString stringWithFormat:@"%@/Resource/Images", [[NSBundle mainBundle] resourcePath]];
}

- (UIImage *)imageWithName:(NSString *)name
{
    if(name == nil) {
		return nil;
    }
    
    return [self imageWIthFilePath:[[NSBundle mainBundle] pathForResource:[name stringByDeletingPathExtension] ofType:[name pathExtension]]];
}

- (UIImage *)imageWithFileName:(NSString *)name
{
	if(name == nil)
		return nil;
    
    return [self imageWIthFilePath:[m_defaultSkinPath stringByAppendingPathComponent:name]];
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

- (UIImage *)imageWIthFilePath:(NSString *)path
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
        return [[ResourcesManager sharedInstance] imageWIthFilePath:filePath];
    }
}

+ (NSString *)imageExistAtPath:(NSString *)path {
    return [self imageExistAtPath:path sourceType:ImageSourceTypeDefault];
}

+ (NSString *)imageExistAtPath:(NSString *)path sourceType:(ImageSourceType)sourceType {
    if (!path) {
        return nil;
    }
    
    BOOL scan = (sourceType==ImageSourceTypeDefault);
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
    
    if (![BZDeviceInfo isHDMachine]) {
        return path;
    } else if (iPhone4) {
        return [self filePath:path addSuffix:@"@2x"];
    } else {
        NSString *suffix = @"";
        if (height) {
            suffix = [suffix stringByAppendingFormat:@"-%.fh", SCREEN_HEIGHT];
        }
        
		if (iPhone5 ||
			([BZDeviceInfo deviceModel] == GBDeviceModeliPhone6) ||
			([BZDeviceInfo deviceModel] == GBDeviceModeliPhone6s) ||
			([BZDeviceInfo deviceModel] == GBDeviceModeliPhone7)) {
            suffix = [suffix stringByAppendingString:@"@2x"];
        } else {
            suffix = [suffix stringByAppendingString:@"@3x"];
        }
        return [self filePath:path addSuffix:suffix];
    }
}

//状态栏预览图
+ (UIImage *)statusBarLayerImage
{
    return getResource(@"Common/Wallpaper/StatusBar.png");
}

//锁屏预览图
+ (UIImage *)lockScreenLayerImage
{
    if (SYSTEM_VERSION < 7.0) {
        return getResource(@"Common/Wallpaper/lockScreen.png");
    } else {
        return getResource(@"Common/Wallpaper/LockScreen_ios7.png");
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
			([BZDeviceInfo deviceModel] == GBDeviceModeliPhone6) ||
			([BZDeviceInfo deviceModel] == GBDeviceModeliPhone6s) ||
			([BZDeviceInfo deviceModel] == GBDeviceModeliPhone7)) {
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
        if (![BZDeviceInfo isHDMachine]) {
            result = [self imageExistAtPath:path withSuffix:nil];
		} else if (iPhone4 ||
				   iPhone5 ||
				   ([BZDeviceInfo deviceModel] == GBDeviceModeliPhone6 ||
					([BZDeviceInfo deviceModel] == GBDeviceModeliPhone6s) ||
					([BZDeviceInfo deviceModel] == GBDeviceModeliPhone7))) {
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
