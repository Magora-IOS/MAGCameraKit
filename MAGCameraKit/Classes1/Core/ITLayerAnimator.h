//
//  ITLayerAnimator.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 21/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITLayerAnimator : NSObject

@property(assign, nonatomic) CGFloat duration;

- (void)animateSpringRotationY:(CALayer *)layer to:(CGFloat)to;
- (void)animateSpringRotationY:(CALayer *)layer from:(CGFloat)from;
- (void)animateSpringRotationX:(CALayer *)layer to:(CGFloat)to;
- (void)animateSpringRotationX:(CALayer *)layer from:(CGFloat)from;

- (void)animateSpringScale:(CALayer *)layer from:(CGFloat)from to:(CGFloat)to;

@end
