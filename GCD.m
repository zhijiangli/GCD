//
//  GCD.m
//  ZHSRTM
//
//  Created by 小黎 on 2017/12/15.
//  Copyright © 2017年 小黎. All rights reserved.
//
//
#import "GCD.h"
static dispatch_source_t timer;
@implementation GCD
/** 异步子线程*/
+(void)openTheSubthread:(void(^)(void))subthread backToTheMainThread: (void(^)(void))mainThread{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        subthread();
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            mainThread();
        });
    });
}
/** 整个程序中之执行一次*/
+(void)onceExecutBlock:(void(^)(void))codeBlock{
    static  dispatch_once_t  disOnce;
    dispatch_once(&disOnce, ^ {
        //这里写只操作一次的代码
        codeBlock();
    });
}
/** 延迟执*/
+(void)afterTime:(NSTimeInterval)time executBlock:(void(^)(void))codeBlock{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        codeBlock();
    });
}
/** 定时器*/
+(void)openTimer:(NSTimeInterval)time executBlock:(void(^)(void))codeBlock{
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 何时开始执行第一个任务
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(time * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, start, interval, 0);
    // 设置回调
    dispatch_source_set_event_handler(timer, ^{
        codeBlock();
    });
    // 启动定时器
    dispatch_resume(timer);
}
/** 销毁定时器*/
+(void)invalidateTimer{
    dispatch_cancel(timer);
    timer = nil;
}
@end
