//
//  DataShowTableViewCell.m
//  SleepRecoding
//
//  Created by Havi_li on 15/2/27.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "DataShowTableViewCell.h"
@class LeftSideViewController;
@interface DataShowTableViewCell ()
{
    UILabel *cellLabel;
    UIImageView *leftImage;
    UIButton *buttonType1;
    UIButton *buttonType2;
    UIButton *buttonType3;
    NSArray *buttonArray;
}
@end

@implementation DataShowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        leftImage = [[UIImageView alloc]init];
        [self addSubview:leftImage];
        cellLabel = [[UILabel alloc]init];
        [self addSubview:cellLabel];
        [leftImage makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.width.equalTo(@25);
            make.height.equalTo(@25);
            make.centerY.equalTo(cellLabel.mas_centerY);
        }];
        //
        cellLabel.textColor = kDefaultColor;
        cellLabel.font = [UIFont systemFontOfSize:20];
        [cellLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImage.mas_right).offset(10);
            make.top.equalTo(self).offset(10);
            make.height.equalTo(@30);
        }];
// button1
        buttonType1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:buttonType1];
        [buttonType1 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(cellLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.height.equalTo(buttonType1.mas_width);
        }];
        [buttonType1 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"week_%d",0]] forState:UIControlStateNormal];
        buttonType1.tag = 101;
        //
// button2
        buttonType2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:buttonType2];
        [buttonType2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(buttonType1.mas_right).offset(20);
            make.top.equalTo(cellLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.centerY.equalTo(buttonType1.mas_centerY);
            make.height.equalTo(buttonType2.mas_width);
        }];
        [buttonType2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonType2 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"month_%d",0]] forState:UIControlStateNormal];
        buttonType2.tag = 102;
//button3
        buttonType3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:buttonType3];
        [buttonType3 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(buttonType2.mas_right).offset(20);
            make.top.equalTo(cellLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.centerY.equalTo(buttonType1.mas_centerY);
            make.height.equalTo(buttonType3.mas_width);
        }];
        [buttonType3 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"quarter_%d",0]] forState:UIControlStateNormal];
        buttonType3.tag = 103;

        buttonArray = @[buttonType1,buttonType2,buttonType3];
        
        }
    return self;
}

- (void)configure:(UITableViewCell *)cell
        customObj:(id)obj
        indexPath:(NSIndexPath *)indexPath
{
    // Rewrite this func in SubClass !
    NSDictionary *dic = obj;
    leftImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@0",[dic objectForKey:@"iconTitle"]]];
    cellLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"iconName"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (int i = 0; i<buttonArray.count; i++) {
        UIButton *button = [buttonArray objectAtIndex:i];
        [button addTarget:self.target action:self.buttonTaped forControlEvents:UIControlEventTouchUpInside];
    }

}

@end
