//
//  CantainerDeviceListViewController.m
//  SleepRecoding
//
//  Created by Havi on 15/12/8.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "CantainerDeviceListViewController.h"
#import "ContainerTableViewCell.h"

@interface CantainerDeviceListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString *selectDeviceUUID;
@property (nonatomic, strong) NSIndexPath *selectedPath;
@property (nonatomic, strong) UITableView *sideTableView;//左侧栏tableview
@property (nonatomic, strong) NSArray *deviceArr;
@property (nonatomic,strong) UIView *noDataImageView;

@end

@implementation CantainerDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0.0, 8.0);
    self.view.layer.shadowOpacity = 0.3;
    self.view.layer.shadowRadius = 10.0;
    self.view.layer.cornerRadius = 4.0;
    self.view.layer.masksToBounds = YES;

    // Do any additional setup after loading the view.
    [self setSubView];
    [self getUserDeviceList];
}

- (void)setSubView
{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:cancelButton];
    [cancelButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_x_%d",selectedThemeIndex]] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelView:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.width.height.equalTo(@24);
    }];
    //title
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.view addSubview:titleLabel];
    titleLabel.text = @"我的设备";
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.dk_textColorPicker = kTextColorPicker;
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cancelButton.mas_centerY);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.view addSubview:self.sideTableView];
    self.sideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sideTableView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44);
    
}

- (UITableView *)sideTableView {
    if (!_sideTableView) {
        _sideTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _sideTableView.backgroundColor = [UIColor clearColor];
        _sideTableView.delegate = self;
        _sideTableView.dataSource = self;
    }
    return _sideTableView;
}

#pragma mark 请求数据
- (void)getUserDeviceList
{
    ZZHAPIManager *apiManager = [ZZHAPIManager sharedAPIManager];
    NSDictionary *dic12 = @{
                            @"UserID":thirdPartyLoginUserId,
                            };
    [apiManager requestCheckMyDeviceListParams:dic12 andBlock:^(MyDeviceListModel *myDeviceList, NSError *error) {
        self.deviceArr = myDeviceList.deviceList;
        if (self.deviceArr.count == 0) {
            [self.view addSubview:self.noDataImageView];
        }else {
            [self.noDataImageView removeFromSuperview];
        }
        [self.sideTableView reloadData];
    }];    
}


#pragma mark tableview 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIndentifier = [NSString stringWithFormat:@"cell"];
    ContainerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[ContainerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    DeviceList *deviceInfo = [self.deviceArr objectAtIndex:indexPath.row];
    cell.cellUserDescription = [NSString stringWithFormat:@"%@", deviceInfo.nDescription];
    cell.selectImageView.hidden = YES;
    if ([deviceInfo.isActivated isEqualToString:@"True"]) {
        cell.selectImageView.hidden = NO;
    }else{
        cell.selectImageView.hidden = YES;
        
    }
    if ([deviceInfo.detailDeviceList count]>0) {
        cell.cellIconImageView.image = [UIImage imageNamed:@"icon_double"];
    }else{
        cell.cellIconImageView.image = [UIImage imageNamed:@"icon_solo"];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.145f green:0.733f blue:0.957f alpha:0.15f];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedPath = indexPath;
    [tableView reloadData];
    gloableActiveDevice = [self.deviceArr objectAtIndex:indexPath.row];
    [UserManager setGlobalOauth];
    [self changeUUID:gloableActiveDevice.deviceUUID];

}

- (UIView*)noDataImageView
{
    if (!_noDataImageView) {
        _noDataImageView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-150)/2, 200, 150, 105)];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(59, 16, 32, 32)];
        image.dk_imagePicker = DKImageWithNames(@"sad-75_0", @"sad-75_1");
        [_noDataImageView addSubview:image];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, 150, 30)];
        label.text= @"没有数据哦!";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17];
        label.dk_textColorPicker = kTextColorPicker;
        [_noDataImageView addSubview:label];
    }
    return _noDataImageView;
}

//使得tableview顶格
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}


- (void)cancelView:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 切换uuid
- (void)changeUUID:(NSString *)UUID
{
    NSDictionary *para = @{
                           @"UserID":thirdPartyLoginUserId,
                           @"UUID": UUID,
                           };
    ZZHAPIManager *client = [ZZHAPIManager sharedAPIManager];
    [client requestActiveMyDeviceParams:para andBlock:^(BaseModel *resultModel, NSError *error) {
        if ([resultModel.returnCode intValue]==200) {
            [self cancelView:nil];
//            [[NSNotificationCenter defaultCenter]postNotificationName:kUserChangeUUIDInCenterView object:nil];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
