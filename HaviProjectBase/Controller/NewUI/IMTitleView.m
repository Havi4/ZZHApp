//
//  IMTitleView.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/21.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "IMTitleView.h"

@interface IMTitleView ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *docName;
@property (nonatomic, strong) UILabel *docTitle;
@property (nonatomic, strong) UILabel *docClinic;
@property (nonatomic, strong) UILabel *docHospital;

@end

@implementation IMTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
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
            make.top.equalTo(self.mas_top).offset(10);
        }];
        
        _docHospital = [[UILabel alloc]init];
        _docHospital.font = [UIFont systemFontOfSize:11];
        _docHospital.textColor = [UIColor grayColor];
        _docHospital.text = @"上海第九人民医院";
        [self addSubview:_docHospital];

        [_docHospital makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_docName.mas_right).offset(8);
            make.baseline.equalTo(_docName.mas_baseline);
        }];
        
        _docClinic = [[UILabel alloc]init];
        _docClinic.text = @"外科";
        _docClinic.backgroundColor = [UIColor colorWithRed:0.157 green:0.659 blue:0.902 alpha:1.00];
        _docClinic.layer.cornerRadius = 2;
        _docClinic.layer.masksToBounds = YES;
        _docClinic.textColor = [UIColor whiteColor];
        _docClinic.font = [UIFont systemFontOfSize:11];
        [self addSubview:_docClinic];
        [_docClinic makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconImage.mas_right).offset(14);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        
        _docTitle = [[UILabel alloc]init];
        _docTitle.font = [UIFont systemFontOfSize:11];
        _docTitle.textColor = [UIColor whiteColor];
        _docTitle.backgroundColor = [UIColor colorWithRed:0.157 green:0.659 blue:0.902 alpha:1.00];
        _docTitle.layer.cornerRadius = 2;
        _docTitle.layer.masksToBounds = YES;
        _docTitle.text = @"主任医师教授";
        [self addSubview:_docTitle];
        
        
        [_docTitle makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_docClinic.mas_right).offset(8);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        

    }
    return self;
}

- (void)configTitleView:(NSDictionary *)dic
{
    [_iconImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image"]] placeholder:[UIImage imageNamed:@"docTitle"]];
    _docName.text = [dic objectForKey:@"name"];
    _docTitle.text = [dic objectForKey:@"title"];
    _docClinic.text = [dic objectForKey:@"clinic"];
    _docHospital.text = [dic objectForKey:@"hospital"];

}

@end
