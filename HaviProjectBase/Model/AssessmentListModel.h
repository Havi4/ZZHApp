//
//  AssessmentListModel.h
//  HaviProjectBase
//
//  Created by Havi on 16/3/1.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "BaseModel.h"

@interface AssessmentDetail : BaseModel

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *conclusion;
@property (nonatomic, strong) NSString *ndescription;
@property (nonatomic, strong) NSString *suggestion;

@end

@interface AssessmentListModel : BaseModel

@property (nonatomic, strong) NSArray *assessmentList;

@end
