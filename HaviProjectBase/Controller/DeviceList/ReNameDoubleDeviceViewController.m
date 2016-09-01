//
//  ReNameDoubleDeviceViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/12/7.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "ReNameDoubleDeviceViewController.h"
#import "BetaNaoTextField.h"

@interface ReNameDoubleDeviceViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BetaNaoTextField *nameTextField;
@property (nonatomic,strong) BetaNaoTextField *txLeftNameView;
@property (nonatomic,strong) BetaNaoTextField *txRightNameView;
@property (nonatomic,strong) UITableView *tbDeviceNameShowView;
@property (nonatomic, strong) UITableView *sideTableView;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) SCBarButtonItem *rightBarItem;

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
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.title = @"添加设备名称";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.00];
    
    self.rightBarItem = [[SCBarButtonItem alloc] initWithTitle:@"完成" style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self bindingDeviceWithUUID:nil];
    }];
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;
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
    NSArray *_arrDeatilListDescription = self.deviceInfo.detailDeviceList;
    NSArray *_sortedDetailDevice = [_arrDeatilListDescription sortedArrayUsingComparator:^NSComparisonResult(DetailDeviceList* _Nonnull obj1, DetailDeviceList* _Nonnull obj2) {
        return [obj1.detailUUID compare:obj2.detailUUID options:NSCaseInsensitiveSearch];
    }];
    if (self.nameTextField) {
        [self.nameTextField reloadTextFieldWithTextString:self.deviceInfo.nDescription];
    }
    if (self.txLeftNameView) {
        DetailDeviceList *model = (DetailDeviceList*)[_sortedDetailDevice  objectAtIndex:0];
        [self.txLeftNameView reloadTextFieldWithTextString:model.detailDescription];
    }
    if (self.txRightNameView) {
        DetailDeviceList *model = (DetailDeviceList*)[_sortedDetailDevice  objectAtIndex:1];
        [self.txRightNameView reloadTextFieldWithTextString:model.detailDescription];
    }
    [_nameTextField becomeFirstResponder];
}


#pragma mark setter meathod

- (UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[BetaNaoTextField alloc]init];
        _nameTextField.frame = CGRectMake(16, -10, self.view.frame.size.width-32, 80);
        _nameTextField.textPlaceHolder = @"请输入设备名称";
        _nameTextField.textPlaceHolderColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
        _nameTextField.textLineColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
        [_nameTextField becomeFirstResponder];
        _nameTextField.returnKeyType = UIReturnKeyNext;
        
    }
    return _nameTextField;
}

- (UITableView *)sideTableView
{
    if (_sideTableView == nil) {
        _sideTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _sideTableView.scrollEnabled = NO;
        _sideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sideTableView.backgroundColor = [UIColor clearColor];
    }
    return _sideTableView;
}


- (UITextField *)txRightNameView
{
    if (!_txRightNameView) {
        _txRightNameView = [[BetaNaoTextField alloc]init];
        _txRightNameView.frame = CGRectMake(16, -10, self.view.frame.size.width-32, 80);
        _txRightNameView.textPlaceHolder = @"请输入右侧设备名称";
        _txRightNameView.textPlaceHolderColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
        _txRightNameView.textLineColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
        _txRightNameView.returnKeyType = UIReturnKeyDone;
        
    }
    return _txRightNameView;
}

- (UITextField *)txLeftNameView
{
    if (!_txLeftNameView) {
        
        _txLeftNameView = [[BetaNaoTextField alloc]init];
        _txLeftNameView.frame = CGRectMake(16, -10, self.view.frame.size.width-32, 80);
        _txLeftNameView.textPlaceHolder = @"请输入左侧设备名称";
        _txLeftNameView.textPlaceHolderColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
        _txLeftNameView.textLineColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
        _txLeftNameView.returnKeyType = UIReturnKeyNext;
        
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
    return 0.01;
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
    
    if (indexPath.section==0) {
        [cell addSubview:self.nameTextField];

    }else if (indexPath.section==1){
        [cell addSubview:self.txLeftNameView];
        
    }else if (indexPath.section==2){
        [cell addSubview:self.txRightNameView];
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section==0) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//        UILabel *lMainNameView = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
//        lMainNameView.font = [UIFont systemFontOfSize:12];
//        lMainNameView.text = @"设备名称";
//        lMainNameView.textColor = [UIColor lightGrayColor];
//        [view addSubview:lMainNameView];
//        return view;
//    }else if (section==1){
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//        UILabel *lMainNameView = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
//        lMainNameView.text = @"左侧床垫名称";
//        lMainNameView.textColor = [UIColor lightGrayColor];
//        lMainNameView.font = [UIFont systemFontOfSize:12];
//        [view addSubview:lMainNameView];
//        return view;
//    }else{
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//        UILabel *lMainNameView = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
//        lMainNameView.textColor = [UIColor lightGrayColor];
//        lMainNameView.font = [UIFont systemFontOfSize:12];
//        lMainNameView.text = @"右侧床垫名称";
//        [view addSubview:lMainNameView];
//        return view;
//    }
//}

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
        [NSObject showHudTipStr:@"请输入设备名称"];
        return;
    }
    if (self.txLeftNameView.text.length == 0) {
        [NSObject showHudTipStr:@"请输入左侧床垫名称"];
        return;
    }
    if (self.txRightNameView.text.length == 0) {
        [NSObject showHudTipStr:@"请输入右侧床垫名称"];
        return;
    }
    NSArray *_arrDeatilListDescription = self.deviceInfo.detailDeviceList;
    NSArray *_sortedDetailDevice = [_arrDeatilListDescription sortedArrayUsingComparator:^NSComparisonResult(DetailDeviceList* _Nonnull obj1, DetailDeviceList* _Nonnull obj2) {
        return [obj1.detailUUID compare:obj2.detailUUID options:NSCaseInsensitiveSearch];
    }];
    if (self.deviceInfo.friendUserID.length > 0) {
        NSDictionary *para = @{
                               @"FriendUserID": self.deviceInfo.friendUserID,
                               @"UserID":thirdPartyLoginUserId,
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
            [[NSNotificationCenter defaultCenter]postNotificationName:kUserChangeUUIDInCenterView object:nil];
        }];        
    }else{
        NSDictionary *para = @{
                               @"UserID":thirdPartyLoginUserId,
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
            [[NSNotificationCenter defaultCenter]postNotificationName:kUserChangeUUIDInCenterView object:nil];
        }];
    }
}

@end
