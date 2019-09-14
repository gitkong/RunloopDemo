//
//  TestDeallocModel.m
//  RunLoopDemo
//
//  Created by kongfanlie on 2019/9/1.
//  Copyright © 2019 kongfanlie. All rights reserved.
//

#import "TestDeallocModel.h"
#import "TestDeallocAssociatedObject.h"
#import <objc/runtime.h>

static char *KTestDeallocAssociatedObjectKey = "KTestDeallocAssociatedObjectKey";

@interface TestDeallocModel ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TestDeallocModel
/*
 dispatch_async不阻塞当前线程
 
 dispatch_sync阻塞当前线程
 
 主线程有一个特点：主线程会先执行主线程上的代码片段，然后才会去执行放在主队列中的任务。
 
 同步执行  dispatch_sync函数的特点：该函数只有在该函数中被添加到某队列的某方法执行完毕之后才会返回。即 方法会等待 task 执行完再返回
 */
- (void)dealloc {
    NSLog(@"TestDeallocModel dealloc:%p, thread:%@", self, [NSThread currentThread]);
//    @synchronized (self) {
//        [self test];
//    }
    /// 主线程中销毁的话，则标记crash都会crash
    
    // crash
//    TestDeallocModel *model = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [model test];
//    });
    
    // crash：在dealloc方法中系统会去调用把weak指针置nil的操作。
//    __weak typeof(self) weakSelf = self;
    
    // crash
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"async & global_queue %@", self);
//        [self test];
//    });
    // 添加睡眠则不会crash
//    sleep(3);
    
    // crash
//    [self invalidateTimer];
    
    // crash 先执行完主线程代码，后执行主队列代码
//    dispatch_async(dispatch_get_main_queue(), ^{
//        /// self 已经是野指针？
//        [self test];
//    });
//    sleep(3);
//    NSLog(@"TestDeallocModel dealloc after async & main_queue");
    // crash 主线程上同步执行主队列方法卡死
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self test];
    });
    
    // 此时不会crash，不管是主线程销毁还是子线程销毁
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        [self test];
    });
    
    // crash 主线程销毁，异步开启线程会导致crash
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self test];
//    });
    
    /*
     performSelectorOnMainThread && dispatch_get_main_queue
     */
    [self performSelectorOnMainThread:@selector(test) withObject:nil waitUntilDone:YES];
}

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"TestDeallocModel init:%p thread:%@", self, [NSThread currentThread]);
        
        // 添加关联对象
        TestDeallocAssociatedObject *object = [[TestDeallocAssociatedObject alloc] initWithDeallocBlock:^{
            NSLog(@"TestDeallocAssociatedObject dealloc");
        }];
        objc_setAssociatedObject(self, &KTestDeallocAssociatedObjectKey, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        // waitUntilDone YES 则等待完成后再往下执行
//        [self performSelectorOnMainThread:@selector(test) withObject:nil waitUntilDone:NO];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"---");
//        });
    }
    return self;
}

- (void)test {
    NSLog(@"TestDeallocModel test !!! thread:%@", [NSThread currentThread]);
}

- (void)fireTimer {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!weakSelf.timer) {
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                NSLog(@"TestDeallocModel timer:%p model:%p", timer, weakSelf);
            }];
            [[NSRunLoop currentRunLoop] addTimer:weakSelf.timer forMode:NSRunLoopCommonModes];
        }
    });
}

- (void)invalidateTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.timer) {
            NSLog(@"TestDeallocModel invalidateTimer:%p model:%p", self.timer, self);
            [self.timer invalidate];
            self.timer = nil;
        }
    });
}

@end
