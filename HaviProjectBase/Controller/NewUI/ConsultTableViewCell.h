//
//  ConsultTableViewCell.h
//  HaviProjectBase
//
//  Created by Havi on 16/9/11.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsultTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^tapTakePickerBlock)(NSMutableArray *selectedPhotos,NSMutableArray *selectedAssets);

@property (nonatomic, copy) void (^deleteRelodCollectionView)(NSMutableArray *selectedPhotos,NSMutableArray *selectedAssets);

@property (nonatomic, copy) void (^textViewData)(NSString *textString);

@property (nonatomic, copy) void (^tapPresentCollectionViewImage)(NSMutableArray *selectedPhotos,NSMutableArray *selectedAssets,NSIndexPath *index);

- (void)reloadCollectionViewWithImageArr:(NSMutableArray *)selectedPhotos selectedAssetsArr:(NSMutableArray *)selectedAssets;

@end
