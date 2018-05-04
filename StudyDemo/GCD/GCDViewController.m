//
//  GCDViewController.m
//  StudyDemo
//
//  Created by Andrew Shen on 2018/4/26.
//  Copyright © 2018年 小小厨师的厨房. All rights reserved.
//

#import "GCDViewController.h"

typedef NS_ENUM(NSUInteger, GCDActionTag) {
    GCDActionTagSync,
    GCDActionTagAsync,
    GCDActionTagAfter,
    GCDActionTagBarrier,
    GCDActionTagGroup,
    GCDActionTagApply,
    GCDActionTagTarget,
    GCDActionTagSuspend,
    GCDActionTagSemaphore,
    GCDActionTagSpecific,
};

@interface GCDViewController ()
@property (nonatomic, copy)  NSArray<NSString *>  *dataSource; // <##>
@property (nonatomic, strong)  dispatch_queue_t  sQ; // <##>
@property (nonatomic, strong)  dispatch_queue_t  cQ; // <##>
@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (void)p_actionClicked:(GCDActionTag)tag {
    switch (tag) {
        case GCDActionTagSync:
            [self p_sync];
            break;
        case GCDActionTagAsync:
            [self p_async];

            break;
        case GCDActionTagAfter:
            [self p_after];
            break;
        case GCDActionTagBarrier:
            [self p_barriers];
            break;
        case GCDActionTagGroup:
            [self p_group];
            break;
        case GCDActionTagApply:
            [self p_apply];
            break;
        case GCDActionTagTarget:
            [self p_setTarget];
            break;
        case GCDActionTagSuspend:
            [self p_suspendQ];
            break;
        case GCDActionTagSemaphore:
            [self p_semaphore];
            break;
        case GCDActionTagSpecific:
            [self p_specific];
            break;
        default:
            break;
    }
}

- (void)p_sync {
    NSLog(@"--->sync-1");
    dispatch_sync(self.sQ, ^{
        NSLog(@"--->sync-2");
    });
    dispatch_sync(self.sQ, ^{
        NSLog(@"--->sync-3");
    });
    dispatch_sync(self.cQ, ^{
        NSLog(@"--->sync-4");
    });
    dispatch_sync(self.cQ, ^{
        NSLog(@"--->sync-5");
    });
    NSLog(@"--->sync-6");
}

- (void)p_async {
    NSLog(@"--->async-1-thread:%@",[NSThread currentThread]);
    dispatch_async(self.sQ, ^{
        sleep(1);
        NSLog(@"--->async-2-thread:%@",[NSThread currentThread]);
    });
    dispatch_async(self.sQ, ^{
        NSLog(@"--->async-3-thread:%@",[NSThread currentThread]);
    });
    dispatch_async(self.cQ, ^{
        sleep(1);
        NSLog(@"--->async-4-thread:%@",[NSThread currentThread]);
    });
    dispatch_async(self.cQ, ^{
        NSLog(@"--->async-5-thread:%@",[NSThread currentThread]);
    });
    dispatch_async(self.sQ, ^{
        NSLog(@"--->async-6-1-thread:%@",[NSThread currentThread]);
        dispatch_async(self.sQ, ^{
            NSLog(@"--->async-6-2-thread:%@",[NSThread currentThread]);
        });
    });
    NSLog(@"--->async-7-thread:%@",[NSThread currentThread]);
}

- (void)p_after {
    NSLog(@"--->after-1");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"--->after-2");
    });
    NSLog(@"--->after-3");

}

- (void)p_barriers {
    // 在自定义并发队列中使用
    NSLog(@"--->barrier-1");
    dispatch_async(self.cQ, ^{
        sleep(1);
        NSLog(@"--->barrier-2");
    });
    dispatch_async(self.cQ, ^{
        NSLog(@"--->barrier-3");
    });
    dispatch_barrier_sync(self.cQ, ^{
        sleep(1);
        NSLog(@"--->barrier-4");
    });
    dispatch_barrier_sync(self.cQ, ^{
        NSLog(@"--->barrier-5");
    });
    dispatch_barrier_async(self.cQ, ^{
        sleep(1);

        NSLog(@"--->barrier-6");
    });
    dispatch_barrier_async(self.cQ, ^{
        NSLog(@"--->barrier-7");
    });
    dispatch_async(self.cQ, ^{
        NSLog(@"--->barrier-8");
    });
    dispatch_async(self.cQ, ^{
        NSLog(@"--->barrier-9");
    });
    NSLog(@"--->barrier-1-1");
}

- (void)p_group {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, self.cQ, ^{
        sleep(1);
        NSLog(@"--->group-1");
    });
    dispatch_group_async(group, self.cQ, ^{
        sleep(1);
        NSLog(@"--->group-2");
    });
    dispatch_group_async(group, self.cQ, ^{
        dispatch_async(self.cQ, ^{
            // 异步事件需要用dispatch_group_enter
            sleep(5);
            NSLog(@"--->group-error");
        });
    });
    dispatch_group_enter(group);
    dispatch_async(self.cQ, ^{
        sleep(1);
        NSLog(@"--->group-3");
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_async(self.cQ, ^{
        sleep(1);
        NSLog(@"--->group-4");
        dispatch_group_leave(group);
    });
    dispatch_group_notify(group, self.cQ, ^{
        NSLog(@"--->group-complete");
    });
}

- (void)p_apply {
    NSLog(@"--->apply-1");
    dispatch_apply(3, self.cQ, ^(size_t t) {
        sleep(1);
        dispatch_async(self.cQ, ^{
            NSLog(@"--->apply-async-%ld",t);
        });
    });
    dispatch_apply(3, self.cQ, ^(size_t t) {
        sleep(1);
        NSLog(@"--->apply-sync-%ld",t);
    });
    NSLog(@"--->apply-2");
}

- (void)p_setTarget {
    dispatch_queue_t lowQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);

    dispatch_async(self.cQ, ^{
        NSLog(@"--->low-1");
    });
    dispatch_async(self.cQ, ^{
        NSLog(@"--->low-2");
    });
    dispatch_async(self.cQ, ^{
        NSLog(@"--->low-3");
    });
    dispatch_set_target_queue(self.cQ, lowQ);
    dispatch_async(self.cQ, ^{
        NSLog(@"--->low-4");
    });
    dispatch_async(self.cQ, ^{
        NSLog(@"--->low-5");
    });
    dispatch_async(self.cQ, ^{
        NSLog(@"--->low-6");
    });
    
    dispatch_queue_t defaultQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(defaultQ, ^{
        NSLog(@"--->default-1");
    });
    dispatch_async(defaultQ, ^{
        NSLog(@"--->default-2");
    });
    dispatch_async(defaultQ, ^{
        NSLog(@"--->default-3");
    });
    dispatch_async(defaultQ, ^{
        NSLog(@"--->default-4");
    });
}

- (void)p_suspendQ {
    dispatch_async(self.cQ, ^{
        NSLog(@"--->suspend-1");
    });
    dispatch_async(self.cQ, ^{
        NSLog(@"--->suspend-2");
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(self.cQ, ^{
            NSLog(@"--->suspend-3");
        });
        dispatch_async(self.cQ, ^{
            NSLog(@"--->suspend-4");
        });
        dispatch_async(self.cQ, ^{
            NSLog(@"--->suspend-5");
        });
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"--->suspend");
        dispatch_suspend(self.cQ);
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"--->resume");
        dispatch_resume(self.cQ);
    });
}

- (void)p_semaphore {
    dispatch_semaphore_t smp = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(smp, DISPATCH_TIME_FOREVER);
        dispatch_async(self.cQ, ^{
            NSLog(@"--->semaphore-1");
            sleep(2);
            dispatch_semaphore_signal(smp);
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(smp, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(2);
            NSLog(@"--->semaphore-2");
            dispatch_semaphore_signal(smp);
        });
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(smp, DISPATCH_TIME_FOREVER);
        dispatch_async(self.cQ, ^{
            sleep(2);
            NSLog(@"--->semaphore-3");
            dispatch_semaphore_signal(smp);
        });
    });
    
}

- (void)p_specific {
    static void *key = "specificKey";
    dispatch_queue_set_specific(self.cQ, key, &key, NULL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CFStringRef value = dispatch_get_specific(key);
        if (value) {
            NSLog(@"--->specific-In");
        }
        else {
            NSLog(@"--->specific-Not");
        }
    });
    dispatch_async(self.cQ, ^{
        CFStringRef value = dispatch_get_specific(key);
        if (value) {
            NSLog(@"--->specific-1-In");
        }
        else {
            NSLog(@"--->specific-1-Not");
        }
    });
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self p_actionClicked:indexPath.row];
}

#pragma mark - Init

- (NSArray<NSString *> *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"dispatch_sync",@"dispatch_async",@"dispatch_after",@"dispatch barriers",@"dispatch_group_t",@"dispatch_apply",@"dispatch_set_target_queue",@"dispatch_suspend",@"dispatch_semaphore_t", @"dispatch_queue_set_specific"];
    }
    return _dataSource;
}

- (dispatch_queue_t)sQ {
    if (!_sQ) {
        _sQ = dispatch_queue_create("com.asGCD.sq", NULL);
    }
    return _sQ;
}

- (dispatch_queue_t)cQ {
    if (!_cQ) {
        _cQ = dispatch_queue_create("com.asGCD.cQ", DISPATCH_QUEUE_CONCURRENT);
    }
    return _cQ;
}
@end
