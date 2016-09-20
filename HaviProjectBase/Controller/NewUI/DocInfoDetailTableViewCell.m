//
//  DocInfoDetailTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "DocInfoDetailTableViewCell.h"

@interface DocInfoDetailTableViewCell ()

@property (nonatomic, strong) UILabel *titleDoc;
@property (nonatomic, strong) UILabel *detailDoc;

@end

@implementation DocInfoDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleDoc = [[UILabel alloc]init];
        _titleDoc.text = @"擅长疾病及诊所介绍";
        _titleDoc.alpha = 0.8;
        _titleDoc.font = [UIFont systemFontOfSize:13];
        [self addSubview:_titleDoc];
        [_titleDoc makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left).offset(16);
            make.height.equalTo(@44);
        }];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.3;
        [self addSubview:line];
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleDoc.mas_bottom);
            make.left.equalTo(self.mas_left).offset(16);
            make.right.equalTo(self.mas_right).offset(-16);
            make.height.equalTo(@0.5);
        }];
        _detailDoc = [[UILabel alloc]init];
        _detailDoc.textColor = [UIColor grayColor];
        _detailDoc.numberOfLines = 0;
        _detailDoc.text = @"ksld两阶段发 的对了师傅；金沙江看";
        _detailDoc.font = [UIFont systemFontOfSize:11];
        [self addSubview:_detailDoc];
        [_detailDoc makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.top.equalTo(line.mas_bottom).offset(4);
            make.bottom.equalTo(self.mas_bottom).offset(-4);
            make.right.equalTo(self.mas_right).offset(-16);
        }];
        
    }
    return self;
}

- (void)configCellWithDic:(NSDictionary*)para
{
    _titleDoc.text = [NSString stringWithFormat:@"%@",[para objectForKey:@"title"]];
    NSString *labelText = [NSString stringWithFormat:@"%@",[para objectForKey:@"detail"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:1.5];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    _detailDoc.attributedText = attributedString;
    [_detailDoc sizeToFit];
//    _detailDoc.text = [NSString stringWithFormat:@"%@",[para objectForKey:@"detail"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
