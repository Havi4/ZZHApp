//
//  MessageShowTableViewCell.m
//  SleepRecoding
//
//  Created by Havi on 15/11/11.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "MessageShowTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MessageShowTableViewCell ()

@property (nonatomic, strong) UIImageView *messageIcon;
@property (nonatomic, strong) UILabel *messageName;
@property (nonatomic, strong) UILabel *messagePhone;
@property (nonatomic, strong) UILabel *messageTime;
@property (nonatomic, strong) UIImageView *messageBack;
@property (nonatomic, strong) UIButton *messageAccepteButton;
@property (nonatomic, strong) UIButton *messageRefuseButton;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UITextView *messageShowWord;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation MessageShowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _messageIcon = [[UIImageView alloc]init];
        [self addSubview:_messageIcon];
        _messageIcon.layer.cornerRadius = 25;
        _messageIcon.layer.masksToBounds = YES;
        _messageIcon.layer.shouldRasterize = YES;
        _messageIcon.layer.rasterizationScale = 2;
        _messageIcon.image = [UIImage imageNamed:@"head_placeholder"];
        //
        _messageName = [[UILabel alloc]init];
        [self addSubview:_messageName];
        _messageName.text = @"";
        _messageName.textColor = [UIColor colorWithRed:0.247f green:0.263f blue:0.271f alpha:1.00f];

        _messageName.font = [UIFont systemFontOfSize:14];
        //
        _messagePhone = [[UILabel alloc]init];
        [self addSubview:_messagePhone];
        _messagePhone.font = [UIFont systemFontOfSize:14];
        _messagePhone.text = @"";
        _messagePhone.textColor = [UIColor colorWithRed:0.247f green:0.263f blue:0.271f alpha:1.00f];

        //
        _messageTime = [[UILabel alloc]init];
        [self addSubview:_messageTime];
        _messageTime.text = @"";
        _messageTime.font = [UIFont systemFontOfSize:14];
        _messageTime.textColor = [UIColor colorWithRed:0.247f green:0.263f blue:0.271f alpha:1.00f];
        //
        _messageBack = [[UIImageView alloc]init];
        _messageBack.image = [UIImage imageNamed:@"message_back"];
        [self addSubview:_messageBack];
        _messageShowWord = [[UITextView alloc]init];
        [_messageBack addSubview:_messageShowWord];
        _messageShowWord.text = @"";
        _messageShowWord.font = [UIFont systemFontOfSize:14];
        _messageShowWord.layer.cornerRadius = 5;
        _messageShowWord.layer.masksToBounds = YES;
        _messageShowWord.backgroundColor = [UIColor clearColor];
        _messageShowWord.userInteractionEnabled = NO;
        _messageShowWord.textColor = [UIColor grayColor];
        //
        _messageAccepteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_messageAccepteButton];
        [_messageAccepteButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.165 green:0.851 blue:0.455 alpha:1.00]] forState:UIControlStateNormal];
        _messageAccepteButton.layer.cornerRadius = 5;
        _messageAccepteButton.layer.masksToBounds = YES;
        [_messageAccepteButton setTitle:@"同意" forState:UIControlStateNormal];
        [_messageAccepteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_messageAccepteButton addTarget:self action:@selector(acceptButtonTarget:) forControlEvents:UIControlEventTouchUpInside];
        [_messageAccepteButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];
        _messageAccepteButton.titleLabel.font = [UIFont systemFontOfSize:14];

        //
        _messageRefuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_messageRefuseButton];
        _messageRefuseButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_messageRefuseButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.851 green:0.165 blue:0.216 alpha:1.00]] forState:UIControlStateNormal];
        _messageRefuseButton.layer.cornerRadius = 5;
        _messageRefuseButton.layer.masksToBounds = YES;
        [_messageRefuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [_messageRefuseButton addTarget:self action:@selector(refuseButtonTarget:) forControlEvents:UIControlEventTouchUpInside];
        [_messageRefuseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //
        _statusImageView = [[UIImageView alloc]init];
        [self addSubview:_statusImageView];
        
        //设置约束
        [_messageIcon makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top).offset(10);
            make.height.equalTo(@50);
            make.width.equalTo(@50);
        }];
        //
        [_messageName makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageIcon.mas_right).offset(5);
            make.top.equalTo(_messageIcon.mas_top);
            make.height.equalTo(_messagePhone.mas_height);
            make.width.equalTo(@150);
        }];
        //
        [_messagePhone makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageIcon.mas_right).offset(5);
            make.bottom.equalTo(_messageIcon.mas_bottom);
            make.width.equalTo(@150);
        }];
        //
        [_messageTime makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.equalTo(@20);
            make.top.equalTo(self.mas_top).offset(10);
        }];
        //
        [_messageAccepteButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_messagePhone.mas_centerY);
            make.right.equalTo(_messageRefuseButton.mas_left).offset(-10);
            make.height.equalTo(@25);
            make.width.equalTo(@60);
        }];
        //
        [_messageRefuseButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(_messageAccepteButton.mas_centerY);
            make.width.equalTo(_messageAccepteButton.mas_width);
            make.height.equalTo(_messageAccepteButton.mas_height);
        }];
        //
        [_messageBack makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageIcon.mas_right).offset(5);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(_messageRefuseButton.mas_bottom).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        //
        [_statusImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.height.equalTo(@50);
            make.width.equalTo(@90);
        }];
        [_messageShowWord makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageBack.mas_left).offset(0);
            make.right.equalTo(_messageBack.mas_right);
            make.top.equalTo(_messageBack.mas_top);
            make.bottom.equalTo(_messageBack.mas_bottom);
        }];
    }
    return self;
}

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
{
    // Rewrite this func in SubClass !
    if (obj) {
        RequestUserInfo *userInfo = obj;
        NSString *url = [NSString stringWithFormat:@"%@/v1/file/DownloadFile/%@",kAppBaseURL,userInfo.userID];
        [_messageIcon setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"head_placeholder"]];
        if (userInfo.userName.length == 0) {
            _messageName.text = @"匿名用户";
        }else{
            _messageName.text = userInfo.userName;
        }
        if (userInfo.statusCode == 1) {
            _statusImageView.image = [UIImage imageNamed:@"accept"];
            _messageAccepteButton.userInteractionEnabled = NO;
            [_messageAccepteButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
            _messageRefuseButton.userInteractionEnabled = NO;
            [_messageRefuseButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
            _messageName.textColor = [UIColor grayColor];
            _messagePhone.textColor = [UIColor grayColor];
            _messageTime.textColor = [UIColor grayColor];
        }else if (userInfo.statusCode == -1){
            _statusImageView.image = [UIImage imageNamed:@"refuse"];
            _messageAccepteButton.userInteractionEnabled = NO;
            [_messageAccepteButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
            _messageRefuseButton.userInteractionEnabled = NO;
            [_messageRefuseButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
            _messageName.textColor = [UIColor grayColor];
            _messagePhone.textColor = [UIColor grayColor];
            _messageTime.textColor = [UIColor grayColor];
        }else if (userInfo.statusCode == 0){
            _statusImageView.image = [UIImage imageNamed:@"apply"];
        }
        _messagePhone.text = userInfo.cellPhone;
        _messageTime.text = userInfo.requestDate;
        _messageShowWord.text = userInfo.comment;
    }
    self.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)refuseButtonTarget:(UIButton *)sender
{
    self.tapMessageButton(MessageRefuse,self,self.indexPath);
}

- (void)acceptButtonTarget:(UIButton *)sender
{
    self.tapMessageButton(MessageAccept,self,self.indexPath);
}

@end
