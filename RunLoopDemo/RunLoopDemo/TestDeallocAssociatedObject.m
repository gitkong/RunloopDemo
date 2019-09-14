//
//  TestDeallocAssociatedObject.m
//  RunLoopDemo
//
//  Created by kongfanlie on 2019/9/3.
//  Copyright © 2019 kongfanlie. All rights reserved.
//

#import "TestDeallocAssociatedObject.h"

@implementation TestDeallocAssociatedObject {
    void(^_block)(void);
}

- (instancetype)initWithDeallocBlock:(void (^)(void))block {

    if (self = [super init]) {
        self->_block = [block copy];
    }
    return self;
}

- (void)dealloc {
    if (self->_block) {
        self->_block();
    }
}

@end
