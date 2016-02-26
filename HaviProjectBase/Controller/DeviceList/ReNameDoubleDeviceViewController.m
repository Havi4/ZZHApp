//
//  ReNameDoubleDeviceViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/12/7.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "ReNameDoubleDeviceViewController.h"

@interface ReNameDoubleDeviceViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *txLeftNameView;
@property (nonatomic,strong) UITextField *txRightNameView;
@property (nonatomic,strong) UITableView *tbDeviceNameShowView;
@property (nonatomic, strong) UITableView *sideTableView;

@end

@implementation ReNameDoubleDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initControllerView];
    
}

- (void)initControllerView
{
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavWithTitle:@"重命名设备" createMenuItem:^UIView *(int nIndex)
     {
         if (nIndex == 1)
         {
             [self.leftButton addTarget:self action:@selector(backToHomeView:) forControlEvents:UIControlEventTouchUpInside];
             return self.leftButton;
         }else if (nIndex == 0){
             self.rightButton.frame = CGRectMake(self.view.frame.size.width-60, 0, 60, 44);
             [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
             [self.rightButton setTitleColor:selectedThemeIndex==0?kDefaultColor:[UIColor whiteColor] forState:UIControlStateNormal];
             [self.rightButton addTarget:self action:@selector(bindingDeviceWithUUID:) forControlEvents:UIControlEventTouchUpInside];
             return self.rightButton;
         }
         return nil;
     }];
    //
    self.sideTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.sideTableView];
    [self.sideTableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(64);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
    self.sideTableView.backgroundColor = KTableViewBackGroundColor;
    self.sideTableView.delegate = self;
    self.sideTableView.dataSource = self;
    [_nameTextField becomeFirstResponder];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_nameTextField becomeFirstResponder];
}


#pragma mark setter meathod

- (UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc]init];
        _nameTextField.frame = CGRectMake(15, 0, self.view.frame.size.width-30, 49);
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.placeholder = @"设备名称";
        _nameTextField.textColor = [UIColor grayColor];
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.delegate = self;
        
    }
    return _nameTextField;
}

- (UITableView *)sideTableView
{
    if (_sideTableView == nil) {
        _sideTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    return _sideTableView;
}


- (UITextField *)txRightNameView
{
    if (!_txRightNameView) {
        _txRightNameView = [[UITextField alloc]init];
        _txRightNameView.frame = CGRectMake(15, 0, self.view.frame.size.width-30, 49);
        _txRightNameView.borderStyle = UITextBorderStyleNone;
        _txRightNameView.placeholder = @"Right";
        _txRightNameView.textColor = [UIColor grayColor];
        _txRightNameView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txRightNameView.delegate = self;
        
    }
    return _txRightNameView;
}

- (UITextField *)txLeftNameView
{
    if (!_txLeftNameView) {
        _txLeftNameView = [[UITextField alloc]init];
        _txLeftNameView.frame = CGRectMake(15, 0, self.view.frame.size.width-30, 49);
        _txLeftNameView.borderStyle = UITextBorderStyleNone;
        _txLeftNameView.placeholder = @"Left";
        _txLeftNameView.textColor = [UIColor grayColor];
        _txLeftNameView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txLeftNameView.delegate = self;
        
    }
    return _txLeftNameView;
}

#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//使得tableview顶格
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellIndentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *_arrDeatilListDescription = self.deviceInfo.detailDeviceList;
    NSArray *_sortedDetailDevice = [_arrDeatilListDescription sortedArrayUsingComparator:^NSComparisonResult(DetailDeviceList* _Nonnull obj1, DetailDeviceList* _Nonnull obj2) {
        return [obj1.detailUUID compare:obj2.detailUUID options:NSCaseInsensitiveSearch];
    }];
    if (indexPath.section==0) {
        [cell addSubview:self.nameTextField];
        self.nameTextField.text = [NSString stringWithFormat:@"%@",self.deviceInfo.nDescription];

    }else if (indexPath.section==1){
        [cell addSubview:self.txLeftNameView];
        DetailDeviceList *model = (DetailDeviceList*)[_sortedDetailDevice  objectAtIndex:0];
        self.txLeftNameView.text = [NSString stringWithFormat:@"%@",model.detailDescription];
    }else if (indexPath.section==2){
        [cell addSubview:self.txRightNameView];
        DetailDeviceList *model = (DetailDeviceList*)[_sortedDetailDevice  objectAtIndex:1];
        self.txLeftNameView.text = [NSString stringWithFormat:@"%@",model.detailDescription];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        UILabel *lMainNameView = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
        lMainNameView.font = [UIFont systemFontOfSize:12];
        lMainNameView.text = @"设备名称";
        lMainNameView.textColor = [UIColor lightGrayColor];
        [view addSubview:lMainNameView];
        return view;
    }else if (section==1){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        UILabel *lMainNameView = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
        lMainNameView.text = @"左侧床垫名称";
        lMainNameView.textColor = [UIColor lightGrayColor];
        lMainNameView.font = [UIFont systemFontOfSize:12];
        [view addSubview:lMainNameView];
        return view;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        UILabel *lMainNameView = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
        lMainNameView.textColor = [UIColor lightGrayColor];
        lMainNameView.font = [UIFont systemFontOfSize:12];
        lMainNameView.text = @"右侧床垫名称";
        [view addSubview:lMainNameView];
        return view;
    }
}

- (void)backToHomeView:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark textfeild delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField setReturnKeyType:UIReturnKeyDone];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark 提交
- (void)bindingDeviceWithUUID:(UIButton *)button
{
    
    if (self.nameTextField.text.length == 0) {
        [self.view makeToast:@"请输入设备名称" duration:2 position:@"center"];
        return;
    }
    if (self.txLeftNameView.text.length == 0) {
        [self.view makeToast:@"请输入左侧床垫名称" duration:2 position:@"center"];
        return;
    }
    if (self.txRightNameView.text.length == 0) {
        [self.view makeToast:@"请输入右侧床垫名称" duration:2 position:@"center"];
        return;
    }
    NSArray *_arrDeatilListDescription = self.deviceInfo.detailDeviceList;
    NSArray *_sortedDetailDevice = [_arrDeatilListDescription sortedArrayUsingComparator:^NSComparisonResult(DetailDeviceList* _Nonnull obj1, DetailDeviceList* _Nonnull obj2) {
        return [obj1.detailUUID compare:obj2.detailUUID options:NSCaseInsensitiveSearch];
    }];
    if (self.deviceInfo.friendUserID.length > 0) {
        NSDictionary *para = @{
                               @"FriendUserID": self.deviceInfo.friendUserID,
                               @"UserID":kUserID,
                               @"DeviceList":@[
                                       @{
                                           @"UUID":self.deviceInfo.deviceUUID,
                                           @"Description":self.nameTextField.text,
                                           },
                                       @{
                                           @"UUID":((DetailDeviceList *)[_sortedDetailDevice objectAtIndex:0]).detailUUID,
                                           @"Description":self.txLeftNameView.text,
                                           },
                                       @{
                                           @"UUID":((DetailDeviceList *)[_sortedDetailDevice objectAtIndex:1]).detailUUID,
                                           @"Description":self.txRightNameView.text,
                                           }
                                       ]
                               };
        ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
        [client requestRenameFriendDeviceParams:para andBlock:^(BaseModel *resultModel, NSError *error) {
            [self backToHomeView:nil];
        }];        
    }else{
        NSDictionary *para = @{
                               @"UserID":kUserID,
                               @"DeviceList":@[
                                       @{
                                           @"UUID":self.deviceInfo.deviceUUID,
                                           @"Description":self.nameTextField.text,
                                           },
                                       @{
                                           @"UUID":((DetailDeviceList *)[_sortedDetailDevice objectAtIndex:0]).detailUUID,
                                           @"Description":self.txLeftNameView.text,
                                           },
                                       @{
                                           @"UUID":((DetailDeviceList *)[_sortedDetailDevice objectAtIndex:1]).detailUUID,
                                           @"Description":self.txRightNameView.text,
                                           }
                                       ]
                               };
        ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
        [client requestRenameMyDeviceParams:para andBlock:^(BaseModel *resultModel, NSError *error) {
            [self backToHomeView:nil];
        }];
    }
}

@end
