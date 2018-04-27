//
//  ResponderChainViewController.m
//  StudyDemo
//
//  Created by Andrew Shen on 2018/4/4.
//  Copyright © 2018年 小小厨师的厨房. All rights reserved.
//

#import "ResponderChainViewController.h"

@interface ResponderChainViewController ()

@end

@implementation ResponderChainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Interface Method

#pragma mark - Private Method

- (void)p_logResponder:(UIResponder *)responder {
    NSLog(@"--->responder:%@",responder);
    UIResponder *nextResponder = [responder nextResponder];
    if (nextResponder) {
        [self p_logResponder:nextResponder];
    }
}
#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Override

#pragma mark - InitView

#pragma mark - Init



@end
