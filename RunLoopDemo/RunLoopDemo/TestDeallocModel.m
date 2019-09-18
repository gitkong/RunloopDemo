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

- (void)dealloc {
    /// Recommended for debugging and logging purposes only:
    NSLog(@"TestDeallocModel dealloc:%p, thread:%@, queue:%@", self, [NSThread currentThread], dispatch_get_current_queue());
    
//    [self testWeakSelf];
    
//    [self invalidateTimer];
    
//    [self testGCD];
    
//    [self testPerformSelectorOnMainThreadAndWait:YES];
    
}

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"TestDeallocModel init:%p thread:%@", self, [NSThread currentThread]);
        
        // 添加关联对象
        TestDeallocAssociatedObject *object = [[TestDeallocAssociatedObject alloc] initWithDeallocBlock:^{
            NSLog(@"TestDeallocAssociatedObject dealloc");
        }];
        objc_setAssociatedObject(self, &KTestDeallocAssociatedObjectKey, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
//        [self fireTimer];
    }
    return self;
}

#pragma mark -
#pragma mark - begin- Private Method

- (void)testGCD {
//    [self testAsync:dispatch_queue_create("Kong", DISPATCH_QUEUE_CONCURRENT)];
//
//    [self testAsync:dispatch_queue_create("Kong", DISPATCH_QUEUE_SERIAL)];
//
//    [self testAsync:dispatch_get_global_queue(0, 0)];
//
//    [self testAsync:dispatch_get_main_queue()];
//
    [self testSync:dispatch_queue_create("Kong", DISPATCH_QUEUE_CONCURRENT)];

    [self testSync:dispatch_queue_create("Kong", DISPATCH_QUEUE_SERIAL)];

    [self testSync:dispatch_get_global_queue(0, 0)];
    
    [self testSync:dispatch_get_main_queue()];
}

- (void)testAsync:(dispatch_queue_t)queue {
    NSLog(@"async before");
    dispatch_async(queue, ^{
        NSLog(@"dispatch_async,%@, thread:%@", queue, [NSThread currentThread]);
        [self test];
    });
    NSLog(@"async after");
}

- (void)testSync:(dispatch_queue_t)queue {
    NSLog(@"sync before");
    dispatch_sync(queue, ^{
        NSLog(@"dispatch_sync,%@, thread:%@", queue, [NSThread currentThread]);
        [self test];
    });
    NSLog(@"sync after");
}

- (void)testWeakSelf {
    __weak typeof(self) weakSelf = self;
    /// 模拟实际情况下的block处理，例如网络请求等，实际情况可能会隐藏得更深
    void (^block)(void) = ^ {
        [weakSelf test];
    };
    block();
}

- (void)testPerformSelectorOnMainThreadAndWait:(BOOL)wait {
    [self performSelectorOnMainThread:@selector(test) withObject:nil waitUntilDone:wait];
}

- (void)test {
    NSLog(@"TestDeallocModel test !!! thread:%@", [NSThread currentThread]);
    //    NSLog(@"TestDeallocModel test !!! thread:%@, self=%@", [NSThread currentThread], self);
}

- (void)fireTimer {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!weakSelf.timer) {
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                NSLog(@"TestDeallocModel timer:%p", timer);
            }];
            [[NSRunLoop currentRunLoop] addTimer:weakSelf.timer forMode:NSRunLoopCommonModes];
        }
    });
}

- (void)invalidateTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        //sleep(2);
        if (self.timer) {
            NSLog(@"TestDeallocModel invalidateTimer:%p model:%p", self->_timer, self);
            [self.timer invalidate];
            self.timer = nil;
        }
    });
    NSLog(@"---");
}

#pragma mark end- Private Method

@end
