//
//  GlobalVariableDefine.h
//  Weather
//
//  Created by logiph on 3/10/13.
//  Copyright (c) 2013 logiph. All rights reserved.
//

// 快速创建一个弱引用对象
// 常见用法：__weak __typeof(self)weakSelf = self;
//    __strong __typeof(weakSelf)strongSelf = weakSelf;

#define kWeakValue(value)   __weak __typeof(&*value)weakValue = value
#define kStrongValue(value) __strong __typeof(&*value)strongValue = value

// 快速获取self的Weak/Strong引用对象
#define kWeakSelf   __weak __typeof(&*self)weakSelf = self;
#define kStrongSelf __strong __typeof(&*weakSelf)strongSelf = weakSelf;

/* 获取全局操作队列 */
#define global_queue_main       dispatch_get_main_queue()
#define global_queue_default    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define global_queue_high       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
#define global_queue_low        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)

/* 获取全局自定义操作队列 */
#define global_queue_app_concurrent [[ManagerFactory sharedAppRunCircle] appConcurrentAsyncQueue]   //并行队列
#define global_queue_app_serial     [[ManagerFactory sharedAppRunCircle] appSerialAsyncQueue]       //串行队列

/* 在指定操作队列异步执行 */
#define global_async_on_queue(queue, block) dispatch_async(queue, block)
#define global_async_queue_main(block)      dispatch_async(global_queue_main, block)
#define global_async_queue_default(block)   dispatch_async(global_queue_default, block)
#define global_async_queue_high(block)      dispatch_async(global_queue_high, block)
#define global_async_queue_low(block)       dispatch_async(global_queue_low, block)

/* 全局自定义并行队列：执行异步操作（异步操作可并发） */
//#define global_async_app_concurrent(block) do { \
//    [[ManagerFactory sharedAppRunCircle] addAsyncConcurrentQueueOperation:block]; \
//} while(0)

/* 全局自定义并行队列：执行异步栅栏操作（等待并发完成后执行） */
//#define global_async_app_concurrent_barrier(block) do { \
//    [[ManagerFactory sharedAppRunCircle] addAyncConcurrentQueueBarrier:block]; \
//} while(0)

/* 全局自定义串行队列：指定异步操作（异步操作串行）*/
//#define global_async_app_serial(block) do { \
//    [[ManagerFactory sharedAppRunCircle] addAsyncSerialQueueOperation:block]; \
//} while(0)

/* 日志保存队列 */
//#define global_async_save_log(block) do { \
//    [[DeviceLogUtils sharedInstance] addAsyncSaveLogOperation:block]; \
//} while(0)

/* 延迟执行 */
#define global_dispatch_after(queue, delay, block) do { \
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (delay) * NSEC_PER_SEC); \
    dispatch_after(delayTime, queue, block); \
} while(0)

#define NDBlokCopy(destination, source) do { \
    if (destination) { \
        Block_release(destination); \
        destination = nil; \
    } \
    destination = Block_copy(source); \
} while(0)

#define NDBlockRelease(destination) do { \
    if (destination) { \
        Block_release(destination); \
        destination = nil;   \
    } \
} while(0)

//设置view的边框颜色和大小用于界面调试

#define kSetViewLayerBorderColorAndWidth(view, color, width) \
view.layer.borderColor = color.CGColor;\
view.layer.borderWidth = width;

#define felink_dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define felink_dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

