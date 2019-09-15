//
//  ViewController.m
//  RunLoopDemo
//
//  Created by kongfanlie on 2019/7/15.
//  Copyright © 2019 kongfanlie. All rights reserved.
//

#import "ViewController.h"
#import "TestDeallocModel.h"
#import "SubModel.h"
#import "TestModel.h"

UIKIT_EXTERN NSNotificationName const HYLiveAppDidEnterBackgroundNotification;

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *arrM;

@property (nonatomic, strong) TestDeallocModel *propertyModel;

@property (nonatomic, strong) UIButton *btn;
@end

@implementation ViewController {
    dispatch_semaphore_t _semaphore;
    int _index;
}

TestDeallocModel *globalModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SubModel *model = [[SubModel alloc] init];
    model.subName = @"kong";
    model.temp = @"string";
//  watchpoint set variable model->_temp
    [model printMethodName:[SubModel class]];
    [model printMethodName:[SubModel superclass]];
    
    NSLog(@"VC initModel thread:%@", [NSThread currentThread]);
    self.propertyModel = [[TestDeallocModel alloc] init];
    
    // 主线程销毁，则dealloc中使用dispatch_async 或者 dispatch_get_main_queue() 都会crash
//    dispatch_get_global_queue(0, 0)、dispatch_get_main_queue()
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        [weakSelf releaseModel];
    });
    
    /*
     // 属性变量 子线程创建、子线程中释放，dealloc在 子线程 中处理，则dealloc中使用dispatch_async 或者 dispatch_get_main_queue() 都不会crash
     */
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"VC initModel thread:%@", [NSThread currentThread]);
//        self.propertyModel = [[TestDeallocModel alloc] init];
////        globalModel = [[TestDeallocModel alloc] init];
//    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
//        [self click];
//    });
    
    /*
     // 临时变量 子线程创建、子线程中释放，dealloc就在 子线程 中处理
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        TestDeallocModel *model = [[TestDeallocModel alloc] init];
        NSLog(@"VC 子线程中创建临时变量:%@", [NSThread currentThread]);
    });
     */
}

- (void)appDidEnterBackground:(NSNotification *)notification {
    NSLog(@" back ground ");
}

// 模拟器：libMobileGestalt MobileGestalt.c:890: MGIsDeviceOneOfType is not supported on this platform.
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//}

- (void)click {
    NSLog(@"touch thread:%@", [NSThread currentThread]);
    [self.propertyModel invalidateTimer];
    [self releaseModel];
}

- (void)releaseModel {
    NSLog(@"VC releaseModel thread:%@", [NSThread currentThread]);
//    self.propertyModel = nil;
    _propertyModel = nil;
    globalModel = nil;
}
@end
