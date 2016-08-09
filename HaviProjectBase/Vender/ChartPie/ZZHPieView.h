//
//  ZZHPieView.h
//  ChartView
//
//  Created by Havi on 16/8/8.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZHPieView : UIView

@property (nonatomic, retain) NSArray *chartValues;

- (void)reloadTableViewHeaderWith:(id)data withType:(SensorDataType)type;
- (void)reloadTableViewWith:(id)data withType:(SensorDataType)type;
@end
