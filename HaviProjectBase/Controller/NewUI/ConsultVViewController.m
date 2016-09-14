//
//  ConsultVViewController.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/11.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ConsultVViewController.h"
#import "ConsultTableViewCell.h"
#import "ConsultGenderTableViewCell.h"
#import "ConsultBirthTableViewCell.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "UIView+Layout.h"


@interface ConsultVViewController ()<TZImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;

}
@property (nonatomic, strong) UITableView *consultView;
@property (nonatomic, strong) SCBarButtonItem *leftBarItem;
@property (nonatomic, strong) UILabel *cellFooterView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, assign) NSInteger presentImageNumber;
@property (nonatomic, assign) NSInteger presentColumnNumber;

@end

@implementation ConsultVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initImagePickerPara];
    [self.view addSubview:self.consultView];
    [self initNavigationBar];
}

- (void)initImagePickerPara
{
    self.presentImageNumber = 9;
    self.presentColumnNumber = 4;//每行的照片
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
}


- (void)initNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.leftBarItem = [[SCBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_navi_back"] style:SCBarButtonItemStylePlain handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.sc_navigationItem.leftBarButtonItem = self.leftBarItem;

    self.sc_navigationItem.title = @"免费会诊";
}

#pragma mark imagePicker

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}


- (UITableView *)consultView
{
    if (!_consultView) {
        _consultView = [[UITableView alloc]initWithFrame:(CGRect){0,64,self.view.frame.size.width,self.view.frame.size.height-64} style:UITableViewStylePlain];
        _consultView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _consultView.delegate = self;
        _consultView.dataSource = self;
        _consultView.backgroundColor = [UIColor colorWithRed:0.933 green:0.937 blue:0.941 alpha:1.00];
    }
    return _consultView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            ConsultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
            if (!cell) {
                cell = [[ConsultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.tapTakePickerBlock = ^(NSMutableArray *selectedPhotos, NSMutableArray *selectedAssets){
                _selectedPhotos = selectedPhotos;
                _selectedAssets = selectedAssets;
                [self showImagePicker:0];
            };
            cell.deleteRelodCollectionView = ^(NSMutableArray *selectedPhotos, NSMutableArray *selectedAssets){
                _selectedPhotos = selectedPhotos;
                _selectedAssets = selectedAssets;
                [self.consultView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
            };
            cell.tapPresentCollectionViewImage = ^(NSMutableArray *selectedPhotos, NSMutableArray *selectedAssets,NSIndexPath *index){
                [self pushPresentImage:index];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell reloadCollectionViewWithImageArr:_selectedPhotos selectedAssetsArr:_selectedAssets];
            return cell;
            break;
        }
        case 1:{
            ConsultGenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell) {
                cell = [[ConsultGenderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            }
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            break;
            
        }
        case 2:{
            
            ConsultBirthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (!cell) {
                cell = [[ConsultBirthTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            }
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
            break;
        }
        case 3:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = (CGRect){8,0,kScreenSize.width-16,44};
            [button setBackgroundImage:[UIImage imageNamed:@"button_down_image@3x"] forState:UIControlStateNormal];
            [button setTitle:@"提交" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell addSubview:button];
            return cell;
            break;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:{
            int _margin = 4;
            int _itemWH = (self.view.tz_width - 2 * _margin - 4) / 4 - _margin;
            if (_selectedPhotos.count > 0 && _selectedPhotos.count <4) {
                return 60 + _itemWH+4;
            }else if (_selectedPhotos.count > 3 && _selectedPhotos.count <8){
                return 60 + 2 * _itemWH+8;
            }else if (_selectedPhotos.count > 7 && _selectedPhotos.count <10){
                return 60 + 3 * _itemWH+8;
            }else{
                return 60 + _itemWH + 44+4;
            }
            break;
        }
        case 1:{
            return 44;
            break;
        }
        case 2:{
            return 44;
            break;
        }
        case 3:{
            return 44;
            break;
        }
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        [backView addSubview:self.cellFooterView];
        backView.backgroundColor = [UIColor colorWithRed:0.933 green:0.937 blue:0.941 alpha:1.00];
        return backView;
    }else{
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        backView.backgroundColor = [UIColor colorWithRed:0.933 green:0.937 blue:0.941 alpha:1.00];
        return backView;
    }
}

- (UILabel *)cellFooterView
{
    if (!_cellFooterView) {
        _cellFooterView = [[UILabel alloc]init];
        _cellFooterView.text = @"详细描述您的病情、症状、治疗经过以及想要获得的帮助";
        _cellFooterView.frame = CGRectMake(15, 0, self.view.frame.size.width-30, 30);
        _cellFooterView.font = [UIFont systemFontOfSize:11];
        _cellFooterView.alpha = 0.4;
    }
    return _cellFooterView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark 弹出imagepicker

- (void)pushPresentImage:(NSIndexPath *)index
{
    id asset = _selectedAssets[index.row];
    BOOL isVideo = NO;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = asset;
        isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
#pragma clang diagnostic pop
    }
    if (isVideo) { // perview video / 预览视频
        TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
        TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
        vc.model = model;
        [self presentViewController:vc animated:YES completion:nil];
    } else { // preview photos / 预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:index.row];
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.isSelectOriginalPhoto = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            [self.consultView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }

}

- (void)showImagePicker:(NSInteger)index
{
    [self pushImagePickerController];
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    if (self.presentImageNumber <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.presentImageNumber columnNumber:self.presentColumnNumber delegate:self];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    if (self.presentImageNumber > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.navigationBar.barTintColor = [UIColor colorWithRed:0.176 green:0.173 blue:0.196 alpha:1.00];
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无权限 做一个友好的提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
#define push @#clang diagnostic pop
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) { // 如果保存失败，基本是没有相册权限导致的...
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法保存图片" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                alert.tag = 1;
                [alert show];
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [_selectedAssets addObject:assetModel.asset];
                        [_selectedPhotos addObject:image];
                        [self.consultView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
                    }];
                }];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
// - (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
// NSLog(@"cancel");
// }

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    [self.consultView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
//    _isSelectOriginalPhoto = isSelectOriginalPhoto;
//    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [self.consultView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
//    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
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
