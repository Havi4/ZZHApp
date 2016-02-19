//
//  ViewController.m
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tbListView;
@property (strong, nonatomic) NSMutableArray *mArrCellTitiles;
@property (strong, nonatomic) NSMutableArray *mArrCellClassName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initControllerData];
    [self.view addSubview:self.tbListView];
}

#pragma mark init controller data

- (void)initControllerData
{
    self.title = @"JSON转换案例";
    self.mArrCellTitiles = @[].mutableCopy;
    self.mArrCellClassName = @[].mutableCopy;
    [self addCellTitle:@"简单的json转换" andCellClassName:@"JsonOneViewController"];
    [self addCellTitle:@"嵌套json转换" andCellClassName:@"NestModeViewController"];
}

#pragma mark setter meathod

- (UITableView *)tbListView
{
    if (!_tbListView) {
        _tbListView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tbListView.delegate = self;
        _tbListView.dataSource = self;
    }
    return _tbListView;
}

#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mArrCellTitiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _mArrCellTitiles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *_strClassName = _mArrCellClassName[indexPath.row];
    Class _classString = NSClassFromString(_strClassName);
    if (_classString) {
        UIViewController *_ctController = _classString.new;
        [self.navigationController pushViewController:_ctController animated:YES];
    }
}

#pragma mark controller privated meathod

- (void)addCellTitle:(NSString *)cellTitle andCellClassName:(NSString *)className
{
    [_mArrCellTitiles addObject:cellTitle];
    [_mArrCellClassName addObject:className];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
