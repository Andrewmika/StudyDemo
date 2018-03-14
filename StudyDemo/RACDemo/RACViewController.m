//
//  RACViewController.m
//  StudyDemo
//
//  Created by Andrew Shen on 27/02/2018.
//  Copyright © 2018 小小厨师的厨房. All rights reserved.
//

#import "RACViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface RACViewController ()

@end

@implementation RACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RAC";
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    //    [self p_subject];
    
    //    [self p_replaySubject];
    //    [self p_RACBehaviorSubject];
    //    [self p_RACCommand];
    //    [self p_signal];
    //    [self p_RACSequence];
    //    [[RACScheduler scheduler] schedule:^{
    //        [self p_RACScheduler];
    //    }];
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 错误和结束发送只能二选一
        // [subscriber sendError:[NSError errorWithDomain:@"RACDemo" code:110 userInfo:@{NSLocalizedDescriptionKey : @"错误"}]];
        [subscriber sendNext:@"ss"];
        [[RACScheduler scheduler] afterDelay:2 schedule:^{
            [subscriber sendNext:@"a"];
        }];
        [[RACScheduler scheduler] afterDelay:4 schedule:^{
            [subscriber sendNext:@"b"];
        }];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"-------------->disposable");
        }];
    }];
    RACDisposable *d = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------------->%@",x);
    }];
    [[RACScheduler scheduler] afterDelay:3 schedule:^{
        [d dispose];
    }];
    [[RACScheduler scheduler] afterDelay:5 schedule:^{
        [signal subscribeNext:^(id  _Nullable x) {
            NSLog(@"-------------->2：%@",x);
        }];
    }];
}

// RACSignal
- (void)p_signal {
    // 创建信号
    static NSInteger sendCount = 0;
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *temp = [NSString stringWithFormat:@"----->发送信号:%ld",++sendCount];
        NSLog(@"%@",temp);
        [subscriber sendNext:temp];
        [subscriber sendCompleted];
        // 错误和结束发送只能二选一
        // [subscriber sendError:[NSError errorWithDomain:@"RACDemo" code:110 userInfo:@{NSLocalizedDescriptionKey : @"错误"}]];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"-------------->disposable");
        }];
    }];
    RACReplaySubject *subject = [RACReplaySubject subject];
    RACMulticastConnection *connection = [signal multicast:subject];
    // 订阅信号
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------------->第一次订阅：%@", x);
    }];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------------->第二次订阅：%@", x);
    }];
    [connection connect];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------------->第三次订阅：%@", x);
    }];
    
    
}

// RACSubject
- (void)p_subject {
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------------->RACSubject1:%@",x);
    }];
    [subject sendNext:@"B"];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------------->RACSubject2:%@",x);
    }];
    [subject sendNext:@"C"];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------------->RACSubject3:%@",x);
    }];
    [subject sendNext:@"D"];
}

// RACReplaySubject
- (void)p_replaySubject {
    RACReplaySubject *subject = [RACReplaySubject subject];
    [subject sendNext:@"A"];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------------->RACReplaySubject1:%@",x);
    }];
    [subject sendNext:@"B"];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------------->RACReplaySubject2:%@",x);
    }];
    [subject sendNext:@"C"];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------------->RACReplaySubject3:%@",x);
    }];
    [subject sendNext:@"D"];
}

// RACBehaviorSubject
- (void)p_RACBehaviorSubject {
    RACBehaviorSubject *sub = [RACBehaviorSubject behaviorSubjectWithDefaultValue:@"init"];
    [sub subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------------->RACBehaviorSubject1:%@",x);
    }];
    [sub sendNext:@"A"];
    [sub sendNext:@"B"];
    
    [sub subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------------->RACBehaviorSubject2:%@",x);
    }];
    [sub sendNext:@"C"];
    
}

- (void)p_RACCommand {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"-------------->RACSignal:%@",input);
            [subscriber sendNext:input];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"-------------->disposable");
            }];
        }];
    }];
    [[command.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------------->getData:%@",x);
    }];
    [command execute:@"inputData"];
}

- (void)p_RACSequence {
    RACSequence *results = [[@[@"1",@"22",@"333"].rac_sequence
                             filter:^ BOOL (NSString *str) {
                                 return str.length >= 2;
                             }]
                            map:^(NSString *str) {
                                NSLog(@"-------------->x:%@",str);
                                return [str stringByAppendingString:@"foobar"];
                            }];
    [results.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------------->result:%@",x);
    }];
    NSArray *array = results.array;
    NSLog(@"-------------->array:%@",array);
    
}

- (void)p_RACScheduler {
    NSLog(@"-------------->currentThread:%@",[NSThread currentThread]);
    [[RACScheduler immediateScheduler] schedule:^{
        NSLog(@"-------------->immediateThread1:%@",[NSThread currentThread]);
    }];
    [[RACScheduler mainThreadScheduler] schedule:^{
        NSLog(@"-------------->mainThreadSchedulerThread2:%@",[NSThread currentThread]);
    }];
    [[RACScheduler schedulerWithPriority:RACSchedulerPriorityHigh] schedule:^{
        NSLog(@"-------------->PriorityThread3:%@",[NSThread currentThread]);
    }];
    
    [[RACScheduler scheduler] schedule:^{
        NSLog(@"-------------->schedulerThread4:%@",[NSThread currentThread]);
    }];
    [[RACScheduler currentScheduler] schedule:^{
        NSLog(@"-------------->currentSchedulerThread5:%@",[NSThread currentThread]);
    }];
}

@end
