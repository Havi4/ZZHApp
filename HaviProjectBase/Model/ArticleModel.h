//
//  ArticleModel.h
//  HaviProjectBase
//
//  Created by Havi on 16/9/12.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "BaseModel.h"

@interface ArticleNewModel : NSObject

@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *tips;
@property (nonatomic, strong) NSString *systemDate;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *url;

@end

@interface ArticleModel : BaseModel

@property (nonatomic, strong) NSArray *articleNewsList;

@end
