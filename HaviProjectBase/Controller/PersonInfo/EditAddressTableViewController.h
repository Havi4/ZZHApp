//
//  EditTableViewController.h
//  HaviProjectBase
//
//  Created by Havi on 16/7/25.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EditAddressTableViewController : BaseViewController
@property (nonatomic, copy) void (^saveButtonClicked)(NSUInteger index);


@property (nonatomic,strong) NSString *cellInfoType;
@property (nonatomic,strong) NSString *cellInfoString;
@end
