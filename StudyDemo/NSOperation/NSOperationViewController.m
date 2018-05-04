//
//  NSOperationViewController.m
//  StudyDemo
//
//  Created by Andrew Shen on 2018/4/28.
//  Copyright © 2018年 小小厨师的厨房. All rights reserved.
//

#import "NSOperationViewController.h"
#import "CustomOperation.h"


@interface NSOperationViewController ()
@property (nonatomic, copy)  NSArray<NSString *>  *dataSource; // <##>

@end

@implementation NSOperationViewController

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
- (void)p_invocation {
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(p_task1) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(p_task1) object:nil];
    [op1 start];

    [op2 start];
}

- (void)p_task1 {
    sleep(1);
    NSLog(@"--->task1-Thread:%@",[NSThread currentThread]);
}
- (void)p_task2 {
    sleep(1);
    NSLog(@"--->task2-Queue-Thread:%@",[NSThread currentThread]);
}
- (void)p_blockOp {
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        sleep(2);
        NSLog(@"--->blockOp1-Thread:%@",[NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"--->blockOp2-Thread:%@",[NSThread currentThread]);

    }];
    [op addExecutionBlock:^{
        NSLog(@"--->blockOp3-Thread:%@",[NSThread currentThread]);

    }];
    [op start];

}

- (void)p_customOp {
    CustomOperation *op = [[CustomOperation alloc] init];
    [op start];
    
    ConcurrentOperation *cOp = [[ConcurrentOperation alloc] init];
    [cOp start];
    

}

- (void)p_operationQueue {
    NSOperationQueue *customQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(p_task1) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(p_task2) object:nil];

    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        sleep(1);
        NSLog(@"--->OpQueue1-Thread:%@",[NSThread currentThread]);
    }];
    [op3 addExecutionBlock:^{
        sleep(1);
        NSLog(@"--->OpQueue2-Thread:%@",[NSThread currentThread]);
    }];
    [op3 addExecutionBlock:^{
        sleep(1);
        NSLog(@"--->OpQueue3-Thread:%@",[NSThread currentThread]);
    }];
    [customQueue addOperation:op3];
    [customQueue addOperation:op1];
    [customQueue addOperation:op2];

    [customQueue addOperationWithBlock:^{
        sleep(1);
        NSLog(@"--->BlockOpQueue1-Thread:%@",[NSThread currentThread]);
    }];
    [customQueue addOperationWithBlock:^{
        sleep(1);
        NSLog(@"--->BlockOpQueue2-Thread:%@",[NSThread currentThread]);
    }];
    [customQueue addOperationWithBlock:^{
        sleep(1);
        NSLog(@"--->BlockOpQueue3-Thread:%@",[NSThread currentThread]);
    }];
}

- (void)p_operationDependency {
    NSLog(@"--->------------------Dependency");
    NSOperationQueue *customQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(p_task1) object:nil];
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(p_task2) object:nil];

    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        sleep(1);
        NSLog(@"--->DependencyOp2-1-Thread:%@",[NSThread currentThread]);
    }];
    [op2 addExecutionBlock:^{
        sleep(1);
        NSLog(@"--->DependencyOp2-2-Thread:%@",[NSThread currentThread]);
    }];
    [op2 addExecutionBlock:^{
        sleep(1);
        NSLog(@"--->DependencyOp2-3-Thread:%@",[NSThread currentThread]);
    }];
    op3.queuePriority = NSOperationQueuePriorityHigh;
    op2.queuePriority = NSOperationQueuePriorityVeryHigh;
//    [op2 addDependency:op3];

    [customQueue addOperation:op1];
    [customQueue addOperation:op3];
    [customQueue addOperation:op2];

    [customQueue addOperationWithBlock:^{
        sleep(1);
        NSLog(@"--->DependencyOp3-Thread:%@",[NSThread currentThread]);
    }];
}

- (void)p_threadCommunication {
    NSOperationQueue *opQ = [[NSOperationQueue alloc] init];
    [opQ addOperationWithBlock:^{
        sleep(1);
        NSLog(@"--->1-Thread:%@",[NSThread currentThread]);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"--->2-Thread:%@",[NSThread currentThread]);
        }];
    }];
    
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
    switch (indexPath.row) {
        case 0:
            [self p_invocation];
            break;
        case 1:
            [self p_blockOp];
            break;
        case 2:
            [self p_customOp];
            break;
        case 3:
            [self p_operationQueue];
            break;
        case 4:
            [self p_operationDependency];
            break;
        case 5:
            [self p_threadCommunication];
            break;
        default:
            break;
    }
}

#pragma mark - Init

- (NSArray<NSString *> *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"invocationOp",@"blockOp",@"customOp",@"operationQueue",@"operationDependency",@"thread communication"];
    }
    return _dataSource;
}

@end
