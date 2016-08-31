//
//  BetaNaoTextField.m
//  BWWalkthroughExample
//
//  Created by mukesh mandora on 24/07/15.
//  Copyright (c) 2015 Yari D'areglia. All rights reserved.
//

#import "BetaNaoTextField.h"

@interface BetaNaoTextField (){
    //    UILabel *self.self.placeholder;
    CGFloat inset;
  
    CAShapeLayer *leftLayer;
    CGPoint textFieldInset,placeholderInset;
}
@property (strong ,nonatomic) UILabel *placeHolderLabel;
@property (nonatomic) CGFloat placeholderHeight;


@end
@implementation BetaNaoTextField
@synthesize placeHolderLabel;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [self addPlaceHolderLabel];
    
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    // Set the starting point of the shape.
    [leftPath moveToPoint:CGPointMake(0,self.bounds.size.height)];
    // Draw the lines.
    [leftPath addLineToPoint:CGPointMake(0,self.bounds.size.height)];
    [leftPath addLineToPoint:CGPointMake(self.bounds.size.width,self.bounds.size.height)];
    
    leftLayer.path = leftPath.CGPath;
    leftLayer.fillColor = nil;
    leftLayer.borderWidth = 3.0f;
    leftLayer.lineCap = kCALineCapRound;
    leftLayer.lineJoin = kCALineJoinRound;
    //    leftLayer.frame=CGRectMake(0, 50, 200, 1);
    leftLayer.borderColor=[UIColor blackColor].CGColor;
    [self.layer addSublayer:leftLayer];
    
}

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    self.delegate = self;
    if (self) {
        self.placeHolderLabel = [[UILabel alloc] init];
        self.placeHolderLabel.text = @"Add comment here";
        self.placeHolderLabel.textColor = [UIColor whiteColor];
        self.placeHolderLabel.backgroundColor=[UIColor clearColor];
        self.placeHolderLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        self.placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        
        
        placeholderInset = CGPointMake(6, 6);
        textFieldInset = CGPointMake(6, 6);
        
        leftLayer = [CAShapeLayer layer];
        
        self.backgroundColor=[UIColor clearColor];
        
    }
    
    return self;
}



-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    self.delegate = self;
    if (self) {
        self.placeHolderLabel = [[UILabel alloc] init];
        self.placeHolderLabel.text = @"Add comment here";
        self.placeHolderLabel.textColor = [UIColor whiteColor];
        self.placeHolderLabel.backgroundColor=[UIColor clearColor];
        self.placeHolderLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        self.placeHolderLabel.textAlignment = NSTextAlignmentLeft;
       
        
        placeholderInset = CGPointMake(6, 6);
        textFieldInset = CGPointMake(6, 6);
        
        leftLayer = [CAShapeLayer layer];
        
        self.backgroundColor=[UIColor clearColor];

    }
    
    return self;
}



-(void)animateCureve{
    
    
    
    CABasicAnimation *pathAppear = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAppear.duration = 1.5;
    pathAppear.fromValue = (__bridge id)leftLayer.path;
    pathAppear.toValue   = (__bridge id)[self wavePath].CGPath;
    
    [leftLayer addAnimation:pathAppear forKey:@"make the path appear"];
    
}
- (UIBezierPath *)wavePath {
    //set start and end accordingly
    
    UIBezierPath *startPath = [UIBezierPath bezierPath];
    
    [startPath moveToPoint:CGPointMake(0, self.bounds.size.height)];
    //    [startPath addQuadCurveToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height/2) controlPoint:CGPointMake(self.bounds.size.width/2,10)];
    
    [startPath addCurveToPoint:CGPointMake(self.bounds.size.width-25, self.bounds.size.height) controlPoint1:CGPointMake(50, self.bounds.size.height+0)  controlPoint2:CGPointMake(self.bounds.size.width/2, 50) ];
    [startPath moveToPoint:CGPointMake(self.bounds.size.width-25, self.bounds.size.height)];
    [startPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    
    return startPath;
}

-(void)setPlaceholderHeight:(CGFloat)placeholderHeight{
    
}

-(CGFloat)placeholderHeight{
    UIFont *fontOfText=[UIFont fontWithName:@"HelveticaNeue" size:self.font.pointSize*0.7];
    return placeholderInset.y+fontOfText.lineHeight;
}
- (void)addPlaceHolderLabel
{
    
     self.placeHolderLabel.frame=CGRectMake(0, self.bounds.size.height-24, self.bounds.size.width, 24);
    [self addSubview:self.placeHolderLabel];
    
}

-(void)setBorderLayer{
    
}


-(CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectOffset(self.bounds, 0, self.bounds.size.height/2-textFieldInset.y);
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    return [self textRectForBounds:bounds];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
//     [self animateCureve];
    [UIView animateWithDuration:0.5 delay:0.2 options:0 animations:^{
         self.placeHolderLabel.frame=CGRectMake(0, 24, self.bounds.size.width, 24);
    } completion:^(BOOL finished) {
        self.placeHolderLabel.textColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
    }];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignFirstResponder];
    if (self.returnBlock) {
        BetaNaoTextField *field = (BetaNaoTextField *)textField;
        self.returnBlock(field);
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if([textField.text isEqual:@""]){
          [UIView animateWithDuration:0.5 animations:^{
            
            self.placeHolderLabel.frame=CGRectMake(0, self.bounds.size.height-24, self.bounds.size.width, 24);
            self.placeHolderLabel.textColor = [UIColor lightGrayColor];
        }];
    }
    
}

- (void)setTextLineColor:(UIColor *)textLineColor
{
    leftLayer.strokeColor = textLineColor.CGColor;
}

- (void)setTextPlaceHolder:(NSString *)textPlaceHolder
{
    self.placeHolderLabel.text = textPlaceHolder;
}

- (void)setTextPlaceHolderColor:(UIColor *)textPlaceHolderColor
{
    self.placeHolderLabel.textColor = textPlaceHolderColor;
}

- (void)reloadTextFieldWithTextString:(NSString *)string
{
    
//    [self animateCureve];
    [UIView animateWithDuration:0.5 delay:0.2 options:0 animations:^{
        self.placeHolderLabel.frame=CGRectMake(0, 24, self.bounds.size.width, 24);
    } completion:^(BOOL finished) {
        self.text = string;
        self.placeHolderLabel.textColor = [UIColor colorWithRed:0.161 green:0.659 blue:0.902 alpha:1.00];
    }];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

//
@end

