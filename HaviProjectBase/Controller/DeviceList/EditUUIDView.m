//
//  EditUUIDView.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/19.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "EditUUIDView.h"

@interface EditUUIDView ()<UITextFieldDelegate>
{
    UITextField *_barCodeTextField;
    UILabel *_barCodeTitle;
    UILabel *_barCodeDescription;
    UIButton *_bindDeviceButton;
    UIButton *_backToScanButton;
}

@end

@implementation EditUUIDView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code.
        [self initSubView];
        self.backgroundColor = [UIColor colorWithRed:0.188f green:0.184f blue:0.239f alpha:1.00f];
    }
    return self;
}

- (void)willMoveToWindow:(nullable UIWindow *)newWindow
{
    [self addConstraintsToViews];
}

- (void)initSubView
{
    _barCodeTitle = [[UILabel alloc]init];
    _barCodeTitle.text = @"手动输入设备序列号";
    _barCodeTitle.textColor = [UIColor whiteColor];
    _barCodeTitle.font = [UIFont boldSystemFontOfSize:20];
    _barCodeTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_barCodeTitle];
    
    _barCodeDescription = [[UILabel alloc]init];
    _barCodeDescription.text = @"请在下方的输入框内输入设备上面的序列号";
    _barCodeDescription.numberOfLines = 0;
    _barCodeDescription.textColor = [UIColor whiteColor];
    _barCodeDescription.font = kDefaultWordFont;
    _barCodeDescription.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_barCodeDescription];
    
    _barCodeTextField = [[UITextField alloc]init];
    _barCodeTextField.borderStyle = UITextBorderStyleNone;
    _barCodeTextField.background = [UIImage imageNamed:[NSString stringWithFormat:@"textbox_hollow_%d",selectedThemeIndex]];
    _barCodeTextField.backgroundColor = [UIColor clearColor];
    _barCodeTextField.layer.cornerRadius = 0;
    NSDictionary *boldFont = @{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:kDefaultWordFont};
    NSAttributedString *attrValue = [[NSAttributedString alloc] initWithString:@"845********67" attributes:boldFont];
    _barCodeTextField.attributedPlaceholder = attrValue;
    _barCodeTextField.textColor = [UIColor whiteColor];
    _barCodeTextField.textAlignment = NSTextAlignmentCenter;
    _barCodeTextField.returnKeyType = UIReturnKeyDone;
    _barCodeTextField.delegate = self;
    [self addSubview:_barCodeTextField];
    
    _bindDeviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bindDeviceButton setTitle:@"绑定该设备" forState:UIControlStateNormal];
    [_bindDeviceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bindDeviceButton addTarget:self action:@selector(bindDevice) forControlEvents:UIControlEventTouchUpInside];
    
    [_bindDeviceButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"textbox_save_settings_%d",selectedThemeIndex]] forState:UIControlStateNormal];
    [self addSubview:_bindDeviceButton];
    
    _backToScanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backToScanButton setTitle:@"我要扫码" forState:UIControlStateNormal];
    [_backToScanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backToScanButton addTarget:self action:@selector(backToScanView) forControlEvents:UIControlEventTouchUpInside];
    [_backToScanButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"textbox_hollow_%d",selectedThemeIndex]] forState:UIControlStateNormal];
    [self addSubview:_backToScanButton];
}

- (void)addConstraintsToViews
{
    [_barCodeTitle makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@44);
        make.top.equalTo(self.mas_top).offset(20);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    [_barCodeDescription makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(@80);
        make.top.equalTo(_barCodeTitle.mas_bottom).offset(30);
        make.width.equalTo(@200);
    }];
    
    [_barCodeTextField makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(@49);
        make.top.equalTo(_barCodeDescription.mas_bottom).offset(20);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    
    [_bindDeviceButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(@49);
        make.top.equalTo(_barCodeTextField.mas_bottom).offset(20);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    
    [_backToScanButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(@49);
        make.top.equalTo(_bindDeviceButton.mas_bottom).offset(20);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_barCodeTextField]) {
        [textField resignFirstResponder];
    }
    return YES;
}
#pragma mark 点击背景隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)backToScanView
{
    self.scanBarButtonTaped(1);
}

- (void)bindDevice
{
    if (_barCodeTextField.text.length > 0) {
        self.bindDeviceButtonTaped(_barCodeTextField.text);
    }else{
        [self makeToast:@"设备号不能为空" duration:2 position:@"center"];
    }
}

@end
