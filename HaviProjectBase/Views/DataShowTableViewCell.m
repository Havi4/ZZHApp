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
            make.width.equalTo(@17);
            make.height.equalTo(@17);
            make.centerY.equalTo(cellLabel.mas_centerY);
        }];
        //
        cellLabel.dk_textColorPicker = kTextColorPicker;
        cellLabel.font = kDefaultWordFont;
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
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.height.equalTo(buttonType1.mas_width);
        }];
        [buttonType1 dk_setBackgroundImage:DKImageWithNames(@"week_0", @"week_1") forState:UIControlStateNormal];
        buttonType1.tag = 101;
        //
// button2
        buttonType2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:buttonType2];
        [buttonType2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(buttonType1.mas_right).offset(20);
            make.top.equalTo(cellLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.centerY.equalTo(buttonType1.mas_centerY);
            make.height.equalTo(buttonType2.mas_width);
        }];
        [buttonType2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonType2 dk_setBackgroundImage:DKImageWithNames(@"month_0", @"month_1") forState:UIControlStateNormal];
        buttonType2.tag = 102;
//button3
        buttonType3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:buttonType3];
        [buttonType3 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(buttonType2.mas_right).offset(20);
            make.top.equalTo(cellLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.centerY.equalTo(buttonType1.mas_centerY);
            make.height.equalTo(buttonType3.mas_width);
        }];
        [buttonType3 dk_setBackgroundImage:DKImageWithNames(@"quarter_0", @"quarter_1") forState:UIControlStateNormal];
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
    leftImage.dk_imagePicker = DKImageWithNames([NSString stringWithFormat:@"%@0",[dic objectForKey:@"iconTitle"]],[NSString stringWithFormat:@"%@1",[dic objectForKey:@"iconTitle"]]);
    cellLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"iconName"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (int i = 0; i<buttonArray.count; i++) {
        UIButton *button = [buttonArray objectAtIndex:i];
        [button addTarget:self.target action:self.buttonTaped forControlEvents:UIControlEventTouchUpInside];
    }

}

@end
