//
//  SearchUserTableViewCell.m
//  SleepRecoding
//
//  Created by Havi on 15/11/12.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "SearchUserTableViewCell.h"

@interface SearchUserTableViewCell ()

@property (nonatomic, strong) UIImageView *messageIcon;
@property (nonatomic, strong) UILabel *messageName;
@property (nonatomic, strong) UILabel *messagePhone;
@property (nonatomic, strong) UIButton *messageSendButton;

@end

@implementation SearchUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _messageIcon = [[UIImageView alloc]init];
        [self addSubview:_messageIcon];
        _messageIcon.layer.cornerRadius = 27.5;
        _messageIcon.layer.masksToBounds = YES;
        _messageIcon.layer.shouldRasterize = YES;
        _messageIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _messageIcon.image = [UIImage imageNamed:@"head_portrait_0"];
        //
        _messageName = [[UILabel alloc]init];
        [self addSubview:_messageName];
        _messageName.text = @"哈维";
        _messageName.textColor = [UIColor colorWithRed:0.247f green:0.263f blue:0.271f alpha:1.00f];
        _messageName.font = [UIFont systemFontOfSize:14];
        //
        _messagePhone = [[UILabel alloc]init];
        [self addSubview:_messagePhone];
        _messagePhone.font = [UIFont systemFontOfSize:14];
        _messagePhone.textColor = [UIColor colorWithRed:0.247f green:0.263f blue:0.271f alpha:1.00f];
        _messagePhone.text = @"13122785292";
        //
        _messageSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_messageSendButton];
        [_messageSendButton setTitle:@"申请查看" forState:UIControlStateNormal];
        [_messageSendButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.000f green:0.867f blue:0.596f alpha:1.00f]] forState:UIControlStateNormal];
        _messageSendButton.layer.cornerRadius = 5;
        _messageSendButton.layer.masksToBounds = YES;
        [_messageSendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_messageSendButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
        [_messageSendButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];
        _messageSendButton.titleLabel.font = [UIFont systemFontOfSize:17];
        //
        
        [_messageIcon makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(10);
            make.height.equalTo(@55);
            make.width.equalTo(@55);
        }];
        //
        [_messageName makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageIcon.mas_right).offset(10);
            make.top.equalTo(self).offset(10);
            make.height.equalTo(@20);
            make.height.equalTo(_messagePhone.mas_height);
            make.width.equalTo(@100);
        }];
        //
        [_messagePhone makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageIcon.mas_right).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.width.equalTo(@100);
        }];
        //
        [_messageSendButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(_messagePhone.mas_centerY);
            make.width.equalTo(@80);
            make.height.equalTo(@30);
        }];
    }
    return self;
}

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
{
    // Rewrite this func in SubClass !
    UserList *userModel = (UserList*)obj;
    NSString *iconString = [NSString stringWithFormat:@"%@/v1/file/DownloadFile/%@",kAppBaseURL,userModel.userID];
    [_messageIcon setImageWithURL:[NSURL URLWithString:iconString] placeholder:[UIImage imageNamed:@"head_placeholder"]];
    if (userModel.userName.length == 0) {
        _messageName.text = @"匿名用户";
    }else{
        _messageName.text = userModel.userName;
    }
    _messagePhone.text = userModel.cellPhone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)buttonTarget:(UIButton *)sender
{
    MMPopupBlock completeBlock = ^(MMPopupView *popupView){
        
    };
    [[[MMAlertView alloc] initWithInputTitle:@"提示" detail:@"请输入验证信息，可以提高您的申请成功率" placeholder:@"我是***,希望查看您的设备" handler:^(NSString *text) {
        if (text.length==0) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"请输入验证信息" duration:2 position:@"center" ];
            return ;
        }
        self.sendMessageTaped(self,text);
    }] showWithBlock:completeBlock];
}

@end
