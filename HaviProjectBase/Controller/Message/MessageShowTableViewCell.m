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
        _messagePhone.font = [UIFont systemFontOfSize:12];
        _messagePhone.text = @"";
        _messagePhone.textColor = [UIColor colorWithRed:0.247f green:0.263f blue:0.271f alpha:1.00f];

        //
        _messageTime = [[UILabel alloc]init];
        [self addSubview:_messageTime];
        _messageTime.text = @"";
        _messageTime.font = [UIFont systemFontOfSize:10];
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
        [_messageAccepteButton setBackgroundImage:[UIImage imageNamed:@"button_down_image@3x"] forState:UIControlStateNormal];
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
        [_messageRefuseButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.00]] forState:UIControlStateNormal];
        _messageRefuseButton.layer.cornerRadius = 5;
        _messageRefuseButton.layer.masksToBounds = YES;
        [_messageRefuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
        [_messageRefuseButton addTarget:self action:@selector(refuseButtonTarget:) forControlEvents:UIControlEventTouchUpInside];
        [_messageRefuseButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //
        _statusImageView = [[UIImageView alloc]init];
        [self addSubview:_statusImageView];
        
        //设置约束
        [_messageIcon makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.width.equalTo(@50);
            make.left.equalTo(self.mas_left).offset(16);
            make.centerY.equalTo(self.mas_centerY);
        }];
        //
        [_messageName makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageIcon.mas_right).offset(5);
            make.top.equalTo(self.mas_top).offset(5);
            make.width.equalTo(@150);
        }];
        //
        [_messagePhone makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageIcon.mas_right).offset(5);
            make.top.equalTo(_messageName.mas_bottom);
            make.width.equalTo(@150);
        }];
        //
        [_messageTime makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageIcon.mas_right).offset(5);
            make.top.equalTo(_messagePhone.mas_bottom);
            make.height.equalTo(_messagePhone.mas_height);
            make.height.equalTo(_messageName.mas_height);
            make.bottom.equalTo(self.mas_bottom).offset(-5);
        }];
        //
        [_messageAccepteButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(_messageRefuseButton.mas_left).offset(-10);
            make.height.equalTo(@25);
            make.width.equalTo(@50);
        }];
        //
        [_messageRefuseButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(_messageAccepteButton.mas_width);
            make.height.equalTo(_messageAccepteButton.mas_height);
        }];
        //
//        [_messageBack makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_messageIcon.mas_right).offset(5);
//            make.right.equalTo(self.mas_right).offset(-10);
//            make.top.equalTo(_messageRefuseButton.mas_bottom).offset(10);
//            make.bottom.equalTo(self.mas_bottom).offset(-10);
//        }];
        //
//        [_statusImageView makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mas_top).offset(0);
//            make.right.equalTo(self.mas_right).offset(0);
//            make.height.equalTo(@50);
//            make.width.equalTo(@90);
//        }];
//        [_messageShowWord makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_messageBack.mas_left).offset(0);
//            make.right.equalTo(_messageBack.mas_right);
//            make.top.equalTo(_messageBack.mas_top);
//            make.bottom.equalTo(_messageBack.mas_bottom);
//        }];
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
            _messageAccepteButton.hidden = YES;
            _messageRefuseButton.backgroundColor = [UIColor clearColor];
            [_messageRefuseButton setTitle:@"已接受" forState:UIControlStateNormal];
            [_messageRefuseButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _messageRefuseButton.userInteractionEnabled = NO;
            [_messageRefuseButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];

        }else if (userInfo.statusCode == -1){
            _messageAccepteButton.hidden = YES;
            _messageRefuseButton.backgroundColor = [UIColor clearColor];
            [_messageRefuseButton setTitle:@"已拒绝" forState:UIControlStateNormal];
            [_messageRefuseButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _messageRefuseButton.userInteractionEnabled = NO;
            [_messageRefuseButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        }else if (userInfo.statusCode == 0){
            _messageAccepteButton.hidden = NO;
            [_messageAccepteButton setTitle:@"同意" forState:UIControlStateNormal];
            [_messageAccepteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_messageRefuseButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.00]] forState:UIControlStateNormal];

            [_messageRefuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
            [_messageRefuseButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _messageRefuseButton.userInteractionEnabled = YES;
        }
        _messagePhone.text = userInfo.comment;
        _messageTime.text = userInfo.requestDate;
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
