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
 kCFRunLoopEntry = (1UL << 0),
 kCFRunLoopBeforeTimers = (1UL << 1),
 kCFRunLoopBeforeSources = (1UL << 2),
 kCFRunLoopBeforeWaiting = (1UL << 5),
 kCFRunLoopAfterWaiting = (1UL << 6),
 kCFRunLoopExit = (1UL << 7),
 kCFRunLoopAllActivities = 0x0FFFFFFFU
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
//        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, TestCFRunLoopObserverCallBack, NULL);
//        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
//        CFRelease(observer);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
