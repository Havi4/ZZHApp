//
//  MyLoveTableViewCell.m
//  HaviProjectBase
//
//  Created by HaviLee on 2016/10/31.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "MyLoveTableViewCell.h"

@interface MyLoveTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *articleTime;
@property (nonatomic, strong) UILabel *articleSource;
@property (nonatomic, strong) UILabel *articleNum;
@property (nonatomic, strong) UIView *line;
@end

@implementation MyLoveTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = kDefaultWordFont;
        self.titleLabel.textColor = kTextDefaultWordColor;
        [self.topContentView addSubview:self.titleLabel];
        self.articleTime = [[UILabel alloc]init];
        self.articleTime.font = [UIFont systemFontOfSize:10];
        self.articleTime.textColor = kTextDefaultWordColor;
        [self.topContentView addSubview:self.articleTime];
        self.articleSource = [[UILabel alloc]init];
        self.articleSource.font = [UIFont systemFontOfSize:10];
        self.articleSource.textColor = kTextDefaultWordColor;
        [self.topContentView addSubview:self.articleSource];
        self.articleNum  = [[UILabel alloc]init];
        self.articleNum.font = [UIFont systemFontOfSize:10];
        self.articleNum.textColor = kTextDefaultWordColor;
        [self.topContentView addSubview:self.articleNum];
        self.line = [[UIView alloc]init];
        [self.topContentView addSubview:self.line];
        self.line.backgroundColor = [UIColor lightGrayColor];
        [self.line makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topContentView.mas_left);
            make.right.equalTo(self.topContentView.mas_right);
            make.bottom.equalTo(self.topContentView.mas_bottom);
            make.height.equalTo(@0.5);
        }];
        self.line.alpha = 0.3;
        
        //
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.left.equalTo(self.topContentView.mas_left).offset(15);
            make.right.equalTo(self.topContentView.mas_right).offset(-15);
            make.top.equalTo(self.topContentView.mas_top);
        }];
        
        [self.articleTime makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topContentView.mas_left).offset(15);
            make.height.equalTo(@20);
            make.width.equalTo(@100);
            make.bottom.equalTo(self.topContentView.mas_bottom);
        }];
        
        [self.articleSource makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.articleTime.mas_right).offset(10);
            make.centerY.equalTo(self.articleTime.mas_centerY);
            make.height.equalTo(@20);
        }];
        
        [self.articleNum makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topContentView.mas_right).offset(-15);
            make.centerY.equalTo(self.articleTime.mas_centerY);
            make.height.equalTo(@20);
        }];
        
    }
    return self;
}

- (void)cellConfigWithItem:(id)item andIndex:(NSIndexPath *)indexPath
{
    self.backgroundColor = [UIColor lightGrayColor];
    NSDictionary *dic = item;
    self.titleLabel.text = [dic objectForKey:@"Title"];
    self.articleTime.text = [[dic objectForKey:@"CollectionDate"] substringToIndex:16];
    self.articleSource.text = [dic objectForKey:@"Source"];
    self.articleNum.text = [dic objectForKey:@"PageView"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
