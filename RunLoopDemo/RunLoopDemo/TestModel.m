//
//  TestModel.m
//  RunLoopDemo
//
//  Created by kongfanlie on 2019/9/15.
//  Copyright © 2019 kongfanlie. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

- (void)dealloc {
    dispatch_async(dispatch_queue_create("Kong", 0), ^{
        [self test];
    });
}

- (void)test {
    /// log
    NSLog(@"TestModel test");
}

- (void)weakSelfTest {
    /// weak self
    __weak typeof(self) weakSelf = self;
}

@end
