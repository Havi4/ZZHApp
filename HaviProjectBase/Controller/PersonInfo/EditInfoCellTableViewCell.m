//
//  EditInfoCellTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/13.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "EditInfoCellTableViewCell.h"
#import "BetaNaoTextField.h"

@interface EditInfoCellTableViewCell ()<UITextFieldDelegate>

@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic,strong) BetaNaoTextField *cellTextField;
@property (nonatomic, strong) NSString *cellTextString;

@end

@implementation EditInfoCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.cellTextField];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_cellTextField];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showText) name:@"cellEdit" object:nil
         ];
    }
    return self;
}

- (BetaNaoTextField *)cellTextField
{
    if (!_cellTextField) {
        _cellTextField = [[BetaNaoTextField alloc]init];
        _cellTextField.frame = CGRectMake(16, -20, kScreenSize.width-32, 80);
        _cellTextField.textPlaceHolder = @"地址";
        _cellTextField.textPlaceHolderColor = [UIColor lightGrayColor];
        _cellTextField.textLineColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
        _cellTextField.returnKeyType = UIReturnKeyDone;
        //        [_cellTextField becomeFirstResponder];
        //        _cellTextField.scrollEnabled = NO;
                _cellTextField.delegate = self;
        //        _cellTextField.alpha = 0.9;
        //        _cellTextField.returnKeyType = UIReturnKeyDone;
        
    }
    return _cellTextField;
}


- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath withOtherInfo:(id)objInfo
{
    // Rewrite this func in SubClass !
    [self setPlaceHolderString:obj];
    self.placeHolder = obj;
    self.cellTextString = objInfo;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
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
        self.cellTextField.textPlaceHolder = @"请输入您的姓名";
    }else if ([string isEqual:@"EmergencyContact"]){
        self.cellTextField.textPlaceHolder = @"请输入您的紧急联系人";
    }else if ([string isEqual:@"Telephone"]){
        self.cellTextField.textPlaceHolder = @"请输入紧急联系人的手机";
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

- (void)showText
{
    [self.cellTextField becomeFirstResponder];
    [self.cellTextField reloadTextFieldWithTextString:self.cellTextString];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cellEdit" object:nil];
}

@end
