//
//  ViewController.m
//  RunLoopDemo
//
//  Created by kongfanlie on 2019/7/15.
//  Copyright © 2019 kongfanlie. All rights reserved.
//

#import "ViewController.h"
//#import "Person.h"
#import "TestDeallocModel.h"

UIKIT_EXTERN NSNotificationName const HYLiveAppDidEnterBackgroundNotification;

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *arrM;

//@property (nonatomic, strong) Person *person;

@property (nonatomic, strong) TestDeallocModel *propertyModel;

@property (nonatomic, strong) UIButton *btn;
@end

@implementation ViewController

TestDeallocModel *globalModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    extern UIView *view0;
//    NSLog(@"controller before %@", view0);
//    view0 = [[UIView alloc] init];
//    NSLog(@"controller after %@", view0);
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:HYLiveAppDidEnterBackgroundNotification object:nil];
    
//    Person<Chinese *> *person = [Person new];
//    Chinese *chinese = [Chinese new];
//    person = chinese;
//    self.person = [Person new];
//    self.arrM = [NSMutableArray array];
//
//    __weak typeof(self) weakSelf = self;
//    NSTimer *timer = [NSTimer  scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [weakSelf test];
//        NSLog(@"timer %zd, name:%@", weakSelf.arrM.count, weakSelf.person.name);
//    }];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 300, 100, 100)];
    [self.btn setBackgroundColor:[UIColor blueColor]];
    [self.btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self click];
//    });
    
    NSLog(@"VC initModel thread:%@", [NSThread currentThread]);
    self.propertyModel = [[TestDeallocModel alloc] init];
    
    // 主线程销毁，则dealloc中使用dispatch_async 或者 dispatch_get_main_queue() 都会crash
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self releaseModel];
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

- (void)test {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"thread:%@", [NSThread currentThread]);
        for (int i = 0; i < 20; i++) {
            @synchronized (self) {
                [self.arrM addObject:@"1"];
            }
//            NSLog(@"1 %zd", self.arrM.count);
//            self.person.name = @"1";
        }
    });
    
//    [self.arrM addObject:@"2"];
    @synchronized (self) {
        [self.arrM addObject:@"2"];
    }
//    self.person.name = @"2";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"thread:%@", [NSThread currentThread]);
        for (int i = 0; i < 20; i++) {
            @synchronized (self) {
                [self.arrM addObject:@"3"];
            }
//            NSLog(@"3 %zd", self.arrM.count);
//            self.person.name = @"3";
        }
    });
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
