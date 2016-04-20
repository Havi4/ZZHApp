//
//  SmartLinkInstance.m
//  HaviProjectBase
//
//  Created by Havi on 16/4/20.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "SmartLinkInstance.h"
#import "HFSmtlkV30.h"

static HFSmtlkV30 *smtlk = nil;

@implementation SmartLinkInstance

+ (id)sharedManagerWithDelegate:(id)delegate
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        smtlk = [[HFSmtlkV30 alloc] initWithDelegate:delegate];
    });
    return smtlk;
}

@end
