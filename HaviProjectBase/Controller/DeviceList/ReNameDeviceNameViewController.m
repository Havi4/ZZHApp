//
//  ReNameDeviceNameViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/4/25.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "ReNameDeviceNameViewController.h"

@interface ReNameDeviceNameViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITableView *sideTableView;

@end

@implementation ReNameDeviceNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KTableViewBackGroundColor;
    [self createNavWithTitle:@"重命名设备" createMenuItem:^UIView *(int nIndex)
     {
         if (nIndex == 1)
         {
             [self.leftButton addTarget:self action:@selector(backToHomeView:) forControlEvents:UIControlEventTouchUpInside];
             return self.leftButton;
         }else if (nIndex == 0){
             self.rightButton.frame = CGRectMake(self.view.frame.size.width-60, 0, 60, 44);
             [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
             [self.rightButton setTitleColor:selectedThemeIndex==0? kDefaultColor :[UIColor whiteColor] forState:UIControlStateNormal];
             [self.rightButton addTarget:self action:@selector(bindingDeviceWithUUID) forControlEvents:UIControlEventTouchUpInside];
             return self.rightButton;
         }
         return nil;
     }];
    
    self.sideTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.sideTableView];
    [self.sideTableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(64);
        make.height.equalTo(@49);
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


- (UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc]init];
        _nameTextField.frame = CGRectMake(15, 0, self.view.frame.size.width-30, 49);
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.placeholder = @"设备名称";
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
    self.nameTextField.text = self.deviceInfo.nDescription;
     cell.backgroundColor = [UIColor whiteColor];
     return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
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
        [self.view makeToast:@"请输入设备名称" duration:2 position:@"center"];
        return;
    }
    //
    if (self.deviceInfo.friendUserID.length > 0) {
        NSDictionary *para = @{
                               @"FriendUserID": self.deviceInfo.friendUserID,
                               @"UserID":kUserID,
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

        }];
    }else{
        NSDictionary *para = @{
                               @"UserID":kUserID,
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
        }];
    }
}

@end
