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

@property (nonatomic, strong) TestDeallocModel *propertyModel;

@end

@implementation ViewController

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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf releaseModel];
    });
}

- (void)releaseModel {
    NSLog(@"VC releaseModel thread:%@", [NSThread currentThread]);
    _propertyModel = nil;
}
@end
