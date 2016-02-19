//
//  FriendDeviceTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/17.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "FriendDeviceTableViewCell.h"
#import "MyDeviceListModel.h"

@interface FriendDeviceTableViewCell ()

@property (nonatomic, strong) UIImageView *messageIcon;
@property (nonatomic, strong) UILabel *messageName;
@property (nonatomic, strong) UILabel *messagePhone;
@property (nonatomic, strong) UILabel *messageTime;
@property (nonatomic ,strong) UIImageView *selectImageView;

@end

@implementation FriendDeviceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _messageIcon = [[UIImageView alloc]init];
        [self.topContentView addSubview:_messageIcon];
        _messageIcon.frame = CGRectMake(0, 10, 20, 20);
        _messageIcon.image = [UIImage imageNamed:@"head_portrait_0"];
        _messageIcon.layer.cornerRadius = 22.5;
        _messageIcon.layer.masksToBounds = YES;
        
        //
        _messageName = [[UILabel alloc]init];
        [self.topContentView addSubview:_messageName];
        _messageName.text = @"";
        _messageName.font = [UIFont systemFontOfSize:14];
        _messageName.textColor = [UIColor colorWithRed:0.247f green:0.263f blue:0.271f alpha:1.00f];
        
        //
        _messagePhone = [[UILabel alloc]init];
        [self.topContentView addSubview:_messagePhone];
        _messagePhone.font = [UIFont systemFontOfSize:14];
        _messagePhone.text = @"";
        _messagePhone.textColor = [UIColor colorWithRed:0.247f green:0.263f blue:0.271f alpha:1.00f];
        
        //
        _messageTime = [[UILabel alloc]init];
        _messageTime.numberOfLines = 0;
        [self.topContentView addSubview:_messageTime];
        _messageTime.text = @"";
        _messageTime.font = [UIFont systemFontOfSize:14];
        _messageTime.textColor = [UIColor colorWithRed:0.247f green:0.263f blue:0.271f alpha:1.00f];
        _selectImageView = [[UIImageView alloc]init];
        _selectImageView.image = [UIImage imageNamed:@"choose"];
        [self.topContentView addSubview:_selectImageView];
        _selectImageView.hidden = YES;
        
        //
        
        [_selectImageView makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.width.equalTo(@20);
            make.centerY.equalTo(self.topContentView.mas_centerY);
            make.right.equalTo(self.topContentView.mas_right).offset(-10);
        }];
        
        [_messageIcon makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topContentView).offset(10);
            make.top.equalTo(self.topContentView).offset(10);
            make.height.equalTo(@45);
            make.width.equalTo(@45);
        }];
        //
        [_messageName makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageIcon.mas_right).offset(5);
            make.top.equalTo(self.topContentView).offset(10);
            make.height.equalTo(@20);
            make.height.equalTo(_messagePhone.mas_height);
            make.width.equalTo(@100);
        }];
        //
        [_messagePhone makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageIcon.mas_right).offset(5);
            make.top.equalTo(_messageName.mas_bottom).offset(5);
            make.width.equalTo(@100);
        }];
        //
        [_messageTime makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topContentView.mas_right).offset(-30);
            make.left.equalTo(_messagePhone.mas_right).offset(10);
            make.centerY.equalTo(_messageName.mas_centerY);
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
    if (obj) {
        DeviceList *deviceModel = (DeviceList *)obj;
        if ([deviceModel.isActivated isEqualToString:@"False"]) {
            _selectImageView.hidden = YES;
        }else{
            _selectImageView.hidden = NO;
        }
        NSString *url = [NSString stringWithFormat:@"%@/v1/file/DownloadFile/%@",kAppBaseURL,deviceModel.friendUserID];
        [_messageIcon setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"head_portrait_0"]];
        _messageTime.text = deviceModel.nDescription;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor lightGrayColor];
}
@end
