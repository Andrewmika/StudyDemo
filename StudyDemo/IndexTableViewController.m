//
//  IndexTableViewController.m
//  StudyDemo
//
//  Created by Andrew Shen on 26/02/2018.
//  Copyright © 2018 小小厨师的厨房. All rights reserved.
//

#import "IndexTableViewController.h"

@interface IndexTableViewController ()
@property (nonatomic, copy)  NSArray<NSString *>  *dataSource; // <##>
@end

@implementation IndexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IndexCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *VC;
    Class class = NSClassFromString([NSString stringWithFormat:@"%@ViewController",self.dataSource[indexPath.row]]);
    VC = [[class alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Interface Method

#pragma mark - Private Method

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Override

#pragma mark - InitView

#pragma mark - Init

- (NSArray<NSString *> *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"RAC",@"Runtime",@"TabBarThemeChange",@"ResponderChain",@"GCD",@"NSOperation"];
    }
    return _dataSource;
}
@end
