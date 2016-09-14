//
//  ConsultTableViewCell.m
//  HaviProjectBase
//
//  Created by Havi on 16/9/11.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "ConsultTableViewCell.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"
#import "UIView+Layout.h"

@interface ConsultTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    CGFloat _itemWH;
    CGFloat _margin;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;

}
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UILabel *pictureLabel;
@property (nonatomic, strong) UIButton *takePictureIcon;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *pickerBackView;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ConsultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_selectedAssets) {
            _selectedAssets = [NSMutableArray array];
        }
        if (!_selectedPhotos) {
            _selectedPhotos = [NSMutableArray array];
        }
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [UIImage imageNamed:@"wenzhen"];
        _backImageView.userInteractionEnabled = YES;
        [self addSubview:_backImageView];
        [_backImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.right.equalTo(self.mas_right).offset(-8);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        _pickerBackView = [[UIView alloc]init];
        _pickerBackView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPicker:)];
        _pickerBackView.userInteractionEnabled = YES;
        [_pickerBackView addGestureRecognizer:gesture];
        [_backImageView addSubview:_pickerBackView];
        [_pickerBackView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backImageView.mas_left);
            make.right.equalTo(_backImageView.mas_right);
            make.bottom.equalTo(_backImageView.mas_bottom);
            make.height.equalTo(@44);
        }];
        
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = [UIColor lightGrayColor];
        [_pickerBackView addSubview:_lineLabel];
        [_lineLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backImageView.mas_left);
            make.right.equalTo(_backImageView.mas_right);
            make.height.equalTo(@0.5);
            make.top.equalTo(_pickerBackView.mas_top).offset(0);
        }];
        
        _pictureLabel = [[UILabel alloc]init];
        _pictureLabel.text = @"上传病历或者患者部位照片";
        _pictureLabel.textColor = [UIColor lightGrayColor];
        _pictureLabel.font = kTextPlaceHolderFont;
        [_pickerBackView addSubview:_pictureLabel];
        [_pictureLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backImageView.mas_left).offset(8);
            make.centerY.equalTo(_pickerBackView.mas_centerY);
        }];
        
        _takePictureIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takePictureIcon setBackgroundImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
        [_pickerBackView addSubview:_takePictureIcon];
        [_takePictureIcon makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_backImageView.mas_right).offset(-8);
            make.centerY.equalTo(_pictureLabel.mas_centerY);
            make.height.equalTo(@14);
            make.width.equalTo(@18);
        }];
        
        _textView = [[UITextView alloc]init];
        [_backImageView addSubview:_textView];
        [_textView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backImageView.mas_left).offset(8);
            make.right.equalTo(_backImageView.mas_right).offset(-8);
            make.top.equalTo(_backImageView.mas_top).offset(1.5);
            make.height.equalTo(@60);
        }];
        _textView.text = @"请输入50-200个字";
        _textView.textColor = [UIColor grayColor];
        
        [self configCollectionView];
    }
    return self;
}

- (void)tapPicker:(UIGestureRecognizer*)gesture
{
    self.tapTakePickerBlock(_selectedPhotos,_selectedAssets);
}

- (void)reloadCollectionViewWithImageArr:(NSMutableArray *)selectedPhotos selectedAssetsArr:(NSMutableArray *)selectedAssets
{
    _selectedPhotos = [NSMutableArray arrayWithArray:selectedPhotos];
    _selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
    if (_selectedPhotos.count > 0) {
        self.pickerBackView.hidden = YES;
    }else{
        self.pickerBackView.hidden = NO;
    }
    if (_selectedPhotos.count > -1 && _selectedPhotos.count <4) {
        _collectionView.frame = CGRectMake(8, 60, self.tz_width-16, _itemWH+8);
    }else if (_selectedPhotos.count > 3 && _selectedPhotos.count <8){
        _collectionView.frame = CGRectMake(8, 60, self.tz_width-16, 2*_itemWH+8);
    }else if (_selectedPhotos.count > 7 && _selectedPhotos.count <10){
        _collectionView.frame = CGRectMake(8, 60, self.tz_width-16, 3*_itemWH+12);
    }
    [_collectionView reloadData];
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 4;
    _itemWH = (self.tz_width-16 - 2 * _margin - 4) / 4 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8, 60, self.tz_width-16, _itemWH+8) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _collectionView.scrollEnabled = NO;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count < 9) {
        return _selectedPhotos.count + 1;
    }else{
        return _selectedPhotos.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    //    [_collectionView performBatchUpdates:^{
    //        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    //        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    //    } completion:^(BOOL finished) {
    //    }];
    [_collectionView reloadData];
    self.deleteRelodCollectionView(_selectedPhotos,_selectedAssets);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        self.tapTakePickerBlock(_selectedPhotos,_selectedAssets);
//        BOOL showSheet = self.showSheetSwitch.isOn;
//        if (showSheet) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
//#pragma clang diagnostic pop
//            [sheet showInView:self.view];
//        } else {
//            [self pushImagePickerController];
//        }
    } else { // preview photos or video / 预览照片或者视频
//        id asset = _selectedAssets[indexPath.row];
//        BOOL isVideo = NO;
//        if ([asset isKindOfClass:[PHAsset class]]) {
//            PHAsset *phAsset = asset;
//            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//        } else if ([asset isKindOfClass:[ALAsset class]]) {
//            ALAsset *alAsset = asset;
//            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
//#pragma clang diagnostic pop
//        }
//        if (isVideo) { // perview video / 预览视频
//            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
//            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
//            vc.model = model;
//            [self presentViewController:vc animated:YES completion:nil];
//        } else { // preview photos / 预览照片
//            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
//            imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch.isOn;
//            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
//            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//                _selectedAssets = [NSMutableArray arrayWithArray:assets];
//                _isSelectOriginalPhoto = isSelectOriginalPhoto;
//                [_collectionView reloadData];
//                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
//            }];
//            [self presentViewController:imagePickerVc animated:YES completion:nil];
//        }
        self.tapPresentCollectionViewImage(_selectedPhotos,_selectedAssets,indexPath);
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
