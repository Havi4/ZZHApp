//
//  THPinView.m
//  THPinViewControllerExample
//
//  Created by Thomas Heß on 21.4.14.
//  Copyright (c) 2014 Thomas Heß. All rights reserved.
//

#import "THPinView.h"
#import "THPinInputCirclesView.h"
#import "THPinNumPadView.h"
#import "THPinNumButton.h"
#import "GetInavlideCodeApi.h"
#import "MMPopupItem.h"

@interface THPinView () <THPinNumPadViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) THPinInputCirclesView *inputCirclesView;
@property (nonatomic, strong) THPinNumPadView *numPadView;
@property (nonatomic, strong) UIButton *bottomButton;
//havi
@property (nonatomic, strong) UIButton *bottomLeftButton;

@property (nonatomic, assign) CGFloat paddingBetweenPromptLabelAndInputCircles;
@property (nonatomic, assign) CGFloat paddingBetweenInputCirclesAndNumPad;
@property (nonatomic, assign) CGFloat paddingBetweenNumPadAndBottomButton;

@property (nonatomic, strong) NSMutableString *input;

@end

@implementation THPinView

- (instancetype)initWithDelegate:(id<THPinViewDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        _delegate = delegate;
        _input = [NSMutableString string];
        
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont systemFontOfSize:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 22.0f : 18.0f];
        [_promptLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel
                                                      forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:_promptLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[promptLabel]|" options:0 metrics:nil
                                                                       views:@{ @"promptLabel" : _promptLabel }]];
        
        _inputCirclesView = [[THPinInputCirclesView alloc] initWithPinLength:[_delegate pinLengthForPinView:self]];
        _inputCirclesView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_inputCirclesView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_inputCirclesView attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f constant:0.0f]];
        
        _numPadView = [[THPinNumPadView alloc] initWithDelegate:self];
        _numPadView.translatesAutoresizingMaskIntoConstraints = NO;
        _numPadView.backgroundColor = self.backgroundColor;
        [self addSubview:_numPadView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_numPadView attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f constant:0.0f]];
        
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _bottomButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_bottomButton setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel
                                                       forAxis:UILayoutConstraintAxisHorizontal];
        [self updateBottomButton];
        _bottomButton.hidden = YES;
        [self addSubview:_bottomButton];
        //havi
        _bottomLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomLeftButton.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomLeftButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _bottomLeftButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_bottomLeftButton setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel
                                                       forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:_bottomLeftButton];
        [_bottomLeftButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_bottomButton.mas_centerY);
            int hei = [THPinNumButton diameter] / 2.0f;
            make.centerX.equalTo(self.mas_left).offset(hei);
        }];
        [_bottomLeftButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_bottomLeftButton addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
        //haviend
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // place button right of zero number button
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeRight
                                                            multiplier:1.0f constant:-[THPinNumButton diameter] / 2.0f]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0f constant:-[THPinNumButton diameter] / 2.0f]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:0
                                                            multiplier:0.0f constant:[THPinNumButton diameter]]];
        } else {
            // place button beneath the num pad on the right
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeRight
                                                            multiplier:1.0f constant:0.0f]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:_bottomButton attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationLessThanOrEqual
                                                                toItem:self attribute:NSLayoutAttributeWidth
                                                            multiplier:0.4f constant:0.0f]];
        }
        
        NSMutableString *vFormat = [NSMutableString stringWithString:@"V:|[promptLabel]-(paddingBetweenPromptLabelAndInputCircles)-[inputCirclesView]-(paddingBetweenInputCirclesAndNumPad)-[numPadView]"];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _paddingBetweenPromptLabelAndInputCircles = 22.0f;
            _paddingBetweenInputCirclesAndNumPad = 52.0f;
        } else {
            [vFormat appendString:@"-(paddingBetweenNumPadAndBottomButton)-[bottomButton]"];
            BOOL isFourInchScreen = (fabs(CGRectGetHeight([[UIScreen mainScreen] bounds]) - 568.0f) < DBL_EPSILON);
            if (isFourInchScreen) {
                _paddingBetweenPromptLabelAndInputCircles = 22.5f;
                _paddingBetweenInputCirclesAndNumPad = 41.5f;
                _paddingBetweenNumPadAndBottomButton = 19.0f;
            } else {
                _paddingBetweenPromptLabelAndInputCircles = 15.5f;
                _paddingBetweenInputCirclesAndNumPad = 14.0f;
                _paddingBetweenNumPadAndBottomButton = -7.5f;
            }
        }
        [vFormat appendString:@"|"];
        
        NSDictionary *metrics = @{ @"paddingBetweenPromptLabelAndInputCircles" : @(_paddingBetweenPromptLabelAndInputCircles),
                                   @"paddingBetweenInputCirclesAndNumPad" : @(_paddingBetweenInputCirclesAndNumPad),
                                   @"paddingBetweenNumPadAndBottomButton" : @(_paddingBetweenNumPadAndBottomButton) };
        NSDictionary *views = @{ @"promptLabel" : _promptLabel,
                                 @"inputCirclesView" : _inputCirclesView,
                                 @"numPadView" : _numPadView,
                                 @"bottomButton" : _bottomButton };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vFormat options:0 metrics:metrics views:views]];
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    CGFloat height = (self.promptLabel.intrinsicContentSize.height + self.paddingBetweenPromptLabelAndInputCircles +
                      self.inputCirclesView.intrinsicContentSize.height + self.paddingBetweenInputCirclesAndNumPad +
                      self.numPadView.intrinsicContentSize.height);
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        height += self.paddingBetweenNumPadAndBottomButton + self.bottomButton.intrinsicContentSize.height;
    }
    return CGSizeMake(self.numPadView.intrinsicContentSize.width, height);
}

#pragma mark - Properties

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.numPadView.backgroundColor = self.backgroundColor;
}

- (NSString *)promptTitle
{
    return self.promptLabel.text;
}

- (void)setPromptTitle:(NSString *)promptTitle
{
    self.promptLabel.text = promptTitle;
}

- (UIColor *)promptColor
{
    return self.promptLabel.textColor;
}

- (void)setPromptColor:(UIColor *)promptColor
{
    self.promptLabel.textColor = promptColor;
}

- (BOOL)hideLetters
{
    return self.numPadView.hideLetters;
}

- (void)setHideLetters:(BOOL)hideLetters
{
    self.numPadView.hideLetters = hideLetters;
}

- (void)setDisableCancel:(BOOL)disableCancel
{
    if (self.disableCancel == disableCancel) {
        return;
    }
    _disableCancel = disableCancel;
    [self updateBottomButton];
}

#pragma mark - Public

- (void)updateBottomButton
{
//    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"THPinViewController"
//                                                                                ofType:@"bundle"]];
    if ([self.input length] == 0) {
        [self.bottomButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.bottomButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        self.bottomButton.hidden = YES;
//        [self.bottomButton removeTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];防止取消
    } else {
        [self.bottomButton setTitle:@"删除"forState:UIControlStateNormal];
        self.bottomButton.hidden = NO;
//        NSLocalizedStringFromTableInBundle(@"delete_button_title", @"THPinViewController",
//                                           bundle, nil)
//        [self.bottomButton removeTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - User Interaction

- (void)forgetPassword:(UIButton *)sender
{
    MMPopupItemHandler block = ^(NSInteger index){
        DeBugLog(@"clickd %@ button",@(index));
        if (index == 1) {
            [self getUserDetailInfo];
        }
    };
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, block),MMItemMake(@"确定", MMItemTypeNormal, block)];
    MMAlertView *alert = [[MMAlertView alloc]initWithTitle:@"提示" detail:@"锁屏密码会重置并发送到该帐号关联的手机号上,请注意查收" items:items];
    [alert show];
}

- (void)getUserDetailInfo
{
    NSDictionary *userIdDic = @{
                                @"UserID":thirdPartyLoginUserId,
                                };
    ZZHAPIManager *apiManager = [ZZHAPIManager sharedAPIManager];
    [apiManager requestUserInfoWithParam:userIdDic andBlock:^(UserInfoDetailModel *userInfo, NSError *error) {
        
        if ([userInfo.nUserInfo.cellPhone intValue]>0) {
            [self getPassWordSelf:userInfo.nUserInfo.cellPhone];
        }else if([userInfo.nUserInfo.userIdOriginal intValue]>0){
            [self getPassWordSelf:userInfo.nUserInfo.userIdOriginal];
        }else if ([userInfo.nUserInfo.telephone intValue]>0){
            [self getPassWordSelf:userInfo.nUserInfo.telephone];
        }
        
    }];
}

- (void)getPassWordSelf:(NSString *)cellPhone
{
    int forgetPassWord = [self getRandomNumber:1000 to:9999];
    NSString *codeMessage = [NSString stringWithFormat:@"您的锁屏密码已经重置，新的锁屏密码是%d,请及时修改您的密码。",forgetPassWord];
    NSDictionary *dicPara = @{
                              @"cell" : cellPhone,
                              @"codeMessage" : codeMessage,
                              };
    GetInavlideCodeApi *client = [GetInavlideCodeApi shareInstance];
    [client getInvalideCode:dicPara witchBlock:^(NSData *receiveData) {
        NSString *string = [[NSString alloc]initWithData:receiveData encoding:NSUTF8StringEncoding];
        NSRange range = [string rangeOfString:@"<error>"];
        if ([[string substringFromIndex:range.location +range.length]intValue]==0) {
            [NSObject showHudTipStr:@"发送成功"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",forgetPassWord] forKey:kAppPassWordKeyNoti];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else{
            [NSObject showHudTipStr:@"短信运营商出错啦"];
        }
    }];
    
}

-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (void)cancel:(id)sender
{
    [self.delegate cancelButtonTappedInPinView:self];
}

- (void)delete:(id)sender
{
   
    if (self.input.length == 1) {
        _bottomButton.hidden = YES;
    }
    if ([self.input length] < 2) {
        [self resetInput];
    } else {
        [self.input deleteCharactersInRange:NSMakeRange([self.input length] - 1, 1)];
        [self.inputCirclesView unfillCircleAtPosition:[self.input length]];
    }
}

#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            break;
        }
        case 1:{
            [self.delegate cancelButtonTappedInPinView:self];
            break;
        }
            
            
        default:
            break;
    }
}

#pragma mark - THPinNumPadViewDelegate

- (void)pinNumPadView:(THPinNumPadView *)pinNumPadView numberTapped:(NSUInteger)number
{
    _bottomButton.hidden = NO;
    NSUInteger pinLength = [self.delegate pinLengthForPinView:self];
    
    if ([self.input length] >= pinLength) {
        return;
    }
    
    [self.input appendString:[NSString stringWithFormat:@"%lu", (unsigned long)number]];
    [self.inputCirclesView fillCircleAtPosition:[self.input length] - 1];
    
    [self updateBottomButton];
    
    if ([self.input length] < pinLength) {
        return;
    }
    
    if ([self.delegate pinView:self isPinValid:self.input])
    {
        double delayInSeconds = 0.3f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.delegate correctPinWasEnteredInPinView:self];
        });
        
    } else {
        
        [self.inputCirclesView shakeWithCompletion:^{
            [self resetInput];
            _bottomButton.hidden = YES;
            [self.delegate incorrectPinWasEnteredInPinView:self];
        }];
    }
}

#pragma mark - Util

- (void)resetInput
{
    self.input = [NSMutableString string];
    [self.inputCirclesView unfillAllCircles];
    
    [self updateBottomButton];
}

@end
