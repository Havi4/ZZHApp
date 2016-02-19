//
//  CellHeaderDefines.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/5.
//  Copyright © 2016年 Havi. All rights reserved.
//

#ifndef CellHeaderDefines_h
#define CellHeaderDefines_h

typedef void (^TableViewCellConfigureBlock)(NSIndexPath *indexPath, id item, UITableViewCell *cell);

typedef CGFloat (^CellHeightBlock)(NSIndexPath *indexPath, id item);

typedef void (^DidSelectCellBlock)(NSIndexPath *indexPath,id item);


#endif /* CellHeaderDefines_h */
