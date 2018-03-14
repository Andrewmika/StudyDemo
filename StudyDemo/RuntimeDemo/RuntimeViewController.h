//
//  RuntimeViewController.h
//  StudyDemo
//
//  Created by Andrew Shen on 26/02/2018.
//  Copyright © 2018 小小厨师的厨房. All rights reserved.
//  runtime

#import <UIKit/UIKit.h>

@interface RuntimeViewController : UITableViewController
{
    NSString *_privateProperty1;
    NSString *privateProperty2;
}

@property (nonatomic, copy)  NSString  *interfaceProperty; // <##>

- (void)interfaceMethod;

@end
