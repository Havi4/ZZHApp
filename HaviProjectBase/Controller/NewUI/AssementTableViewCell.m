//
//  AssementTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "AssementTableViewCell.h"

@interface AssementTableViewCell ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *titlebackView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleIll;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation AssementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titlebackView = [[UIView alloc]init];
        [self addSubview:_titlebackView];
        [_titlebackView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@44);
        }];
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [UIImage imageNamed:@"wenzhen"];
        _backImageView.userInteractionEnabled = YES;
        [self addSubview:_backImageView];
        [_backImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.right.equalTo(self.mas_right).offset(-8);
            make.top.equalTo(_titlebackView.mas_bottom);
            make.bottom.equalTo(self.mas_bottom).offset(-8);
        }];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"疾病";
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [_titlebackView addSubview:_titleLabel];
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.height.equalTo(@44);
        }];
        
        _arrowView = [[UIImageView alloc]init];
        _arrowView.image = [UIImage imageNamed:@"xuanze"];
//        [_titlebackView addSubview:_arrowView];
//        [_arrowView makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_right).offset(-8);
//            make.centerY.equalTo(_titleLabel.mas_centerY);
//            make.width.equalTo(@10);
//            make.height.equalTo(@20);
//        }];
        
        _titleIll = [[UILabel alloc]init];
        _titleIll.text = @"未确诊可不选";
        _titleIll.textColor = [UIColor grayColor];
        _titleIll.font = [UIFont systemFontOfSize:16];
//        [_titlebackView addSubview:_titleIll];
//        [_titleIll makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(_arrowView.mas_left).offset(-8);
//            make.height.equalTo(@44);
//        }];
        _textView = [[UITextView alloc]init];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
        [_backImageView addSubview:_textView];
        [_textView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backImageView.mas_left).offset(1);
            make.right.equalTo(_backImageView.mas_right).offset(-1);
            make.top.equalTo(_backImageView.mas_top).offset(1.5);
            make.height.equalTo(@60);
        }];
        _textView.text = @"请输入0-20个字";
        _textView.textColor = [UIColor grayColor];

    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入0-20个字"]) {
        textView.text = @"";
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    NSInteger number = [textView.text length];
    if (number > 20) {
        [NSObject showHudTipStr:@"字数超过20个"];
        textView.text = [textView.text substringToIndex:20];
    }
    self.textViewData(textView.text);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
