//
//  XHPhotographyHelper.m
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHPhotographyHelper.h"
#import "XHMacro.h"
#import "SubImagePickerViewController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"


@interface XHPhotographyHelper () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, assign) NSInteger presentImageNumber;
@property (nonatomic, assign) NSInteger presentColumnNumber;

@property (nonatomic, copy) DidFinishTakeMediaCompledBlock didFinishTakeMediaCompled;

@end

@implementation XHPhotographyHelper

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    self.didFinishTakeMediaCompled = nil;
}

- (void)showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController compled:(DidFinishTakeMediaCompledBlock)compled {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        compled(nil, nil);
        return;
    }
    self.didFinishTakeMediaCompled = [compled copy];
    self.presentImageNumber = 1;
    self.presentColumnNumber = 4;//每行的照片

    if (self.presentImageNumber <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.presentImageNumber columnNumber:self.presentColumnNumber delegate:self];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    if (self.presentImageNumber > 1) {
        // 1.设置目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    [imagePickerVc.navigationBar setBackgroundColor:[UIColor colorWithRed:0.176 green:0.173 blue:0.196 alpha:1.00]];
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [viewController presentViewController:imagePickerVc animated:YES completion:nil];
//    UIImagePickerController *imagePickerController = [[SubImagePickerViewController alloc] init];
//    imagePickerController.editing = YES;
//    imagePickerController.delegate = self;
//    imagePickerController.sourceType = sourceType;
//    [imagePickerController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header_back"] forBarMetrics:UIBarMetricsDefault];
//    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
//        imagePickerController.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//    }
//    [viewController presentViewController:imagePickerController animated:YES completion:NULL];
}

//- (void)dismissPickerViewController:(UIImagePickerController *)picker {
//    WEAKSELF
//    [picker dismissViewControllerAnimated:YES completion:^{
//        weakSelf.didFinishTakeMediaCompled = nil;
//    }];
//}
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
//    if (self.didFinishTakeMediaCompled) {
//        self.didFinishTakeMediaCompled(image, editingInfo);
//    }
//    [self dismissPickerViewController:picker];
//}
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    if (self.didFinishTakeMediaCompled) {
//        self.didFinishTakeMediaCompled(nil, info);
//    }
//    [self dismissPickerViewController:picker];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [self dismissPickerViewController:picker];
//}

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
    if (self.didFinishTakeMediaCompled) {
        self.didFinishTakeMediaCompled([photos objectAtIndex:0], nil);
    }
//    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//    _selectedAssets = [NSMutableArray arrayWithArray:assets];
//    [self.consultView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    //    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    //    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
//    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
//    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
//    [self.consultView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    //    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}


@end
