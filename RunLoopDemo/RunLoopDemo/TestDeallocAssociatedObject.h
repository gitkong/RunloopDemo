//
//  TestDeallocAssociatedObject.h
//  RunLoopDemo
//
//  Created by kongfanlie on 2019/9/3.
//  Copyright © 2019 kongfanlie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestDeallocAssociatedObject : NSObject

- (instancetype)initWithDeallocBlock:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
