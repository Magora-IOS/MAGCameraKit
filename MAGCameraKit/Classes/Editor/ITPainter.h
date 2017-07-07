//
//  ITPainter.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 09/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITPainter : NSObject

- (instancetype)initWithCanvas:(UIView *)view;

- (void)beginMove:(CGPoint)point;
- (void)move:(CGPoint)moving;
- (void)endMove:(CGPoint)point;

- (void)changeColor:(UIColor *)color;
- (BOOL)hasShapeLayers;
- (void)cancelAll;
- (void)cancel;

@end
