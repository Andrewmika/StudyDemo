//
//  TabBarThemeChangeViewController.m
//  StudyDemo
//
//  Created by Andrew Shen on 08/03/2018.
//  Copyright © 2018 小小厨师的厨房. All rights reserved.
//

#import "TabBarThemeChangeViewController.h"
#import "ChangeThemeViewController.h"
#import "MyTabBar.h"
@interface TabBarThemeChangeViewController ()
@end

@implementation TabBarThemeChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self p_configViews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MyTabBar *tabbar = (MyTabBar *)self.tabBar;
        [tabbar configMidItemWidth:45 imgURLString:@"imgURL" clickedCompletion:^{
            NSLog(@"--->clicked");
        }];
    });
    [self.tabBar becomeFirstResponder];
}

#pragma mark - Interface Method

#pragma mark - Private Method

- (UIImage *)at_imageScaleFromImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 设置界面约束
- (void)p_configViews {
    UIImage *bgImage = [UIImage imageNamed:@"BottomBackground"];
    MyTabBar *tb = [MyTabBar new];
    [tb setBackgroundImage:[self at_imageScaleFromImage:bgImage toSize:CGSizeMake(375, 49)]];

    [self setValue:tb forKey:@"tabBar"];

    NSArray<NSString *> *normalImgNameArray = @[@"Home_NoSelected",@"Financia_NoSelected",@"Find_NoSelected",@"My_NoSelected"];
    NSArray<NSString *> *selectedImgNameArray = @[@"Home_Selected",@"Financia_Selected",@"Find_Selected",@"My_Selected"];
    NSArray<NSString *> *titleArray = @[@"首页",@"理财",@"发现",@"我的"];
    NSMutableArray *VCArray = [NSMutableArray arrayWithCapacity:4];
    [normalImgNameArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *normalTemp = [UIImage imageNamed:obj];
        UIImage *selectedTemp = [UIImage imageNamed:selectedImgNameArray[idx]];
        UIImage *normal = [[self at_imageScaleFromImage:normalTemp toSize:CGSizeMake(35, 35)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selected = [[self at_imageScaleFromImage:selectedTemp toSize:CGSizeMake(35, 35)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ChangeThemeViewController *VC = [ChangeThemeViewController new];
    VC.view.backgroundColor = [UIColor colorWithHue:idx * 60 / 360.0 saturation:1 brightness:1 alpha:1];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titleArray[idx] image:normal selectedImage:selected];
    VC.tabBarItem = item;
    [VCArray addObject:VC];
    }];
    self.viewControllers = VCArray;
    [self setSelectedIndex:0];
    

}

#pragma mark - Event Response

     
#pragma mark - Delegate

#pragma mark - Override


#pragma mark - InitView

#pragma mark - Init



@end
