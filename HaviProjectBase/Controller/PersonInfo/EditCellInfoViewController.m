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
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) SCBarButtonItem *rightBarItem;

@end

@implementation EditCellInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTableViewDataHandle];
    self.textFiledString = self.cellTextString;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.title = @"编辑资料";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.rightBarItem = [[SCBarButtonItem alloc] initWithTitle:@"完成" style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self saveDown:nil];
    }];
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;


//    [self createNavWithTitle:nil createMenuItem:^UIView *(int nIndex) {
//        if (nIndex == 1)
//        {
//            _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [_backButton dk_setImage:DKImageWithNames(@"btn_back_0", @"btn_back_1") forState:UIControlStateNormal];
//            [_backButton setFrame:CGRectMake(-5, 0, 44, 44)];
//            [_backButton addTarget:self action:@selector(backToView:) forControlEvents:UIControlEventTouchUpInside];
//            return _backButton;
//        }else if (nIndex==0){
//            UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            doneButton.frame = CGRectMake(self.view.frame.size.width-65, 0, 60, 44);
//            [doneButton setTitle:@"保存" forState:UIControlStateNormal];
//            doneButton.titleLabel.font = kTextNormalWordFont;
//            [doneButton dk_setTitleColorPicker:kTextColorPicker forState:UIControlStateNormal];
//            [doneButton addTarget:self action:@selector(saveDown:) forControlEvents:UIControlEventTouchUpInside];
//            return doneButton;
//        }
//        return nil;
//    }];
    [self.view addSubview:self.cellTableView];
}



- (void)addTableViewDataHandle
{
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        [cell configure:cell customObj:self.cellString indexPath:indexPath withOtherInfo:self.cellTextString];
        
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        return 80;
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
    
    if ([self.cellString isEqual:@"UserName"]||[self.cellString isEqual:@"EmergencyContact"]) {
        if (![self checkIsValiadForString:self.textFiledString]) {
            [NSObject showHudTipStr:@"姓名只能由2-8位数字、字母、中文组成"];
            return;
        }
    }else{
        if (![self checkIsValiadForNum:self.textFiledString]) {
            [NSObject showHudTipStr:@"请输入有效的联系方式"];
            return;
        }
    }
    [self saveInfo:self.textFiledString];
}

- (void)saveInfo:(NSString *)value
{
    if (value.length == 0) {
        [NSObject showHudTipStr:@"保存内容不能为空"];
        return;
    }
    NSDictionary *dic = @{
                          @"UserID": thirdPartyLoginUserId, //关键字，必须传递
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
        _cellTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (BOOL)checkIsValiadForString:(NSString *)checkString
{
    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5]{2,6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([pred evaluateWithObject:checkString]) {
        
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)checkIsValiadForNum:(NSString *)checkString
{
//    NSString *regex = @"1[0-9]{10}";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    if (checkString.length > 11) {
        
        return NO;
    }else{
        return YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cellEdit" object:nil];
}

@end
