//
//  SubModel.m
//  RunLoopDemo
//
//  Created by kongfanlie on 2019/9/15.
//  Copyright © 2019 kongfanlie. All rights reserved.
//

#import "SubModel.h"
#import <objc/runtime.h>

@implementation BaseModel

- (void)dealloc {
    NSLog(@"BaseModel dealloc");
    self.baseName = nil;
}

- (void)setBaseName:(NSString *)baseName {
    _baseName = baseName;
    NSLog(@"BaseModel setBaseName:%@", baseName);
}

@end

@implementation SubModel// 继承自BaseModel

- (void)dealloc {
    NSLog(@"SubModel dealloc");
    self.baseName = nil;
//    [self performSelectorWhenDealloc];
}

- (void)setBaseName:(NSString *)baseName {
    [super setBaseName:baseName];
    NSLog(@"SubModel setBaseName:%@", [NSString stringWithString:_subName]);
}


/// 重写setter和getter就需要自定义实例变量（非property），不定义则没有.cxx_destruct方法
/// 当类拥有自己的实例变量(非property)时,编译器会自动的给我们添加.cxx_destruct方法
//- (void)setSubName:(NSString *)subName {
//
//}
//
//- (NSString *)subName {
//    return nil;
//}

- (void)printMethodName:(Class)cls {
    uint method_count;
    Method *methods = class_copyMethodList(cls, &method_count);
    for (uint index = 0; index < method_count; index ++) {
        Method method = methods[index];
        SEL sel = method_getName(method);
        NSLog(@"%@-%s ",cls, sel_getName(sel));
    }
}

- (void)performSelectorWhenDealloc {
    __weak typeof(self) weakSelf = self;
    // 模拟复杂的block结构，需要弱引用解除循环引用
    void (^block)(void) = ^ {
        [weakSelf test];
    };
    block();
}

- (void)test {
    
}
@end
