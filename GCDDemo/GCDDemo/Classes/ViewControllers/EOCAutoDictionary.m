//
//  EOCAutoDictionary.m
//  GCDDemo
//
//  Created by leihui on 2017/9/30.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "EOCAutoDictionary.h"
#import <objc/runtime.h>

@interface EOCAutoDictionary ()

@property (nonatomic, strong) NSMutableDictionary *backingStore;

@end

@implementation EOCAutoDictionary

@dynamic string, number, date, opaqueObject;

- (id)init
{
	self = [super init];
	if (self) {
		_backingStore = [NSMutableDictionary new];
	}
	return self;
}

#if 1
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
	NSString *selString = NSStringFromSelector(sel);
	if ([selString hasPrefix:@"set"]) {
		class_addMethod(self, sel, (IMP)autoDictionarySetter, "v@:@");
	}
	else {
		class_addMethod(self, sel, (IMP)autoDictionaryGetter, "@@:");
	}
	return YES;
}

id autoDictionaryGetter(id self, SEL _cmd)
{
	// Get the backing store from the object
	EOCAutoDictionary *typedSelf = (EOCAutoDictionary *)self;
	NSMutableDictionary *backingStore = typedSelf.backingStore;
	
	// The key is simply the selector name
	NSString *key = NSStringFromSelector(_cmd);
	
	// Return the value
	return [backingStore objectForKey:key];
}

void autoDictionarySetter(id self, SEL _cmd, id value)
{
	// Get the backing store from the object
	EOCAutoDictionary *typedSelf = (EOCAutoDictionary *)self;
	NSMutableDictionary *backingStore = typedSelf.backingStore;
	
	NSString *selectorString = NSStringFromSelector(_cmd);
	NSMutableString *key = [selectorString mutableCopy];
	
	// Remove the ':' at the end
	[key deleteCharactersInRange:NSMakeRange(key.length-1, 1)];
	
	// Remove the 'set' prefix
	[key deleteCharactersInRange:NSMakeRange(0, 3)];
	
	// Lowercase the first character
	NSString *lowercaseFirstChar = [[key substringToIndex:1] lowercaseString];
	[key replaceCharactersInRange:NSMakeRange(0, 1) withString:lowercaseFirstChar];
	
	if (value) {
		[backingStore setObject:value forKey:key];
	}
	else {
		[backingStore removeObjectForKey:key];
	}
}
#endif

@end
