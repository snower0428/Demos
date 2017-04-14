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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

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
