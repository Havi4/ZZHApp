//
//  ViewController.m
//  CoolNavi
//
//  Created by ian on 15/1/19.
//  Copyright (c) 2015年 ian. All rights reserved.
//
#define kWindowHeight 205.0f
#import "PersonManagerViewController.h"
#import "PersonInfoNaviView.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PersonDataDelegate.h"
#import "PersonInfoTableViewCell.h"
#import "UserInfoDetailModel.h"
#import "EditCellInfoViewController.h"
#import "JDStatusBarNotification.h"
#import "ImageUtil.h"
#import "RMDateSelectionViewController.h"
#import "RMPickerViewController.h"
#import "ODRefreshControl.h"
#import "ProfileTableViewCell.h"
#import "EditAddressTableViewController.h"
#import "AppDelegate.h"
#import "APPSettingViewController.h"

@interface PersonManagerViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UITableView *personInfoTableView;
@property (nonatomic, strong) PersonInfoNaviView *headerView;
@property (nonatomic, strong) PersonDataDelegate *personDataDelegate;
@property (nonatomic, strong) UserInfoDetailModel *userInfoModel;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) ProfileTableViewCell *profileCell;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;

@property (nonatomic, strong) NSArray *genderArray;
@property (nonatomic, strong) NSArray *weightArray;
@property (nonatomic, strong) NSArray *heightArray;

@end

@implementation PersonManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserDetailInfo];
    [self addSubViews];
    [self addTableViewDataHandle];
    //
}

- (void)addSubViews
{
    [self.view addSubview:self.personInfoTableView];
    UIView *view = [[UIView alloc]initWithFrame:(CGRect){0,0,self.view.frame.size.width,0}];
    [self.view addSubview:view];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSArray *controllers = app.currentNavigationController.viewControllers;
    UIViewController *con = [controllers objectAtIndex:0];
    if ([con isKindOfClass:[APPSettingViewController class]]) {
        self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_menu"] style:SCBarButtonItemStylePlain handler:^(id sender) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowMenuNotification object:nil];
        }];
    }
    
    self.sc_navigationItem.title = @"个人资料";
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;
}

- (void)addTableViewDataHandle
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    [self.personInfoTableView addSubview:self.refreshControl];
    TableViewCellConfigureBlock configureCellBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell){
        if (indexPath.section ==0) {
            [self configProfileWithCell:cell];
        }else{
            if (self.userInfoModel) {
                [cell configure:cell customObj:item indexPath:indexPath withOtherInfo:self.userInfoModel];
            }else{
                [cell configure:cell customObj:item indexPath:indexPath];
            }
        }
        
    };
    CellHeightBlock configureCellHeightBlock = ^ CGFloat (NSIndexPath *indexPath, id item){
        return [PersonInfoTableViewCell getCellHeightWithCustomObj:item indexPath:indexPath withOtherObj:self.userInfoModel];
    };
    @weakify(self);
    DidSelectCellBlock didSelectBlock = ^(NSIndexPath *indexPath, id item){
        @strongify(self);
        [self didSeletedCellIndexPath:indexPath withData:item];
    };
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"PersonInfoPlist" ofType:@"plist"];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:dataPath];
    self.personDataDelegate = [[PersonDataDelegate alloc]initWithItems:dataArr cellIdentifier:@"cell" configureCellBlock:configureCellBlock cellHeightBlock:configureCellHeightBlock didSelectBlock:didSelectBlock];
    [self.personDataDelegate handleTableViewDataSourceAndDelegate:self.personInfoTableView];
}

- (void)configProfileWithCell:(UITableViewCell *)cell
{
    self.profileCell = (ProfileTableViewCell*)cell;
    NSString *iconUrl = thirdPartyLoginIcon.length == 0?[NSString stringWithFormat:@"%@%@%@",kAppBaseURL,@"v1/file/DownloadFile/",thirdPartyLoginUserId]:thirdPartyLoginIcon;
    [_profileCell.userIcon setImageWithURL:[NSURL URLWithString:iconUrl] placeholder:[UIImage imageNamed:[NSString stringWithFormat:@"head_placeholder"]]];
    
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
    _profileCell.userLabel.text = name;
}

- (void)refreshAction{
    [self getUserDetailInfo];
}

#pragma mark get user info

- (void)getUserDetailInfo
{
    NSDictionary *userIdDic = @{
                           @"UserID":thirdPartyLoginUserId,
                           };
    ZZHAPIManager *apiManager = [ZZHAPIManager sharedAPIManager];
    [apiManager requestUserInfoWithParam:userIdDic andBlock:^(UserInfoDetailModel *userInfo, NSError *error) {
        [self.refreshControl endRefreshing];
        self.userInfoModel = userInfo;
        [self.personInfoTableView reloadData];
    }];
}

- (void)saveUserInfoWithKey:(NSString *)key andData:(NSString *)data
{
    if (data.length == 0) {
        [NSObject showHudTipStr:@"保存内容为空"];
        return;
    }
    [[UIApplication sharedApplication]incrementNetworkActivityCount];
    //
    NSDictionary *dic = @{
                          @"UserID": thirdPartyLoginUserId, //关键字，必须传递
                          key:data,
                          };
    ZZHAPIManager *manager = [ZZHAPIManager sharedAPIManager];
    [manager requestChangeUserInfoParam:dic andBlock:^(BaseModel *resultModel, NSError *error) {
        DeBugLog(@"更新%@",resultModel.errorMessage);
        [self getUserDetailInfo];
        [[UIApplication sharedApplication]decrementNetworkActivityCount];
    }];
}


#pragma mark setter
- (UITableView *)personInfoTableView
{
    if (!_personInfoTableView) {
        _personInfoTableView = [[UITableView alloc]initWithFrame:(CGRect){0,44,self.view.frame.size.width,self.view.frame.size.height-44} style:UITableViewStyleGrouped];
        _personInfoTableView.backgroundColor = KTableViewBackGroundColor;
    }
    return _personInfoTableView;
}

//获取用户基本信息
- (void)didSeletedCellIndexPath:(NSIndexPath *)indexPath withData:(id)data
{
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            [self openDateSelectionController:nil];
        }else if (indexPath.row == 2){
            [self openPickerController:@"gender"];
        }else{
            EditCellInfoViewController *cellInfo = [[EditCellInfoViewController alloc]init];
            cellInfo.saveButtonClicked = ^(NSUInteger index) {
                [self getUserDetailInfo];
            };
            
            if(indexPath.row==0){
                cellInfo.cellInfoType = @"UserName";
                cellInfo.cellTextString = self.userInfoModel.nUserInfo.userName;
                [self.navigationController pushViewController:cellInfo animated:YES];
            }else if (indexPath.row==3){
                cellInfo.cellInfoType = @"EmergencyContact";
                cellInfo.cellTextString = self.userInfoModel.nUserInfo.emergencyContact;
                [self.navigationController pushViewController:cellInfo animated:YES];
            }else if (indexPath.row==4){
                cellInfo.cellInfoType = @"Telephone";
                cellInfo.cellTextString = self.userInfoModel.nUserInfo.telephone;
                [self.navigationController pushViewController:cellInfo animated:YES];
            }
        }
        
    }else if(indexPath.section == 2){
        if (indexPath.row == 2) {
            EditAddressTableViewController *cell = [[EditAddressTableViewController alloc] init];
            cell.cellInfoType = @"Address";
            if (self.userInfoModel.nUserInfo.address.length > 0) {
                cell.cellInfoString = self.userInfoModel.nUserInfo.address;
            }
            cell.saveButtonClicked = ^(NSUInteger index) {
                [self getUserDetailInfo];
            };
            
            [self.navigationController pushViewController:cell animated:YES];
        }else if(indexPath.row == 0){
            [self openPickerController:@"height"];
        }else if (indexPath.row == 1){
            [self openPickerController:@"weight"];
        }
    }else{
        if (thirdPartyLoginIcon.length == 0) {
            [self tapIconImage:nil];
        }

    }
}

- (void)openDateSelectionController:(id)sender {
    //Create select action
    RMAction *selectAction = [RMAction actionWithTitle:@"确认" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSString *date = [[NSString stringWithFormat:@"%@",((UIDatePicker *)controller.contentView).date]substringToIndex:10];
        if ([((UIDatePicker *)controller.contentView).date isLaterThan:[NSDate date]]) {
            [NSObject showHudTipStr:@"请选择正确的生日"];
            return;
        }
        [[NSUserDefaults standardUserDefaults]setObject:((UIDatePicker *)controller.contentView).date forKey:@"userBirthday"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self saveUserInfoWithKey:@"Birthday" andData:date];
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite];
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    //Create date selection view controller
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userBirthday"]) {
        dateSelectionController.datePicker.date = [[NSUserDefaults standardUserDefaults]objectForKey:@"userBirthday"];
    }
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void)openPickerController:(NSString *)type {
    //Create select action
    RMAction *selectAction = [RMAction actionWithTitle:@"确认" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        UIPickerView *picker = ((RMPickerViewController *)controller).picker;
        NSMutableArray *selectedRows = [NSMutableArray array];
        
        for(NSInteger i=0 ; i<[picker numberOfComponents] ; i++) {
            [selectedRows addObject:@([picker selectedRowInComponent:i])];
        }
        int index = [[selectedRows objectAtIndex:0] intValue];
        if (picker.tag == 101) {
            [self saveUserInfoWithKey:@"Gender" andData:[self.genderArray objectAtIndex:index]];
        }else if (picker.tag == 102){
            [self saveUserInfoWithKey:@"Weight" andData:[self.genderArray objectAtIndex:index]];
        }else if (picker.tag == 103){
            [self saveUserInfoWithKey:@"Height" andData:[self.genderArray objectAtIndex:index]];
        }
        
    }];
    
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Row selection was canceled");
    }];
    
    //Create picker view controller
    RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:RMActionControllerStyleWhite];
    [pickerController addAction:cancelAction];
    [pickerController addAction:selectAction];
    pickerController.picker.delegate = self;
    pickerController.picker.dataSource = self;
    if ([type isEqualToString:@"gender"]) {
        pickerController.picker.tag = 101;
        self.genderArray = @[@"男",@"女"];
        if(self.userInfoModel.nUserInfo.gender.length > 0){
            NSUInteger index = [self.genderArray indexOfObject:self.userInfoModel.nUserInfo.gender];
            [pickerController.picker selectRow:index inComponent:0 animated:NO];
        }
    }else if ([type isEqualToString:@"weight"]){
        pickerController.picker.tag = 102;
        self.genderArray = @[@"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",@"81",@"82",@"83",@"84",@"85"];
        if(self.userInfoModel.nUserInfo.weight.length > 0){
            if ([self.genderArray containsObject:self.userInfoModel.nUserInfo.weight]) {
                NSUInteger index = [self.genderArray indexOfObject:[NSString stringWithFormat:@"%d",[self.userInfoModel.nUserInfo.weight intValue]]];
                [pickerController.picker selectRow:index inComponent:0 animated:NO];
            }
        }
    }else if ([type isEqualToString:@"height"]){
        pickerController.picker.tag = 103;
        self.genderArray = @[@"160",@"161",@"162",@"163",@"164",@"165",@"166",@"167",@"168",@"169",@"170",@"171",@"172",@"173",@"174",@"175",@"176",@"177",@"178",@"179",@"180",@"181"];
        if(self.userInfoModel.nUserInfo.height.length > 0){
            if ([self.genderArray containsObject:self.userInfoModel.nUserInfo.height]) {
                NSUInteger index = [self.genderArray indexOfObject:[NSString stringWithFormat:@"%d",[self.userInfoModel.nUserInfo.height intValue]]];
                [pickerController.picker selectRow:index inComponent:0 animated:NO];
            }
        }
    }
    
    //Now just present the picker controller using the standard iOS presentation method
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark picker delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.genderArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",[self.genderArray objectAtIndex:row]];
}
#pragma mark 拍照
- (void)tapIconImage:(UIGestureRecognizer *)gesture
{
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        
    }
    
    sheet.tag = 255;
    
    CGRect rect = self.view.frame;
    //在这里解决了ios7中弹出照相机错误
    [sheet showFromRect:rect inView:[UIApplication sharedApplication].keyWindow animated:YES];
}

#pragma mark actionSheet代理

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 2:
                    // 取消
                    return;
                case 0:{
                    // 相机
                    NSString *mediaType = AVMediaTypeVideo;
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                    }else{
                        sourceType = UIImagePickerControllerSourceTypeCamera;
                        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                        imagePickerController.mediaTypes = @[(NSString*) kUTTypeImage];
                        imagePickerController.delegate = self;
                        imagePickerController.allowsEditing = YES;
                        imagePickerController.sourceType = sourceType;
                        [self presentViewController:imagePickerController animated:YES completion:^{}];
                    }
                    
                    break;
                }
                    
                case 1:{
                    // 相册
                    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
                    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
                        //无权限
                    }else{
                        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                        imagePickerController.mediaTypes = @[(NSString*) kUTTypeImage];
                        imagePickerController.delegate = self;
                        imagePickerController.allowsEditing = YES;
                        imagePickerController.sourceType = sourceType;
                        [self presentViewController:imagePickerController animated:YES completion:^{
                        }];
                    }
                    break;
                }
            }
        }
        else {
            if (buttonIndex == 1) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.mediaTypes = @[(NSString*) kUTTypeImage];
                imagePickerController.delegate = self;
                
                imagePickerController.allowsEditing = YES;
                
                imagePickerController.sourceType = sourceType;
                
                [self presentViewController:imagePickerController animated:YES completion:^{}];
                
            }
        }
        // 跳转到相机或相册页面
        
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [self calculateIconImage:image];
        [self uploadWithImageData:imageData];
    });
    
    [self setNeedsStatusBarAppearanceUpdate];
}

#define UploadImageSize          100000
- (NSData *)calculateIconImage:(UIImage *)image
{
    if(image){
        
        [image fixOrientation];
        CGFloat height = image.size.height;
        CGFloat width = image.size.width;
        NSData *data = UIImageJPEGRepresentation(image,1);
        
        float n;
        n = (float)UploadImageSize/data.length;
        data = UIImageJPEGRepresentation(image, n);
        while (data.length > UploadImageSize) {
            image = [UIImage imageWithData:data];
            height /= 2;
            width /= 2;
            image = [image scaleToSize:CGSizeMake(width, height)];
            data = UIImageJPEGRepresentation(image,1);
        }
        return data;
        
    }
    return nil;
}

#pragma mark 上传头像
- (void)uploadWithImageData:(NSData*)imageData
{
    NSDictionary *dicHeader = @{
                                @"AccessToken": @"123456789",
                                };
    NSString *urlStr = [NSString stringWithFormat:@"%@v1/file/UploadFile/%@",kAppBaseURL,thirdPartyLoginUserId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:0 timeoutInterval:5.0f];
    [request setValue:[dicHeader objectForKey:@"AccessToken"] forHTTPHeaderField:@"AccessToken"];
    [self setRequest:request withImageData:imageData];
    DeBugLog(@"开始上传...");
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"ReturnCode"] intValue]==200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [JDStatusBarNotification showWithStatus:@"头像上传成功" dismissAfter:2 styleName:JDStatusBarStyleDark];
                NSString *url = [NSString stringWithFormat:@"%@%@%@",kAppBaseURL,@"v1/file/DownloadFile/",thirdPartyLoginUserId];
                [self.profileCell.userIcon setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:[NSString stringWithFormat:@"head_portrait_%d",0]] options:YYWebImageOptionRefreshImageCache completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"iconImageChanged" object:nil];
                }];
                
            });
        }
        DeBugLog(@"8.18测试结果Result--%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
    }];
}

- (void)setRequest:(NSMutableURLRequest *)request withImageData:(NSData*)imageData
{
    NSMutableData *body = [NSMutableData data];
    // 表单数据
    
    /// 图片数据部分
    NSMutableString *topStr = [NSMutableString string];
    [body appendData:[topStr dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // 设置请求类型为post请求
    request.HTTPMethod = @"post";
    // 设置request的请求体
    request.HTTPBody = body;
    // 设置头部数据，标明上传数据总大小，用于服务器接收校验
    [request setValue:[NSString stringWithFormat:@"%ld", body.length] forHTTPHeaderField:@"Content-Length"];
    // 设置头部数据，指定了http post请求的编码方式为multipart/form-data（上传文件必须用这个）。
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; image/png"] forHTTPHeaderField:@"Content-Type"];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
