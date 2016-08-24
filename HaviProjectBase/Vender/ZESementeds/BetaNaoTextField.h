//
//  BetaNaoTextField.h
//  BWWalkthroughExample
//
//  Created by mukesh mandora on 24/07/15.
//  Copyright (c) 2015 Yari D'areglia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface BetaNaoTextField : UITextField<UITextFieldDelegate>

@property (nonatomic,strong) NSString *textPlaceHolder;

@property (nonatomic, copy) void (^returnBlock)(BetaNaoTextField *textField);

@property (nonatomic, strong) UIColor *textPlaceHolderColor;
@property (nonatomic, strong) UIColor *textLineColor;

- (void)reloadTextFieldWithTextString:(NSString *)string;

@end
