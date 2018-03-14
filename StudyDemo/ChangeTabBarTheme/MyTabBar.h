//
//  MyTabBar.h
//  StudyDemo
//
//  Created by Andrew Shen on 12/03/2018.
//  Copyright © 2018 小小厨师的厨房. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTabBar : UITabBar

- (void)configMidItemWidth:(CGFloat)width URLString:(NSString *)url clickedCompletion:(void(^)(void))completion;
@end
