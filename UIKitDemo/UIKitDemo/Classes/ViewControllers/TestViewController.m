//
//  TestViewController.m
//  UIKitDemo
//
//  Created by leihui on 17/3/14.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "TestViewController.h"
#import "PasterItem.h"

@interface TestViewController ()

@property (nonatomic, strong) NSMutableArray *arrayData;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor orangeColor];
	
	self.arrayData = [NSMutableArray array];
	
	//[self loadTestData];
	//[self loadRecommendData];
	//[self loadMainData];
	
	//[self loadPasters];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	//[self saveTestPasters];
	//[self saveRecommendPasters];
	//[self saveMainPasters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)loadPasters
{
	NSString *pastersPath = [RESOURCE_PATH stringByAppendingPathComponent:@"Pasters"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *savedPath = kDocSavedPath;
	NSArray *mainList = [fileManager contentsOfDirectoryAtPath:pastersPath error:NULL];
	for (NSString *mainFileName in mainList) {
		NSString *catePath = [pastersPath stringByAppendingPathComponent:mainFileName];
		NSArray *cateList = [fileManager contentsOfDirectoryAtPath:catePath error:NULL];
		for (NSString *cateFileName in cateList) {
			NSString *lastPath = [catePath stringByAppendingPathComponent:cateFileName];
			NSArray *lastList = [fileManager contentsOfDirectoryAtPath:lastPath error:NULL];
			for (NSString *lastFileName in lastList) {
				NSString *plistPath = [lastPath stringByAppendingPathComponent:lastFileName];
				// Create dir
				savedPath = [kDocSavedPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@", mainFileName, cateFileName, lastFileName]];
				if (![fileManager fileExistsAtPath:savedPath]) {
					[fileManager createDirectoryAtPath:savedPath withIntermediateDirectories:YES attributes:nil error:NULL];
				}
				NSArray *plists = [fileManager contentsOfDirectoryAtPath:plistPath error:NULL];
				for (NSString *plistName in plists) {
					NSString *plistFilePath = [plistPath stringByAppendingPathComponent:plistName];
					NSArray *pasters = [NSArray arrayWithContentsOfFile:plistFilePath];
					for (NSDictionary *dict in pasters) {
						PasterItem *pasterItem = [PasterItem yy_modelWithJSON:dict];
						NSURL *url = [NSURL URLWithString:pasterItem.url];
						if (url == nil) {
							NSString *encodingUrl = [pasterItem.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
							url = [NSURL URLWithString:encodingUrl];
						}
						NSData *data = [NSData dataWithContentsOfURL:url];
						NSString *fileName = [NSString stringWithFormat:@"%@_%@.png", pasterItem.name, @(pasterItem.resId)];
						NSString *filePath = [savedPath stringByAppendingPathComponent:fileName];
						BOOL bRet = [data writeToFile:filePath atomically:YES];
						NSLog(@"bRet:%d | %@", bRet, filePath);
#if 0
						// Thumb
						url = [NSURL URLWithString:pasterItem.thumb_url];
						if (url == nil) {
							NSString *encodingUrl = [pasterItem.thumb_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
							url = [NSURL URLWithString:encodingUrl];
						}
						data = [NSData dataWithContentsOfURL:url];
						fileName = [NSString stringWithFormat:@"%@_%@_thumb.png", pasterItem.name, @(pasterItem.resId)];
						filePath = [savedPath stringByAppendingPathComponent:fileName];
						bRet = [data writeToFile:filePath atomically:YES];
						NSLog(@"bRet:%d | %@", bRet, filePath);
#endif
					}
				}
			}
		}
	}
}

- (void)loadTestData
{
#if 1
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:kJsonTestFilePath]) {
		NSArray *pasters = [NSArray arrayWithContentsOfFile:kJsonTestFilePath];
		for (NSDictionary *dict in pasters) {
			PasterItem *pasterItem = [PasterItem yy_modelWithJSON:dict];
			[_arrayData addObject:pasterItem];
		}
	}
#else
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:kJsonTestFilePath]) {
		NSData *jsonData = [NSData dataWithContentsOfFile:kJsonTestFilePath];
		id result = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
		if (result && [result isKindOfClass:[NSDictionary class]]) {
			id data = result[@"data"];
			if (data && [data isKindOfClass:[NSDictionary class]]) {
				id paster = data[@"paster"];
				if (paster && [paster isKindOfClass:[NSArray class]]) {
					for (NSDictionary *dict in paster) {
						PasterItem *pasterItem = [PasterItem yy_modelWithJSON:dict];
						[_arrayData addObject:pasterItem];
					}
				}
			}
		}
	}
#endif
}

- (void)loadRecommendData
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:kJsonRecommendFilePath]) {
		NSData *jsonData = [NSData dataWithContentsOfFile:kJsonRecommendFilePath];
		id result = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
		if (result && [result isKindOfClass:[NSDictionary class]]) {
			id data = result[@"data"];
			if (data && [data isKindOfClass:[NSDictionary class]]) {
				id paster_pack = data[@"paster_pack"];
				if (paster_pack && [paster_pack isKindOfClass:[NSArray class]]) {
					for (NSDictionary *dictPack in paster_pack) {
						PasterPackItem *pasterPackItem = [PasterPackItem yy_modelWithJSON:dictPack];
						[_arrayData addObject:pasterPackItem];
					}
				}
			}
		}
	}
}

- (void)loadMainData
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:kJsonCartoonFilePath]) {
		NSData *jsonData = [NSData dataWithContentsOfFile:kJsonCartoonFilePath];
		id result = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
		if (result && [result isKindOfClass:[NSDictionary class]]) {
			id data = result[@"data"];
			if (data && [data isKindOfClass:[NSDictionary class]]) {
				id pasterData = data[@"data"];
				if (pasterData && [pasterData isKindOfClass:[NSArray class]]) {
					for (NSDictionary *dict in pasterData) {
						MainItem *mainItem = [MainItem yy_modelWithJSON:dict];
						[_arrayData addObject:mainItem];
					}
				}
			}
		}
	}
}

- (void)saveTestPasters
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:kDocSavedPath]) {
		BOOL bRet = [fileManager createDirectoryAtPath:kDocSavedPath withIntermediateDirectories:YES attributes:nil error:NULL];
		NSLog(@"createDirectoryAtPath bRet: %d", bRet);
	}
	
	for (PasterItem *pasterItem in _arrayData) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSURL *url = [NSURL URLWithString:pasterItem.url];
			if (url == nil) {
				NSString *encodingUrl = [pasterItem.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				url = [NSURL URLWithString:encodingUrl];
			}
			NSData *data = [NSData dataWithContentsOfURL:url];
			NSString *fileName = [NSString stringWithFormat:@"%@.png", pasterItem.name];
			NSString *filePath = [kDocSavedPath stringByAppendingPathComponent:fileName];
			BOOL bRet = [data writeToFile:filePath atomically:YES];
			NSLog(@"bRet:%d ----- %@", bRet, fileName);
			
#if 0
			// Sample
			url = [NSURL URLWithString:pasterItem.sample_url];
			if (url == nil) {
				NSString *encodingUrl = [pasterItem.sample_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				url = [NSURL URLWithString:encodingUrl];
			}
			data = [NSData dataWithContentsOfURL:url];
			fileName = [NSString stringWithFormat:@"Sample_%@.png", pasterItem.name];
			filePath = [kDocSavedPath stringByAppendingPathComponent:fileName];
			bRet = [data writeToFile:filePath atomically:YES];
			NSLog(@"bRet:%d ----- %@", bRet, fileName);
			
			// Thumb
			url = [NSURL URLWithString:pasterItem.thumb_url];
			if (url == nil) {
				NSString *encodingUrl = [pasterItem.thumb_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				url = [NSURL URLWithString:encodingUrl];
			}
			data = [NSData dataWithContentsOfURL:url];
			fileName = [NSString stringWithFormat:@"Thumb_%@.png", pasterItem.name];
			filePath = [kDocSavedPath stringByAppendingPathComponent:fileName];
			bRet = [data writeToFile:filePath atomically:YES];
			NSLog(@"bRet:%d ----- %@", bRet, fileName);
#endif
			
			dispatch_async(dispatch_get_main_queue(), ^{
				
			});
		});
	}
}

- (void)saveRecommendPasters
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:kDocSavedPath]) {
		BOOL bRet = [fileManager createDirectoryAtPath:kDocSavedPath withIntermediateDirectories:YES attributes:nil error:NULL];
		NSLog(@"createDirectoryAtPath bRet: %d", bRet);
	}
	
	for (PasterPackItem *pasterPackItem in _arrayData) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			
			NSString *path = [kDocSavedPath stringByAppendingPathComponent:pasterPackItem.name];
			[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
			
			for (PasterItem *pasterItem in pasterPackItem.list) {
				NSURL *url = [NSURL URLWithString:pasterItem.url];
				if (url == nil) {
					NSString *encodingUrl = [pasterItem.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
					url = [NSURL URLWithString:encodingUrl];
				}
				NSData *data = [NSData dataWithContentsOfURL:url];
				NSString *fileName = [NSString stringWithFormat:@"%@_%@.png", pasterItem.name, @(pasterItem.resId)];
				NSString *filePath = [path stringByAppendingPathComponent:fileName];
				BOOL bRet = [data writeToFile:filePath atomically:YES];
				NSLog(@"bRet:%d ----- %@", bRet, fileName);
			}
		});
	}
}

- (void)saveMainPasters
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:kDocSavedPath]) {
		BOOL bRet = [fileManager createDirectoryAtPath:kDocSavedPath withIntermediateDirectories:YES attributes:nil error:NULL];
		NSLog(@"createDirectoryAtPath bRet: %d", bRet);
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	for (MainItem *mainItem in _arrayData) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			
			NSString *mainPath = [kDocSavedPath stringByAppendingPathComponent:mainItem.name];
			if (![fileManager fileExistsAtPath:mainPath]) {
				[fileManager createDirectoryAtPath:mainPath withIntermediateDirectories:YES attributes:nil error:NULL];
			}
			
			for (CategoryItem *categoryItem in mainItem.data) {
				
				NSString *categoryPath = [mainPath stringByAppendingPathComponent:categoryItem.name];
				if (![fileManager fileExistsAtPath:categoryPath]) {
					[fileManager createDirectoryAtPath:categoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
				}
				
				for (PasterItem *pasterItem in categoryItem.paster) {
					NSURL *url = [NSURL URLWithString:pasterItem.url];
					if (url == nil) {
						NSString *encodingUrl = [pasterItem.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
						url = [NSURL URLWithString:encodingUrl];
					}
					NSData *data = [NSData dataWithContentsOfURL:url];
					NSString *fileName = [NSString stringWithFormat:@"%@_%@.png", pasterItem.name, @(pasterItem.resId)];
					NSString *filePath = [categoryPath stringByAppendingPathComponent:fileName];
					BOOL bRet = [data writeToFile:filePath atomically:YES];
					NSLog(@"bRet:%d ----- %@", bRet, fileName);
				}
			}
			
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		});
	}
}

@end
