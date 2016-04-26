//
//  EditInfoCellTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/13.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "EditInfoCellTableViewCell.h"

@interface EditInfoCellTableViewCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *cellTextField;
@property (nonatomic, strong) NSString *placeHolder;

@end

@implementation EditInfoCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellTextField = [[UITextField alloc]init];
        _cellTextField.font = kTextNormalWordFont;
        _cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _cellTextField.placeholder = @"";
        _cellTextField.delegate = self;
        _cellTextField.returnKeyType = UIReturnKeyDone;
        [self addSubview:_cellTextField];
        [self.cellTextField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
        }];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_cellTextField];
    }
    return self;
}

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
{
    // Rewrite this func in SubClass !
    [self setPlaceHolderString:obj];
    self.placeHolder = obj;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kTableViewCellBackGroundColor;
}


#pragma mark uitextfield

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([self.placeHolder isEqual:@"UserName"]||[self.placeHolder isEqual:@"EmergencyContact"]) {
        if ([self checkIsValiadForString:textField.text]) {
            self.tapTextSaveBlock(textField.text);
            return YES;
        }else{
            [NSObject showHudTipStr:@"姓名只能由2-8位数字、字母、中文组成"];
        }
    }else{
         if ([self checkIsValiadForNum:textField.text]) {
             self.tapTextSaveBlock(textField.text);
             return YES;
         }else{
             [NSObject showHudTipStr:@"手机格式有误"];
         }
    }
    return YES;
}

- (void)textFieldChanged:(NSNotification *)noti
{
    self.textChanageBlock(_cellTextField.text);
}

- (void)setPlaceHolderString:(NSString *)string
{
    if ([string isEqual:@"UserName"]) {
        self.cellTextField.placeholder = @"请输入您的姓名";
    }else if ([string isEqual:@"EmergencyContact"]){
        self.cellTextField.placeholder = @"请输入您的紧急联系人";
    }else if ([string isEqual:@"Telephone"]){
        self.cellTextField.placeholder = @"请输入紧急联系人的手机";
        self.cellTextField.keyboardType = UIKeyboardTypeNumberPad;
    }

}

- (BOOL)checkIsValiadForString:(NSString *)checkString
{
    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5]{2,8}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([pred evaluateWithObject:checkString]) {
        
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)checkIsValiadForNum:(NSString *)checkString
{
    NSString *regex = @"1[0-9]{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([pred evaluateWithObject:checkString]) {
        
        return YES;
    }else{
        return NO;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

@end
