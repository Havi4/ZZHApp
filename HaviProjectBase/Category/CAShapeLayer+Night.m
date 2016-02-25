//
//  CAShapeLayer+Night.m
//  HaviProjectBase
//
//  Created by Havi on 16/2/24.
//  Copyright © 2016年 Havi. All rights reserved.
//

#import "CAShapeLayer+Night.h"
#import "DKNightVersionManager.h"
#import <objc/runtime.h>

@interface CAScrollLayer ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, DKPicker> *pickers;

@end

@implementation CAShapeLayer (Night)

- (void)setDk_storkeColorPicker:(DKColorPicker)dk_storkeColorPicker
{
    objc_setAssociatedObject(self, @selector(dk_onTintColorPicker), dk_storkeColorPicker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.strokeColor = dk_storkeColorPicker().CGColor;
    [self.dk_storkeColorPicker setValue:[dk_storkeColorPicker copy] forKey:@"setStrokeColor:"];
}

- (DKColorPicker)dk_storkeColorPicker {
    return objc_getAssociatedObject(self, @selector(dk_storkeColorPicker));
}

@end
