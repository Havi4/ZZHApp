//
//  EditTableViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/7/25.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "EditAddressTableViewController.h"
#import "BetaNaoTextField.h"

@interface EditAddressTableViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UITableView *cellTableView;
@property (nonatomic,strong) BetaNaoTextField *cellTextField;
@property (nonatomic,strong) UILabel *cellFooterView;
@property (nonatomic,strong) NSString *cellString;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) SCBarButtonItem *rightBarItem;
@end

@implementation EditAddressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.00];
    // Uncomment the following line to preserve selection between presentations.
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.title = @"编辑地址";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.rightBarItem = [[SCBarButtonItem alloc] initWithTitle:@"完成" style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self saveInfo:nil];
    }];
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;
    [self.view addSubview:self.cellTableView];
}
- (void)backToView:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveInfo:(UIButton *)sender
{
    if (self.cellTextField.text.length==0) {
        [NSObject showHudTipStr:@"请输入地址信息"];
        return;
    }
    
    if (![self checkIsValiadForString:self.cellTextField.text]) {
        [NSObject showHudTipStr:@"地址只能由2-40个中文字符组成"];
        return;
    }
    [self saveUserInfoWithKey:self.cellString andData:self.cellTextField.text];
}

#pragma mark 更新信息
- (void)saveUserInfoWithKey:(NSString *)key andData:(NSString *)data
{
    
    [[UIApplication sharedApplication]incrementNetworkActivityCount];
    //
    NSDictionary *dic = @{
                          @"UserID": thirdPartyLoginUserId, //关键字，必须传递
                          key:data,
                          };
    ZZHAPIManager *manager = [ZZHAPIManager sharedAPIManager];
    [manager requestChangeUserInfoParam:dic andBlock:^(BaseModel *resultModel, NSError *error) {
        DeBugLog(@"更新%@",resultModel.errorMessage);
        if (self.saveButtonClicked) {
            self.saveButtonClicked(1);
        }
        [[UIApplication sharedApplication]decrementNetworkActivityCount];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark setter

- (UITableView *)cellTableView
{
    if (!_cellTableView) {
        _cellTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64 , self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
        _cellTableView.delegate = self;
        _cellTableView.dataSource = self;
        _cellTableView.scrollEnabled = NO;
        _cellTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cellTableView.backgroundColor = [UIColor clearColor];
    }
    return _cellTableView;
}

- (BetaNaoTextField *)cellTextField
{
    if (!_cellTextField) {
        _cellTextField = [[BetaNaoTextField alloc]init];
        _cellTextField.frame = CGRectMake(16, -10, self.view.frame.size.width-32, 80);
        _cellTextField.textPlaceHolder = @"请输入您的家庭地址";
        _cellTextField.textPlaceHolderColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
        _cellTextField.textLineColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
        _cellTextField.font = kDefaultWordFont;
        [_cellTextField becomeFirstResponder];
        _cellTextField.returnKeyType = UIReturnKeyDone;
//        [_cellTextField becomeFirstResponder];
//        _cellTextField.scrollEnabled = NO;
//        _cellTextField.delegate = self;
//        _cellTextField.alpha = 0.9;
//        _cellTextField.returnKeyType = UIReturnKeyDone;
        
    }
    return _cellTextField;
}

- (UILabel *)cellFooterView
{
    if (!_cellFooterView) {
        _cellFooterView = [[UILabel alloc]init];
        _cellFooterView.text = @"";
        _cellFooterView.frame = CGRectMake(15, 0, self.view.frame.size.width-30, 30);
        _cellFooterView.font = [UIFont systemFontOfSize:11];
        _cellFooterView.alpha = 0.4;
    }
    return _cellFooterView;
}

#pragma mark tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInterfier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInterfier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInterfier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:self.cellTextField];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [backView addSubview:self.cellFooterView];
    return backView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCellInfoType:(NSString *)cellInfoType
{
    self.cellString = cellInfoType;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.cellFooterView.text = @"2-40个字符,可由中文、英文、数字组成";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_cellTextField becomeFirstResponder];
    [self.cellTextField reloadTextFieldWithTextString:self.cellInfoString];

}

#pragma mark uitextfield

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        if ([self checkIsValiadForString:textView.text]) {
            [self saveInfo:nil];
        }else{
            [NSObject showHudTipStr:@"超出地址字数范围"];
        }
        return NO;
    }else{
        NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSInteger res = 40-[new length];
        if(res >= 0){
            return YES;
        }
        else{
            NSRange rg = {0,[text length]+res};
            if (rg.length>0) {
                NSString *s = [text substringWithRange:rg];
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            }
            [NSObject showHudTipStr:@"超出地址字数范围"];
            return NO;
        }
    }
}

- (BOOL)checkIsValiadForString:(NSString *)checkString
{
    NSString *regex = @"[A-Za-z0-9\u4e00-\u9fa5]{2,40}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([pred evaluateWithObject:checkString]) {
        
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - Table view data source


@end
