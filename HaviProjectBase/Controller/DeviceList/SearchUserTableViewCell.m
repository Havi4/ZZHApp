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
        [_messageSendButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.427 green:0.757 blue:0.929 alpha:1.00]] forState:UIControlStateNormal];
        _messageSendButton.layer.cornerRadius = 5;
        _messageSendButton.layer.masksToBounds = YES;
        [_messageSendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_messageSendButton addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
        [_messageSendButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];
        _messageSendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        //
        
        [_messageIcon makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@44);
            make.width.equalTo(@44);
        }];
        //
        [_messageName makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageIcon.mas_right).offset(10);
            make.top.equalTo(_messageIcon.mas_top);
            make.height.equalTo(@20);
            make.height.equalTo(_messagePhone.mas_height);
            make.width.equalTo(@100);
        }];
        //
        [_messagePhone makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageIcon.mas_right).offset(10);
            make.bottom.equalTo(_messageIcon.mas_bottom);
            make.width.equalTo(@100);
        }];
        //
        [_messageSendButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(self.mas_centerY);
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
    MMAlertViewConfig *cong = [MMAlertViewConfig globalConfig];
    cong.cornerRadius = 15;
    cong.itemHighlightColor = [UIColor colorWithRed:0.000 green:0.294 blue:0.863 alpha:1.00];
    MMAlertView *alert = [[MMAlertView alloc] initWithInputTitle:@"提示" detail:@"请输入验证信息，提高申请成功率" placeholder:@"我是***" handler:^(NSString *text) {
        if (text.length==0) {
            [NSObject showHudTipStr:@"请输入验证信息"];
            return;
        }
        self.sendMessageTaped(self,text);
    }];
    [alert showWithBlock:completeBlock];
    
}

@end
