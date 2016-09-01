//
//  MyDeviceTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/14.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "MyDeviceTableViewCell.h"
#import "MyDeviceListModel.h"

@interface MyDeviceTableViewCell ()

@property (nonatomic ,strong) NSString *cellUserDescription;
@property (nonatomic ,strong) UIImageView *selectImageView;
@property (nonatomic, strong) UIImageView *cellIconImageView;
@property (nonatomic, strong) UILabel *messageTime;

@end

@implementation MyDeviceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
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
        //
        _cellIconImageView = [[UIImageView alloc]init];
        [self.topContentView addSubview:_cellIconImageView];
        [_cellIconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topContentView);
            make.height.equalTo(@45);
            make.width.equalTo(@45);
            make.left.equalTo(self.topContentView.mas_left).offset(10);
        }];
        
        
        //
        _messageTime = [[UILabel alloc]init];
        _messageTime.numberOfLines = 0;
        [self.topContentView addSubview:_messageTime];
        _messageTime.text = @"";
        _messageTime.font = [UIFont systemFontOfSize:14];
        _messageTime.textColor = [UIColor colorWithRed:0.247f green:0.263f blue:0.271f alpha:1.00f];
        [_messageTime makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topContentView.mas_right).offset(-30);
            make.left.equalTo(_cellIconImageView.mas_right).offset(20);
            make.centerY.equalTo(_cellIconImageView.mas_centerY);
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
        NSString *cellIcon = deviceModel.detailDeviceList.count > 0 ? @"bed-s" : @"bed-d";
        _cellIconImageView.image = [UIImage imageNamed:cellIcon];
        if ([deviceModel.isActivated isEqualToString:@"False"]) {
            _selectImageView.hidden = YES;
        }else{
            _selectImageView.hidden = NO;
        }
        _messageTime.text = deviceModel.nDescription;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.backgroundColor = [UIColor grayColor];
}


@end
