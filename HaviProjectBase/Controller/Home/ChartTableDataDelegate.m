//
//  ChartTableDataDelegate.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ChartTableDataDelegate.h"
#import "ChartTableDataViewCell.h"
#import "ChartTableTitleView.h"
#import "ZZHPieView.h"
#import "TurnAroundView.h"

@interface ChartTableDataDelegate ()

@property (nonatomic, strong) ChartTableTitleView *titleView;


@property (nonatomic, strong) ZZHPieView *pieView;
@property (nonatomic, strong) TurnAroundView *turnView;
@property (nonatomic, strong) UIView *turnBackView;
@property (nonatomic,strong) UIScrollView *scrollContainerView;
@property (nonatomic, strong) UILabel *dataLabel;

@end

@implementation ChartTableDataDelegate

- (id)initWithItems:(NSArray *)cellItems cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock cellHeightBlock:(CellHeightBlock)cellHeightBlock didSelectBlock:(DidSelectCellBlock)didSelectBlock
{
    self = [super init];
    if (self) {
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = configureCellBlock;
        self.heightConfigureBlock = cellHeightBlock;
        self.didSelectCellBlock = didSelectBlock;
    }
    return self;
}

- (void)handleTableViewDataSourceAndDelegate:(UITableView *)tableView
{
    tableView.delegate = self;
    tableView.dataSource = self;
    if (self.type == SensorDataLeave) {
        tableView.tableHeaderView = self.pieView;
    }else if (self.type == SensorDataTurn){
        tableView.tableHeaderView = self.turnBackView;
    }
    
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.items objectAtIndex:indexPath.row];
}

- (UIView *)turnBackView
{
    if (!_turnBackView) {
        _turnBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.width)];
        [_turnBackView addSubview:self.scrollContainerView];
        self.dataLabel = [[UILabel alloc]init];
        self.dataLabel.text = @"--";
        self.dataLabel.textColor = [UIColor whiteColor];
        self.dataLabel.font = [UIFont systemFontOfSize:30];
        UILabel *sub = [[UILabel alloc]init];
        sub.textColor = [UIColor whiteColor];
        sub.text = @"次/天";
        sub.font = [UIFont systemFontOfSize:15];
        [_turnBackView addSubview:sub];
        [_turnBackView addSubview:self.dataLabel];
        
        [_dataLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_turnBackView.mas_left).offset(16);
            make.top.equalTo(_turnBackView.mas_top).offset(16);
            make.height.equalTo(@32);
        }];
        
        [sub makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dataLabel.mas_right);
            make.baseline.equalTo(_dataLabel.mas_baseline);
        }];
        
        UIView *leftView1 = [[UIView alloc]init];
        leftView1.backgroundColor = [UIColor colorWithRed:0.784 green:0.753 blue:0.235 alpha:1.00];
        [_turnBackView addSubview:leftView1];
        
        UILabel *leftLabel1 = [[UILabel alloc]init];
        leftLabel1.text = @"体动";
        leftLabel1.textColor = [UIColor whiteColor];
        leftLabel1.font = [UIFont systemFontOfSize:14];
        [_turnBackView addSubview:leftLabel1];
        
        UIView *leftView = [[UIView alloc]init];
        leftView.backgroundColor = [UIColor colorWithRed:0.635 green:0.851 blue:0.867 alpha:1.00];
        [_turnBackView addSubview:leftView];
        
        UILabel *leftLabel = [[UILabel alloc]init];
        leftLabel.text = @"入睡";
        leftLabel.textColor = [UIColor whiteColor];
        leftLabel.font = [UIFont systemFontOfSize:14];
        [_turnBackView addSubview:leftLabel];
        
        UIView *rightView = [[UIView alloc]init];
        rightView.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.00];
        [_turnBackView addSubview:rightView];
        
        UILabel *rightLabel = [[UILabel alloc]init];
        rightLabel.text = @"离床";
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.font = [UIFont systemFontOfSize:14];
        [_turnBackView addSubview:rightLabel];
        
        [leftLabel1 makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_scrollContainerView.mas_bottom).offset(32);
            make.right.equalTo(_turnBackView.mas_right).offset(-16);
        }];
        
        [leftView1 makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftLabel1.mas_centerY);
            make.right.equalTo(leftLabel1.mas_left).offset(-8);
            make.height.width.equalTo(@15);
        }];
        
        [rightLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftView1.mas_centerY);
            make.right.equalTo(leftView1.mas_left).offset(-16);
        }];
        
        [rightView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(rightLabel.mas_centerY);
            make.right.equalTo(rightLabel.mas_left).offset(-8);
            make.height.width.equalTo(@15);
        }];
        
        [leftLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(rightLabel.mas_centerY);
            make.right.equalTo(rightView.mas_left).offset(-16);
        }];
        
        [leftView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftLabel.mas_centerY);
            make.right.equalTo(leftLabel.mas_left).offset(-8);
            make.height.width.equalTo(@15);
        }];
        
        UIImageView *image = [[UIImageView alloc]init];
        image.image = [UIImage imageNamed:@"moveon@3x"];
        [_turnBackView addSubview:image];
        [image makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_turnBackView.mas_left).offset(8);
            make.top.equalTo(_scrollContainerView.mas_top).offset(-8);
            make.height.equalTo(@20);
            make.width.equalTo(@15);
        }];
    }
    return _turnBackView;
}

- (UIScrollView *)scrollContainerView
{
    if (!_scrollContainerView) {
        _scrollContainerView = [[UIScrollView alloc]initWithFrame:CGRectMake(16, 64, kScreenWidth-32, 180)];
        _scrollContainerView.contentSize = CGSizeMake((kScreenWidth-32)*4, 180);
        _scrollContainerView.showsHorizontalScrollIndicator = NO;
        _scrollContainerView.delegate = self;
        _scrollContainerView.userInteractionEnabled = YES;
        [_scrollContainerView addSubview:self.turnView];
        _turnView.xValues = @[@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00"];
    }
    return _scrollContainerView;
}

- (ZZHPieView *)pieView
{
    if (!_pieView) {
        _pieView = [[ZZHPieView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.width)];
//        _pieView.backgroundColor = [UIColor redColor];
    }
    return _pieView;
}

- (TurnAroundView *)turnView
{
    if (!_turnView) {
        _turnView = [[TurnAroundView alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth-32)*4, 180)];
        
    }
    return _turnView;
}

- (ChartTableTitleView*)titleView
{
    if (!_titleView) {
        _titleView = [[ChartTableTitleView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 188)];
        
    }
    return _titleView;
}

#pragma mark delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == SensorDataLeave) {
        return 1;
    }else if (self.type == SensorDataTurn){
        return 1;
    }
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
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == SensorDataLeave) {
        if (indexPath.row == 0) {
            static NSString *cellIndentifier = @"cell2";
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
            }
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            cell.dk_backgroundColorPicker = DKColorWithColors([UIColor clearColor], [UIColor clearColor]);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.dk_textColorPicker = kTextColorPicker;
//            UIView *lineViewBottom = [[UIView alloc]init];
//            lineViewBottom.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.627 green:0.847 blue:0.890 alpha:1.00], [UIColor colorWithRed:0.627 green:0.847 blue:0.890 alpha:1.00]);
//            [cell addSubview:lineViewBottom];
//            [lineViewBottom makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(cell.textLabel.mas_baseline).offset(-15);
//                make.height.equalTo(@0.5);
//                make.centerX.equalTo(cell.mas_centerX);
//                make.width.equalTo(@70);
//            }];
            self.configureCellBlock(indexPath,nil,cell);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ChartTableDataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
            if (!cell) {
                cell = [[ChartTableDataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
            }
            self.configureCellBlock(indexPath,nil,cell);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else{
        if (indexPath.row == 0) {
            static NSString *cellIndentifier = @"cell2";
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                
            }
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            cell.dk_backgroundColorPicker = DKColorWithColors([UIColor clearColor], [UIColor clearColor]);
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.dk_textColorPicker = kTextColorPicker;
//            UIView *lineViewBottom = [[UIView alloc]init];
//            lineViewBottom.dk_backgroundColorPicker = DKColorWithColors([UIColor colorWithRed:0.627 green:0.847 blue:0.890 alpha:1.00], [UIColor colorWithRed:0.627 green:0.847 blue:0.890 alpha:1.00]);
//            [cell addSubview:lineViewBottom];
//            [lineViewBottom makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(cell.textLabel.mas_baseline).offset(-15);
//                make.height.equalTo(@0.5);
//                make.centerX.equalTo(cell.mas_centerX);
//                make.width.equalTo(@70);
//            }];
            self.configureCellBlock(indexPath,nil,cell);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            id item = [self itemAtIndexPath:indexPath];
            ChartTableDataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
            if (!cell) {
                cell = [[ChartTableDataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
            }
            self.configureCellBlock(indexPath,item,cell);
            return cell;
        }
    }
    
}

#pragma mark datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.heightConfigureBlock(indexPath,nil);
}

- (void)reloadTableViewHeaderWith:(id)data withType:(SensorDataType)type{
    if (type == SensorDataLeave) {
        
        [self.pieView reloadTableViewHeaderWith:data withType:type];
    }else{
        SleepQualityModel *model = data;
        if ([model.outOfBedTimes intValue]==0) {
            self.dataLabel.text = @"--";
        }else{
            self.dataLabel.text = [NSString stringWithFormat:@"%d",[model.bodyMovementTimes intValue]];
        }
    }
}

- (void)reloadTableViewWith:(id)data withType:(SensorDataType)type
{
    if (type == SensorDataLeave) {
        [self.pieView reloadTableViewWith:data withType:type];
    }else{
        self.turnView.dataValues = data;
    }
}

@end
