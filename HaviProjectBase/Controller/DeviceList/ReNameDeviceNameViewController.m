//
//  ReNameDeviceNameViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/4/25.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "ReNameDeviceNameViewController.h"
#import "BetaNaoTextField.h"

@interface ReNameDeviceNameViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BetaNaoTextField *nameTextField;
@property (nonatomic, strong) UITableView *sideTableView;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) SCBarButtonItem *rightBarItem;

@end

@implementation ReNameDeviceNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    self.backgroundImageView.image = [UIImage imageNamed:@""];
    self.view.backgroundColor = KTableViewBackGroundColor;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.title = @"添加设备名称";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
    self.rightBarItem = [[SCBarButtonItem alloc] initWithTitle:@"完成" style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self bindingDeviceWithUUID];
    }];
    self.sc_navigationItem.rightBarButtonItem = self.rightBarItem;
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.00];
    [self.view addSubview:self.sideTableView];
    [self.sideTableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(64);
        make.height.equalTo(@80);
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
    if (self.nameTextField) {
        [self.nameTextField reloadTextFieldWithTextString:self.deviceInfo.nDescription];
    }
    [_nameTextField becomeFirstResponder];
}


- (UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[BetaNaoTextField alloc]init];
        _nameTextField.frame = CGRectMake(16, -10, self.view.frame.size.width-32, 80);
        _nameTextField.textPlaceHolder = @"请输入设备名称";
        _nameTextField.textPlaceHolderColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
        _nameTextField.textLineColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
        [_nameTextField becomeFirstResponder];
        _nameTextField.returnKeyType = UIReturnKeyDone;
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

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//使得tableview顶格
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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
    [cell addSubview:self.nameTextField];
     cell.backgroundColor = [UIColor whiteColor];
     return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)backToHomeView:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark textfeild delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.nameTextField]) {
        [textField setReturnKeyType:UIReturnKeyDone];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.nameTextField]) {
        [textField resignFirstResponder];
    }
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
#pragma mark 提交
- (void)bindingDeviceWithUUID
{
    if (self.nameTextField.text.length == 0) {
        [NSObject showHudTipStr:@"请输入设备名称"];
        return;
    }
    //
    if (self.deviceInfo.friendUserID.length > 0) {
        NSDictionary *para = @{
                               @"FriendUserID": self.deviceInfo.friendUserID,
                               @"UserID":thirdPartyLoginUserId,
                               @"DeviceList":@[
                                       @{
                                           @"UUID":self.deviceInfo.deviceUUID,
                                           @"Description":self.nameTextField.text,
                                           },

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
