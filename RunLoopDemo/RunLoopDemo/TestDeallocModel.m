//
//  TestDeallocModel.m
//  RunLoopDemo
//
//  Created by kongfanlie on 2019/9/1.
//  Copyright © 2019 kongfanlie. All rights reserved.
//

#import "TestDeallocModel.h"

@interface TestDeallocModel ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TestDeallocModel

- (void)dealloc {
    NSLog(@"TestDeallocModel dealloc:%p, thread:%@", self, [NSThread currentThread]);
//    @synchronized (self) {
//        [self test];
//    }
    DISPATCH_ONCE_INLINE_FASTPATH
    /// 主线程中销毁的话，则标记crash都会crash
    
    // crash
    TestDeallocModel *model = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [model test];
    });
    
    // crash：在dealloc方法中系统会去调用把weak指针置nil的操作。
//    __weak typeof(self) weakSelf = self;
    
    // crash
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self test];
    });
    
    // crash
    [self invalidateTimer];
    
    // crash
    dispatch_async(dispatch_get_main_queue(), ^{
        [self test];
    });

    // crash
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self test];
    });
    
    // 此时不会crash，不管是主线程销毁还是子线程销毁
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        [self test];
    });
    
    // crash 主线程销毁，异步开启线程会导致crash
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self test];
    });
    
    /*
     performSelectorOnMainThread && dispatch_get_main_queue
     */
    [self performSelectorOnMainThread:@selector(test) withObject:nil waitUntilDone:YES];
}

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"TestDeallocModel init:%p thread:%@", self, [NSThread currentThread]);
        
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
