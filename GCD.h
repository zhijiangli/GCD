//
//  GCD.h
//  ZHSRTM
//
//  Created by 小黎 on 2017/12/15.
//  Copyright © 2017年 小黎. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface GCD : NSObject
/** 异步子线程*/
+(void)openTheSubthread:(void(^)(void))subthread backToTheMainThread: (void(^)(void))mainThread;
/** 整个程序中之执行一次*/
+(void)onceExecutBlock:(void(^)(void))codeBlock;
/** 延迟执*/
+(void)afterTime:(NSTimeInterval)time executBlock:(void(^)(void))codeBlock;
/** 定时器*/
+(void)openTimer:(NSTimeInterval)time executBlock:(void(^)(void))codeBlock;
/** 销毁定时器*/
+(void)invalidateTimer;
@end
