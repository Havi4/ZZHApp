//
//  TagListModel.h
//  HaviModel
//
//  Created by Havi on 15/12/5.
//  Copyright © 2015年 Havi. All rights reserved.
//

#import "BaseModel.h"

@interface UserTag : NSObject

//"Tag": "运动健身",
//"TagType": "-1",  //-1:睡前，1:睡眠
//"At": "2015-03-19 16:34:10",
//"UserTagDate": "2015-03-15 23:54:49"
@property (strong, nonatomic) NSString *userTag;
@property (assign, nonatomic) int tagType;
@property (strong, nonatomic) NSDate *tagDate;
@property (strong, nonatomic) NSDate *userTagDate;

@end

@interface TagListModel : BaseModel

@property (strong, nonatomic) NSArray *tagList;

@end
