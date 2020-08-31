//
//  TestViewController.m
//  TempDemo
//
//  Created by leihui on 17/3/14.
//  Copyright © 2017年 ND WebSoft Inc. All rights reserved.
//

#import "TestViewController.h"
#import "LHAlertView.h"
#import "EOCAutoDictionary.h"

@interface TestViewController ()

@property (nonatomic, strong) NSString *sString;
@property (nonatomic, copy) NSString *cString;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAction:)];
	self.navigationItem.rightBarButtonItem = rightItem;
	
//	[self testAsync];
	[self testBarrier];
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
	//dispatch_queue_t queue = dispatch_queue_create("com.lh.test.serial", DISPATCH_QUEUE_SERIAL);
	// 并行队列
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_group_t group = dispatch_group_create();
    
    // 低优先级队列
    //dispatch_queue_t lowPriorityQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    // 高优先级队列
    //dispatch_queue_t highPriorityQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
	dispatch_group_async(group, queue, ^{
		NSLog(@"<<< Task A >>>");
		for (NSInteger i = 0; i < 100; i++) {
			NSLog(@"Task A ------------------------------ %zd", i);
		}
	});
	dispatch_group_async(group, queue, ^{
		NSLog(@"<<< Task B >>>");
		for (NSInteger i = 0; i < 100; i++) {
			NSLog(@"Task B ------------------------------ %zd", i);
		}
	});
	dispatch_group_async(group, queue, ^{
		NSLog(@"<<< Task C >>>");
		for (NSInteger i = 0; i < 100; i++) {
			NSLog(@"Task C ------------------------------ %zd", i);
		}
	});
	dispatch_group_async(group, queue, ^{
		NSLog(@"<<< Task D >>>");
		for (NSInteger i = 0; i < 100; i++) {
			NSLog(@"Task D ------------------------------ %zd", i);
		}
	});
    // 执行完成后，所选用的队列，可以选用主队列，这个可以根据情况下决定。
    dispatch_group_notify(group, queue, ^{
        // A,B,C,D执行完成后会回调这里
        // 如果要让A,B,C,D顺序执行，可以使用串行队列来实现
        NSLog(@"<<< group_notify >>>");
    });
    
    // 等待group执行完成之后，再执行下面的任务
    //dispatch_wait(group, DISPATCH_TIME_FOREVER);
    //NSLog(@"<<< GROUP DONE >>>");
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

/**
 *	dispatch_barrier_async的作用：
 *	它等待所有位于 dispatch_barrier_async 函数之前的操作执行完毕后执行，
 *	并且在 dispatch_barrier_async 函数执行之后，dispatch_barrier_async 之后的操作才会得到执行。
 *
 *	dispatch_barrier_async, 该函数只能搭配自定义的并行队列 dispatch_queue_t 使用。
 *	不能使用 dispatch_get_global_queue, 否则效果会和 dispatch_async 一样。
 */
- (void)testBarrier
{
	dispatch_queue_t queue = dispatch_queue_create("com.lh.test.berrier", DISPATCH_QUEUE_CONCURRENT);
	for (NSInteger i = 0; i < 50; i++) {
		dispatch_async(queue, ^{
			NSLog(@"i = %zd ----- currentThread:%@", i, [NSThread currentThread]);
		});
	}
	dispatch_barrier_async(queue, ^{
		NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> barrier <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ----- currentThread:%@", [NSThread currentThread]);
	});
	for (NSInteger j = 0; j < 50; j++) {
		dispatch_async(queue, ^{
			NSLog(@"j === %zd ----- currentThread:%@", j, [NSThread currentThread]);
		});
	}
}

#pragma mark - Actions

- (void)rightAction:(id)sender
{
	//[self testSignal];
	
#if 0
	// UIAlertView block 实现
	LHAlertView *alertView = [[LHAlertView alloc] initWithTitle:@"Title" message:@"Message" block:^(NSInteger index) {
		if (index == 0) {
			NSLog(@"Cancel");
		}
		else if (index == 1) {
			NSLog(@"OK");
		}
	} cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alertView show];
#endif
	
	EOCAutoDictionary *dict = [EOCAutoDictionary new];
	dict.date = [NSDate date];
	NSLog(@"date:%@", dict.date);
}

@end
