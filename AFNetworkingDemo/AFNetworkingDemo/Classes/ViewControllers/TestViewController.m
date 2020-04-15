//
//  TestViewController.m
//  AFNetworkingDemo
//
//  Created by leihui on 17/3/14.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "TestViewController.h"
#import <FLEncrypt/FLEncrypt.h>
#import <AFNetworking/AFNetworking.h>
#import "NSData+Extend.h"

#define kUrl    @"http://searchjapi.ifjing.com/common/prompt?"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor orangeColor];
    
//    [self requestDataOriginal];
    [self requestDataAF];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (NSString *)searchValue {
    return @"我们";
}

- (NSString *)md5Value {
    NSString *signKey = @"5B123456-5BB4-427E-8F2A-5833116A6A73";
    NSString *key = [NSString stringWithFormat:@"%@%@", signKey, [self searchValue]];
    NSString *md5String = [FLMD5 md5String:key];
    return md5String;
}

/**
 * 使用NSURLSession进行网络请求主要分为以下几个步骤：
 * 1.创建configuration对象，这个对象可以设置进行网络请求的一些属性，例如timeoutIntervalForRequest,allowsCellularAccess等等。
 * 2.通过configuration对象创建session对象，一个session对象可以管理多个task。
 * 3.通过URL创建request对象，
 *   通俗的理解，一个网络请求包括起始行，请求头，请求体，
 *   那么一个request对象也就封装了起始行，请求头，请求体这些内容。
 *   另外，其实request也可以行使configuration的功能，
 *   通过它的属性可以设置timeoutIntervalForRequest,allowsCellularAccess等等。
 * 4.通过session和request来创建task对象。
 */
- (void)requestDataOriginal {
    // 1.创建Configuration对象，并设置各种属性
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 10.0;
    configuration.allowsCellularAccess = YES;
    
    // 2.通过Configuration创建session，一个session可以管理多个task
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // 3.通过URL创建request
    NSString *requestUrl = [NSString stringWithFormat:@"%@&key=%@&sign=%@", kUrl, [self searchValue], [self md5Value]];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    request.HTTPMethod = @"GET";
    
    // 4.通过session和request来创建task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *strData = [data convertedToUtf8String];
        NSLog(@"strData:%@", strData);
    }];
    [dataTask resume];
}

// 使用AFNetworking请求
- (void)requestDataAF {
    NSDictionary *params = @{@"key": [self searchValue],
                             @"sign": [self md5Value]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.allowsCellularAccess = YES;
    [manager GET:kUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downloadProgress:%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject:%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
}

@end
