//
//  DocInfoTitileTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "DocInfoTitileTableViewCell.h"

@interface DocInfoTitileTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *docName;
@property (nonatomic, strong) UILabel *docTitle;
@property (nonatomic, strong) UILabel *docClinic;
@property (nonatomic, strong) UILabel *docHospital;

@end


@implementation DocInfoTitileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconImage = [[UIImageView alloc]init];
        _iconImage.image = [UIImage imageNamed:@"docTitle"];
        [self addSubview:_iconImage];
        [_iconImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.centerY.equalTo(self.mas_centerY);
            make.height.width.equalTo(@50);
        }];
        
        _docName = [[UILabel alloc]init];
        _docName.font = [UIFont systemFontOfSize:13];
        _docName.text = @"百克力";
        _docName.alpha = 0.8;
        [self addSubview:_docName];
        [_docName makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImage.mas_right).offset(14);
            make.top.equalTo(self.mas_top).offset(5);
        }];
        
        _docTitle = [[UILabel alloc]init];
        _docTitle.font = [UIFont systemFontOfSize:11];
        _docTitle.textColor = [UIColor grayColor];
        _docTitle.text = @"主任医师教授";
        [self addSubview:_docTitle];
        [_docTitle makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_docName.mas_right).offset(8);
            make.baseline.equalTo(_docName.mas_baseline);
        }];
        
        _docClinic = [[UILabel alloc]init];
        _docClinic.text = @"外科";
        _docClinic.textColor = [UIColor grayColor];
        _docClinic.font = [UIFont systemFontOfSize:9];
        [self addSubview:_docClinic];
        [_docClinic makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImage.mas_right).offset(14);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        _docHospital = [[UILabel alloc]init];
        _docHospital.font = [UIFont systemFontOfSize:11];
        _docHospital.textColor = [UIColor grayColor];
        _docHospital.text = @"上海第九人民医院";
        [self addSubview:_docHospital];
        [_docHospital makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImage.mas_right).offset(14);
            make.bottom.equalTo(self.mas_bottom).offset(-5);
        }];
        
    }
    return self;
}

- (void)configCellWithDic:(NSDictionary*)para
{
    [_iconImage setImageWithURL:[NSURL URLWithString:[para objectForKey:@"image"]] placeholder:[UIImage imageNamed:@"docTitle"]];
    _docName.text = [para objectForKey:@"name"];
    _docTitle.text = [para objectForKey:@"title"];
    _docClinic.text = [para objectForKey:@"clinic_name"];
    _docHospital.text = [para objectForKey:@"hospital"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
