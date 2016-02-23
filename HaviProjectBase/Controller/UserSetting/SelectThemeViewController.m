//
//  SelectThemeViewController.m
//  SleepRecoding
//
//  Created by Havi_li on 15/3/28.
//  Copyright (c) 2015年 Havi. All rights reserved.
//

#import "SelectThemeViewController.h"
#import "SelectThemeCollectionViewCell.h"
#import "ThemeSelectConfigureObj.h"

@interface SelectThemeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_collectionV;
    NSArray *_arData;
}
@end

@implementation SelectThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    // Do any additional setup after loading the view.
    [self createNavWithTitle:@"换肤" createMenuItem:^UIView *(int nIndex)
     {
         if (nIndex == 1)
         {
             [self.leftButton addTarget:self action:@selector(backToHomeView:) forControlEvents:UIControlEventTouchUpInside];
             return self.leftButton;
         }
         return nil;
     }];
    [self setSubView];
}

- (void)setSubView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width-60)/2, (self.view.frame.size.height - 79 - 15 - 10)/2);
    flowLayout.minimumInteritemSpacing = 20;//列距
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 79, self.view.frame.size.width-40, self.view.frame.size.height - 64 - 10) collectionViewLayout:flowLayout];
    [_collectionV registerClass:[SelectThemeCollectionViewCell class] forCellWithReuseIdentifier:@"colletionCell"];
    _collectionV.backgroundColor = [UIColor clearColor];
    _collectionV.dataSource = self;
    _collectionV.delegate = self;
    [self.view addSubview:_collectionV];
    [self initData];
    [_collectionV reloadData];
}

- (void)initData
{
    _arData = @[@[@"默认", @"", @"skinpeeler_tint_bg"],
                @[@"浅蓝", @"com.skin.1110", @"skinpeeler_dark_color_bg"],
                ];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_arData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdetify = @"colletionCell";
    SelectThemeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
    [cell setDataForView:[_arData objectAtIndex:indexPath.row] index:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [ThemeSelectConfigureObj defaultConfigure].nThemeIndex = (int)indexPath.row;
    [_collectionV reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadAppTheme object:nil];
}

- (void)backToHomeView:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadThemeImage
{
//    [super reloadThemeImage];
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
