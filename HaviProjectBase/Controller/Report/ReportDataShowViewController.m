//
//  ReportDataShowViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ReportDataShowViewController.h"
#import "ReportDataDelegate.h"

@interface ReportDataShowViewController ()

@property (nonatomic, strong) UITableView *reportShowTableView;
@property (nonatomic, strong) ReportDataDelegate *reportDelegate;

@end

@implementation ReportDataShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTableViewDataHandle];
}

- (void)addTableViewDataHandle
{
    [self.view addSubview:self.reportShowTableView];
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        return 60;
    };
    
    DidSelectCellBlock didSelectBlock = ^(NSIndexPath *indexPath, id item){
    };
    self.reportDelegate = [[ReportDataDelegate alloc]initWithItems:nil cellIdentifier:@"cell" configureCellBlock:configureCellBlock cellHeightBlock:configureCellHeightBlock didSelectBlock:didSelectBlock];
    [self.reportDelegate handleTableViewDataSourceAndDelegate:self.reportShowTableView withReportType:self.reportType];
}

- (UITableView *)reportShowTableView
{
    if (!_reportShowTableView) {
        _reportShowTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -64) style:UITableViewStylePlain];
        _reportShowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _reportShowTableView.backgroundColor = [UIColor clearColor];
    }
    return _reportShowTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
