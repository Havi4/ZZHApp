//
//  EditCellInfoViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/10/8.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "EditCellInfoViewController.h"
#import "EditCellInfoDelegate.h"

@interface EditCellInfoViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UITableView *cellTableView;
@property (nonatomic,strong) NSString *cellString;
@property (nonatomic,strong) NSString *textFiledString;
@property (nonatomic, strong) EditCellInfoDelegate *editDelegate;

@end

@implementation EditCellInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTableViewDataHandle];
    [self createNavWithTitle:nil createMenuItem:^UIView *(int nIndex) {
        if (nIndex == 1)
        {
            _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *i = [UIImage imageNamed:[NSString stringWithFormat:@"btn_back_%d",1]];
            [_backButton setImage:i forState:UIControlStateNormal];
            [_backButton setFrame:CGRectMake(-5, 0, 44, 44)];
            [_backButton addTarget:self action:@selector(backToView:) forControlEvents:UIControlEventTouchUpInside];
            return _backButton;
        }else if (nIndex==0){
            UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
            doneButton.frame = CGRectMake(self.view.frame.size.width-65, 0, 60, 44);
            [doneButton setTitle:@"保存" forState:UIControlStateNormal];
            doneButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [doneButton setTitleColor:1==0?kDefaultColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [doneButton addTarget:self action:@selector(saveDown:) forControlEvents:UIControlEventTouchUpInside];
            return doneButton;
        }
        return nil;
    }];
    [self.view addSubview:self.cellTableView];
}

- (void)addTableViewDataHandle
{
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        [cell configure:cell customObj:self.cellString indexPath:indexPath];
        
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        return 49;
    };
    @weakify(self);
    DidSelectCellBlock didSelectBlock = ^(NSIndexPath *indexPath, id item){
        DeBugLog(@"select cell %ld",(long)indexPath.row);
        @strongify(self);
        [self saveInfo:item];
    };
    self.editDelegate = [[EditCellInfoDelegate alloc]initWithItems:@[self.cellString] cellIdentifier:@"cell" configureCellBlock:configureCellBlock cellHeightBlock:configureCellHeightBlock didSelectBlock:didSelectBlock];
    [self.editDelegate handleTableViewDataSourceAndDelegate:self.cellTableView];
    self.editDelegate.chanageTextFieldBlock = ^(NSString *textValue) {
        @strongify(self);
        self.textFiledString = textValue;
    };
}

- (void)backToView:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveDown:(UIButton *)sender
{
    [self saveInfo:self.textFiledString];
}

- (void)saveInfo:(NSString *)value
{
    NSDictionary *dic = @{
                          @"UserID": kUserID, //关键字，必须传递
                          self.cellString:value,
                          };
    ZZHAPIManager *manager = [ZZHAPIManager sharedAPIManager];
    [manager requestChangeUserInfoParam:dic andBlock:^(BaseModel *resultModel, NSError *error) {
        DeBugLog(@"更新%@",resultModel.errorMessage);
        if (self.saveButtonClicked) {
            self.saveButtonClicked(1);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark setter 

- (UITableView *)cellTableView
{
    if (!_cellTableView) {
        _cellTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
        _cellTableView.backgroundColor = KTableViewBackGroundColor;
    }
    return _cellTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCellInfoType:(NSString *)cellInfoType
{
    self.cellString = cellInfoType;
}


@end
