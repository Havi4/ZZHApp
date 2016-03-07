//
//  EditCellInfoDelegate.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/13.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "EditCellInfoDelegate.h"
#import "EditInfoCellTableViewCell.h"

@interface EditCellInfoDelegate ()

@property (nonatomic,strong) UILabel *cellFooterView;

@end

@implementation EditCellInfoDelegate

- (id)initWithItems:(NSArray *)cellItems cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock cellHeightBlock:(CellHeightBlock)cellHeightBlock didSelectBlock:(DidSelectCellBlock)didSelectBlock
{
    self = [super init];
    if (self) {
        self.items = cellItems;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = configureCellBlock;
        self.heightConfigureBlock = cellHeightBlock;
        self.didSelectCellBlock = didSelectBlock;
        [self setPlaceHolderString:[self.items objectAtIndex:0]];
    }
    return self;
}

- (UILabel *)cellFooterView
{
    if (!_cellFooterView) {
        _cellFooterView = [[UILabel alloc]init];
        _cellFooterView.text = @"nin";
        _cellFooterView.frame = CGRectMake(15, 0, [[UIApplication sharedApplication] keyWindow].size.width - 30, 30);
        _cellFooterView.font = [UIFont systemFontOfSize:11];
        _cellFooterView.alpha = 0.4;
    }
    return _cellFooterView;
}

- (void)setPlaceHolderString:(NSString *)string
{
    if ([string isEqual:@"UserName"]) {
        self.cellFooterView.text = @"2-8个字符，可由中文、英文、数字组成";
    }else if ([string isEqual:@"EmergencyContact"]){
        self.cellFooterView.text = @"2-8个字符，可由中文、英文、数字组成";
    }else if ([string isEqual:@"Telephone"]){
        self.cellFooterView.text = @"11位有效手机号码";
    }
    
}


- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.items objectAtIndex:indexPath.row];
}

- (void)handleTableViewDataSourceAndDelegate:(UITableView *)tableView
{
    tableView.delegate = self;
    tableView.dataSource = self;
}

#pragma mark delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    EditInfoCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellInfo"];
    if (cell == nil) {
        cell = [[EditInfoCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellInfo"];
    }
    self.configureCellBlock(indexPath,item,cell);
    cell.tapTextSaveBlock = ^ (NSString *textValue) {
        if (self.didSelectCellBlock) {
            self.didSelectCellBlock(indexPath,textValue);
        }
    };
    cell.textChanageBlock = ^ (NSString *textValue) {
        if (self.chanageTextFieldBlock) {
            self.chanageTextFieldBlock(textValue);
        }
    };
    return cell;
}

#pragma mark datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self itemAtIndexPath:indexPath];
    return self.heightConfigureBlock(indexPath,item);
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    [backView addSubview:self.cellFooterView];
    return backView;
}


@end
