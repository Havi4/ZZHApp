//
//  V2MenuSectionView.m
//  v2ex-iOS
//
//  Created by Singro on 3/30/14.
//  Copyright (c) 2014 Singro. All rights reserved.
//

#import "V2MenuSectionView.h"

//#import "SCActionSheet.h"
//#import "SCActionSheetButton.h"
#import "ScrollViewFrameAccessor.h"
#import "GetWeatherAPI.h"

#import "V2MenuSectionCell.h"
#import "DataAnTableViewCell.h"

static CGFloat const kAvatarHeight = 70.0f;

@interface V2MenuSectionView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *profileBackView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *profileBorderView;
@property (nonatomic, strong) UIButton    *avatarButton;
@property (nonatomic, strong) UIImageView *divideImageView;
@property (nonatomic, strong) UILabel     *usernameLabel;
@property (nonatomic, strong) UILabel     *userPhoneLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIView *weatherBackView;
@property (nonatomic, strong) UILabel *tem;
@property (nonatomic, strong) UILabel *city;
@property (nonatomic, strong) UIImageView *weatherImage;
@property (nonatomic, strong) UIImageView *locationImage;

//@property (nonatomic, strong) SCActionSheet      *actionSheet;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray     *sectionImageNameArray;
@property (nonatomic, strong) NSArray     *sectionTitleArray;

@end

@implementation V2MenuSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.sectionImageNameArray = @[@"shuju", @"fenxi", @"sheb", @"zhong", @"xinf", @"shed"];
//  @[@"icon_todays_data_0", @"icon_data_analysis_0", @"icon_equipment_management_0", @"icon_alarm_clock_0", @"icon_message", @"icon_setting_0"];
        self.sectionTitleArray = @[@"今日数据", @"数据分析", @"设备管理", @"睡眠设置", @"我的消息", @"设        定"];

        [self configureTableView];
        [self configureProfileView];
        [self configureNotifications];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{kBadgeKey:@0}];
        [[NSNotificationCenter defaultCenter]addObserverForName:kFriendRequestNoti object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self showFriendRequestNoti];
        }];
    }
    return self;
}

- (void)getWeather
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"city"] length]>0&&[[[NSUserDefaults standardUserDefaults]objectForKey:@"province"] length]>0) {
        NSDictionary *dic19 = @{
                                @"city" : [[NSUserDefaults standardUserDefaults]objectForKey:@"city"],
                                @"province": [[NSUserDefaults standardUserDefaults]objectForKey:@"province"]
                                };
        [GetWeatherAPI getWeatherInfoWith:dic19 finished:^(NSURLResponse *response, NSData *data) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kGetWeatherData object:nil userInfo:@{@"data":data}];
            
        } failed:^(NSURLResponse *response, NSError *error) {
            
        }];
    }
}
- (void)showFriendRequestNoti
{
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureTableView {
    
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.contentInsetTop = 170;
    [self addSubview:self.tableView];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    self.weatherBackView = [[UIView alloc]initWithFrame:CGRectZero];
    self.weatherBackView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.weatherBackView];
    
    _tem = [[UILabel alloc]init];
    self.weatherBackView.frame = CGRectZero;
    [self.weatherBackView addSubview:_tem];
    
    _city = [[UILabel alloc]init];
    self.weatherBackView.frame = CGRectZero;
    [self.weatherBackView addSubview:_city];
    
    _weatherImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.weatherBackView addSubview:_weatherImage];
    _locationImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.weatherBackView addSubview:_locationImage];
    
}

- (void)configureProfileView {
    
    
    self.profileBackView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"profile_back"]];
    [self addSubview:self.profileBackView];
    
    self.avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_placeholder"]];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 35; //kAvatarHeight / 2.0;
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImageView.layer.borderWidth = 0.0f;
    [self addSubview:self.avatarImageView];
    

    self.avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.avatarButton];
    
    self.divideImageView = [[UIImageView alloc] init];
    self.divideImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.divideImageView.image = [UIImage imageNamed:@"section_divide"];
    self.divideImageView.clipsToBounds = YES;
    [self addSubview:self.divideImageView];
    
    self.usernameLabel = [[UILabel alloc]init];
    self.usernameLabel.text = @"";
    self.usernameLabel.textAlignment = NSTextAlignmentCenter;
    self.usernameLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.usernameLabel];
    self.userPhoneLabel = [[UILabel alloc]init];
    self.userPhoneLabel.font = kDefaultWordFont;
    self.usernameLabel.font = kDefaultWordFont;
    self.userPhoneLabel.textAlignment = NSTextAlignmentCenter;
    self.userPhoneLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.userPhoneLabel];
    
    NSMutableString *userId = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@",thirdPartyLoginNickName]];
    NSString *name;
    if (userId.length == 0) {
        name = @"匿名用户";
    }else if ([userId intValue]>0){
        [userId replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        name = userId;
    }else{
        name = userId;
    }
    self.userPhoneLabel.text = name;
    // Handles
}

- (void)configureSearchView {
    
    
    
    
}

- (void)configureNotifications {
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",[NSObject baseURLStrIsTest] ? kAppTestBaseURL: kAppBaseURL,@"v1/file/DownloadFile/",thirdPartyLoginUserId];
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:@"iconImageChanged" object:nil queue:nil usingBlock:^(NSNotification *note) {
        @strongify(self);
        
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"head_placeholder"]];
        self.avatarImageView.layer.borderColor = [UIColor grayColor].CGColor;

    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"userName" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        NSDictionary *dic = note.userInfo;
        self.usernameLabel.text = [dic objectForKey:@"userName"];
    }];
//
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"head_placeholder"] options:YYWebImageOptionRefreshImageCache completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:kUserTapedDataReportButton object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self setSelectedIndex:1];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:kGetWeatherData object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSDictionary *dic = [note userInfo];
        NSData *weather = [dic objectForKey:@"data"];
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:weather options:NSJSONReadingMutableContainers error:nil];
        DeBugLog(@"天起字典是%@",weatherDic);
        self.tem.text = [[weatherDic objectForKey:@"Weather"] objectForKey:@"Temp"];
        self.city.text = [[weatherDic objectForKey:@"Weather"] objectForKey:@"City"];
        int weatherCode = [[[weatherDic objectForKey:@"Weather"] objectForKey:@"WeatherCode"] intValue];
        self.weatherImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"weather_%d",weatherCode]];
        self.locationImage.image = [UIImage imageNamed:@"location"];

    }];
    [self getWeather];

}

#pragma mark - Layout

- (void)layoutSubviews {
    
//    CGFloat spaceHeight = (self.tableView.contentInsetTop - kAvatarHeight) / 3.0;
    self.avatarImageView.frame = (CGRect){(280-70)/2, 30, kAvatarHeight, kAvatarHeight};
    self.profileBackView.frame = (CGRect){0,0,self.width,170};
    self.avatarButton.frame = self.avatarImageView.frame;
//    self.divideImageView.frame = (CGRect){80, kAvatarHeight + 50, 80, 0.5};
//    self.divideImageView.frame = (CGRect){-self.width, kAvatarHeight + 50, self.width * 2, 0.5};
    self.tableView.frame = (CGRect){0, 0, self.width, self.height};
    self.weatherBackView.frame = (CGRect){160, self.height-60, self.width-160, 60};
    self.tableView.showsVerticalScrollIndicator = NO;
    self.usernameLabel.frame = (CGRect){0,100,self.width,35};
    self.userPhoneLabel.frame = (CGRect){0,130,self.width,35};
    [self.avatarButton addTarget:self action:@selector(showProfile:) forControlEvents:UIControlEventTouchUpInside];
    self.tem.frame = (CGRect){50,24,100,20};
    self.tem.font = kNumberFont(17);
    self.city.frame = (CGRect){50,-16,100,40};
    self.city.font = kNumberFont(17);
    self.locationImage.frame = (CGRect){35,-1,10,10};
    self.weatherImage.frame = (CGRect){20,20,20,20};
    self.weatherImage.contentMode = UIViewContentModeScaleAspectFill;
    
    self.profileBorderView = [[UIView alloc] init];
    self.profileBorderView.layer.cornerRadius = 37;
    self.profileBorderView.backgroundColor = [UIColor clearColor];
    self.profileBorderView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
    self.profileBorderView.layer.borderWidth = 1.f;
    self.profileBorderView.frame = (CGRect)(CGRect){(280-70)/2-3, 27, kAvatarHeight+6, kAvatarHeight+6};
    self.profileBorderView.userInteractionEnabled = YES;
    [self addSubview:self.profileBorderView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id sender) {
        [self showProfile:nil];
    }];
    [self.profileBorderView addGestureRecognizer:tap];
//
}

- (void)showProfile:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kPostTapProfileImage object:nil];
    [self.tableView reloadData];
}

#pragma mark - Setters

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if (selectedIndex < self.sectionTitleArray.count) {
        _selectedIndex = selectedIndex;
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = - scrollView.contentOffsetY;
    
//    CGFloat spaceHeight = (self.tableView.contentInsetTop - kAvatarHeight) / 3.0;
    
    self.avatarImageView.y = 30 - (scrollView.contentInsetTop - offsetY) / 1.7;
    self.avatarButton.frame = self.avatarImageView.frame;

    self.divideImageView.y = self.avatarImageView.y + kAvatarHeight + (offsetY - (self.avatarImageView.y + kAvatarHeight)) / 2.0 + fabs(offsetY - self.tableView.contentInsetTop)/self.tableView.contentInsetTop * 8.0 + 10;
    self.profileBackView.frame = (CGRect){0,0,self.width,fabs(offsetY)};
    
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightCellForIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        static NSString *cell = @"cellData";
        DataAnTableViewCell *cell1 = (DataAnTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell];
        if (!cell1) {
            cell1 = [[DataAnTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.imageName = self.sectionImageNameArray[indexPath.row];
        cell1.title     = self.sectionTitleArray[indexPath.row];
        cell1.badge = nil;
        cell1.weekButton.selected = NO;
        cell1.monthButton.selected = NO;
        cell1.quaterButton.selected = NO;
        [cell1 resetCell];
        return cell1;
    }else{
        static NSString *CellIdentifier = @"CellIdentifier";
        V2MenuSectionCell *cell = (V2MenuSectionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[V2MenuSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row == 4) {
            NSInteger appBadage =  (int)[[NSUserDefaults standardUserDefaults] integerForKey:kBadgeKey];
            if (appBadage > 0) {
                cell.badge = [NSString stringWithFormat:@"%d",(int)appBadage];
            }
        }
        return [self configureWithCell:cell IndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != 1) {
        if (indexPath.row == 4) {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kBadgeKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.tableView reloadData];
            V2MenuSectionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.badge = @"0";
            
        }
        self.indexPath = indexPath;
        if (self.didSelectedIndexBlock) {
            self.didSelectedIndexBlock(indexPath.row);
        }
        [self.tableView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }else {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.indexPath.row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"tapcell" object:nil];
    }
}

#pragma mark - Configure TableCell

- (CGFloat)heightCellForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return [DataAnTableViewCell getCellHeight];
    }else{
    
        return [V2MenuSectionCell getCellHeight];
    }
    
}

- (V2MenuSectionCell *)configureWithCell:(V2MenuSectionCell *)cell IndexPath:(NSIndexPath *)indexPath {
    
    cell.imageName = self.sectionImageNameArray[indexPath.row];
    cell.title     = self.sectionTitleArray[indexPath.row];
//    if (indexPath.row == 5) {
//        if ([V2CheckInManager manager].isExpired && kSetting.checkInNotiticationOn) {
//            cell.badge = @"";
//        }
//    }
    
    return cell;
    
}


#pragma mark - Notifications

- (void)didReceiveThemeChangeNotification {
    
    [self.tableView reloadData];
//    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[V2SettingManager manager].selectedSectionIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
//    self.avatarImageView.alpha = kSetting.imageViewAlphaForCurrentTheme;
//    self.divideImageView.alpha = kSetting.imageViewAlphaForCurrentTheme;

}

- (void)didReceiveUpdateCheckInBadgeNotification {
    
    [self.tableView reloadData];
//    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.sectionTitleArray.count - 1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}

@end
