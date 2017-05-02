//
//  ViewController.m
//  WiFiConnect
//
//  Created by ZhangJingHao2345 on 2017/5/2.
//  Copyright © 2017年 ZhangJingHao2345. All rights reserved.
//

#import "ViewController.h"
#import "WifiViewController.h"
#import "Track.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *nameArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"WiFi"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(clickRightBtn)];
    
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"documentsDir : %@",documentsDir);
}

- (void)clickRightBtn {
    WifiViewController *vc = [WifiViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.nameArr = [Track musicLibraryTracks];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_Id = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_Id];
    }
    
    cell.textLabel.text = self.nameArr[indexPath.row];
    
    return cell;
}

@end
