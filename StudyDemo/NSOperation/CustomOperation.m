//
//  CustomOperation.m
//  StudyDemo
//
//  Created by Andrew Shen on 2018/5/3.
//  Copyright © 2018年 小小厨师的厨房. All rights reserved.
//

#import "CustomOperation.h"

@implementation CustomOperation

- (void)main {
    if (!self.cancelled) {
        NSLog(@"--->customMainOp-Thread:%@",[NSThread currentThread]);
    }
}

@end

@implementation ConcurrentOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isAsynchronous {
    return YES;
}

- (void)start {
    if (self.cancelled) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self willChangeValueForKey:@"isFinished"];
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    _executing = YES;
    [self willChangeValueForKey:@"isExecuting"];
}

- (void)main {
    NSLog(@"--->concurrentOp-Thread:%@",[NSThread currentThread]);
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self willChangeValueForKey:@"isFinished"];
    _finished  = YES;
    [self didChangeValueForKey:@"isFinished"];
}
@end

