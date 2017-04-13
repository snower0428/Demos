//
//  NSURLSessionViewController.m
//  DataRequest
//
//  Created by leihui on 17/3/17.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

/**
 *	使用NSURLSession，分两步：
 *	1.通过NSURLSession的实例创建task.
 *	2.执行task.
 */

#import "NSURLSessionViewController.h"
#import "PHJSONDataOpt.h"

typedef NS_ENUM(NSInteger, ActionType) {
	ActionTypePost		= 100,
	ActionTypeDownload,
};

@interface NSURLSessionViewController ()

@end

@implementation NSURLSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self createContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)createContentView
{
	CGFloat leftMargin = 10.f;
	CGFloat topMargin = 100.f;
	CGFloat width = self.view.frame.size.width - leftMargin*2;
	CGFloat height = 44.f;
	CGFloat yInterval = 10.f;
	
	for (NSInteger i = 0; i < 2; i++) {
		CGRect frame = CGRectMake(leftMargin, topMargin+(height+yInterval)*i, width, height);
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = ActionTypePost+i;
		button.backgroundColor = kRandomColor;
		button.frame = frame;
		[self.view addSubview:button];
		[button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
	}
}

- (void)reqeustGlobalParamsData
{
	NSURL *requestUrl = [NSURL URLWithString:kGlobalParamsUrl];
	if (requestUrl) {
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
		request.HTTPMethod = @"POST";
		
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
		
		AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
		manager.responseSerializer = [AFHTTPResponseSerializer serializer];
		
		NSURLSessionDataTask *task = [manager dataTaskWithRequest:request
												completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
													if (responseObject) {
														id data = [PHJSONDataOpt parserjSONDataFromSvrEncodeByUTF8:responseObject];
														NSLog(@"data:%@", data);
														
														if (data && [data isKindOfClass:[NSDictionary class]]) {
															NSInteger code = [[data objectForKey:@"Code"] integerValue];
															NSLog(@"Code:%zd", code);
														}
													}
												}];
		[task resume];
	}
}

- (void)reqeustDownloadData
{
	NSURL *requestUrl = [NSURL URLWithString:kDownloadUrl];
	if (requestUrl) {
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestUrl];
		request.HTTPMethod = @"GET";
		
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
		
		AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
		manager.responseSerializer = [AFHTTPResponseSerializer serializer];
		
		NSURLSessionDataTask *task = [manager dataTaskWithRequest:request
												   uploadProgress:nil
												 downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
													 NSLog(@"fractionCompleted:%@ ----- totalUnitCount:%@ ----- completedUnitCount:%@",
														   @(downloadProgress.fractionCompleted), @(downloadProgress.totalUnitCount), @(downloadProgress.completedUnitCount));
												 } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
													 NSLog(@"completion");
												 }];
		[task resume];
	}
}

#pragma mark - Actions

- (void)btnAction:(id)sender
{
	NSInteger btnTag = ((UIButton *)sender).tag;
	switch (btnTag) {
		case ActionTypePost:
		{
			[self reqeustGlobalParamsData];
			break;
		}
		case ActionTypeDownload:
		{
			[self reqeustDownloadData];
			break;
		}
		default:
			break;
	}
}

@end

