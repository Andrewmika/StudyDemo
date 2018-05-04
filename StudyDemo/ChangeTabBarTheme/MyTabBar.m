//
//  MyTabBar.m
//  StudyDemo
//
//  Created by Andrew Shen on 12/03/2018.
//  Copyright © 2018 小小厨师的厨房. All rights reserved.
//

#import "MyTabBar.h"

@interface MyTabBar ()
@property (nonatomic, strong)  UIButton  *midItem; // <##>
@property (nonatomic, assign)  CGFloat  midItemWidth; // <##>
@property (nonatomic, copy)  NSString  *url; // <##>
@property (nonatomic, copy)  void (^midClickedBlock)(void); // <##>
@end

@implementation MyTabBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.midItem];
    }
    return self;
}

- (void)configMidItemWidth:(CGFloat)width imgURLString:(NSString *)url clickedCompletion:(void (^)(void))completion {
    _midClickedBlock = completion;
    self.midItemWidth = width;
    self.url = url;
    self.midItem.frame = CGRectMake(0, 0, self.midItemWidth, self.midItemWidth);
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _midItem.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5 - 10);
    if (self.items.count > 0) {
        CGFloat itemWidth = (self.frame.size.width - self.midItemWidth) / self.items.count;
        NSMutableArray<UIView *> *tabBarButtonArray = [NSMutableArray array];
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [tabBarButtonArray addObject:view];
            }
        }
        NSInteger midIndex = self.items.count / 2;
        [tabBarButtonArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect frame = obj.frame;
            if (idx < midIndex) {
                obj.frame = CGRectMake(idx * itemWidth, frame.origin.y, itemWidth, frame.size.height);
            }
            else {
                obj.frame = CGRectMake(idx * itemWidth + self.midItemWidth, frame.origin.y, itemWidth, frame.size.height);
            }
        }];
        
    }
}

- (void)p_midItemAction {
    if (self.midClickedBlock) {
        self.midClickedBlock();
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.clipsToBounds || self.hidden || (self.alpha == 0.f)) {
        return nil;
    }
    UIView *view = [super hitTest:point withEvent:event];
    if (view) {
        return view;
    }
    for (UIView *subView in self.subviews.reverseObjectEnumerator) {
        CGPoint subPoint = [subView convertPoint:point fromView:self];
        view = [subView hitTest:subPoint withEvent:event];
        if (view) {
            return  view;
        }
    }
    return nil;
}
- (UIButton *)midItem {
    if (!_midItem) {
        _midItem = [UIButton buttonWithType:UIButtonTypeSystem];
        [_midItem addTarget:self action:@selector(p_midItemAction) forControlEvents:UIControlEventTouchUpInside];
        _midItem.frame = CGRectMake(0, 0, self.midItemWidth, self.midItemWidth);
        [_midItem setBackgroundImage:[[UIImage imageNamed:@"mid_tab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_midItem setBackgroundImage:[[UIImage imageNamed:@"mid_tab"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    }
    return _midItem;
}

@end
