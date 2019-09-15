//
//  main.m
//  RunLoopDemo
//
//  Created by kongfanlie on 2019/7/15.
//  Copyright © 2019 kongfanlie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
/*
 typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
 kCFRunLoopEntry         = (1UL << 0), // 即将进入Loop
 kCFRunLoopBeforeTimers  = (1UL << 1), // 即将处理 Timer
 kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
 kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠
 kCFRunLoopAfterWaiting  = (1UL << 6), // 刚从休眠中唤醒
 kCFRunLoopExit          = (1UL << 7), // 即将退出Loop
 };
 */
void TestCFRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"RunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"RunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"RunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"RunLoopBeforeWaiting");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"RunLoopAfterWaiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"RunLoopExit");
            break;
        default:
            break;
    }
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopBeforeSources, YES, 0, TestCFRunLoopObserverCallBack, NULL);
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
        CFRelease(observer);
        NSLog(@"Main, thread:%@, queue:%@", [NSThread currentThread], dispatch_get_current_queue());
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
