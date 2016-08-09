//
//  VBPiePiece_private.h
//  VBPieChart
//
//  Created by Volodymyr Boichentsov on 17/01/2016.
//  Copyright © 2016 SAKrisT. All rights reserved.
//

#ifndef VBPiePiece_private_h
#define VBPiePiece_private_h
#import <UIKit/UIKit.h>
// Private class
@interface VBPiePieceData : NSObject

@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *labelColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic) BOOL accent;

+ (UIColor*) defaultColors:(NSInteger)index;
+ (VBPiePieceData*) pieceDataWith:(NSDictionary*)object;

@end



#endif /* VBPiePiece_private_h */
