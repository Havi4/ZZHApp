//
//  ReportDataDelegate.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/26.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "BaseTableViewDataDelegate.h"

@interface ReportDataDelegate : BaseTableViewDataDelegate

- (void)handleTableViewDataSourceAndDelegate:(UITableView *)tableView withReportType:(ReportViewType)type;


@end
