//
//  TestViewController.m
//  TempDemo
//
//  Created by leihui on 17/3/14.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction:)];
	self.navigationItem.rightBarButtonItem = rightItem;
	
	//[self testAsync];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

/**
 *	判断四个异步请求都完成
 *	通过 group 来实现，
 */
- (void)testAsync
{
	// 串行队列
	dispatch_queue_t queue = dispatch_queue_create("com.lh.test.serial", DISPATCH_QUEUE_SERIAL);
	// 并行队列
	//dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_group_t group = dispatch_group_create();
	dispatch_group_async(group, queue, ^{
		NSLog(@"<<< Task A >>>");
		for (NSInteger i = 0; i < 100; i++) {
			NSLog(@"Task A ------------------------------------------------------------ %zd", i);
		}
	});
	dispatch_group_async(group, queue, ^{
		NSLog(@"<<< Task B >>>");
		for (NSInteger i = 0; i < 100; i++) {
			NSLog(@"Task B ------------------------------------------------------------ %zd", i);
		}
	});
	dispatch_group_async(group, queue, ^{
		NSLog(@"<<< Task C >>>");
		for (NSInteger i = 0; i < 100; i++) {
			NSLog(@"Task C ------------------------------------------------------------ %zd", i);
		}
	});
	dispatch_group_async(group, queue, ^{
		NSLog(@"<<< Task D >>>");
		for (NSInteger i = 0; i < 100; i++) {
			NSLog(@"Task D ------------------------------------------------------------ %zd", i);
		}
	});
	dispatch_group_notify(group, queue, ^{
		// A,B,C,D执行完成后会回调这里
		// 如果要让A,B,C,D顺序执行，可以使用串行队列来实现
		NSLog(@"<<< group_notify >>>");
	});
}

- (void)testSignal
{
	dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
	dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
	
	NSMutableArray *array = [NSMutableArray array];
	
	for (NSInteger i = 0; i < 20; i++) {
		dispatch_async(queue, ^{
			NSLog(@"async: %zd", i);
			dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW);
			NSLog(@"semaphore: %zd", i);
			
			[array addObject:@(i)];
			
			dispatch_semaphore_signal(semaphore);
		});
	}
}

#pragma mark - Actions

- (void)rightAction:(id)sender
{
	[self testSignal];
}

@end
