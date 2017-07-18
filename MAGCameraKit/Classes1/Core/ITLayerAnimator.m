//
//  ITLayerAnimator.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 21/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import "ITLayerAnimator.h"

@implementation ITLayerAnimator

- (instancetype)init {
    if (self = [super init]) {
        self.duration = 0.25;
    }
    
    return self;
}


- (void)animateSpringRotationY:(CALayer *)layer to:(CGFloat)to {
    
    CABasicAnimation *animation = [self animationOfRotationY:0 to:to];
    CATransform3D trTo = CATransform3DMakeRotation(to, 0, 1, 0);
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.1 :-1.7 :0.9 :0.7];
    
    layer.transform = trTo;
    [layer addAnimation:animation forKey:@"animateRotationY:to:"];
}


- (void)animateSpringRotationY:(CALayer *)layer from:(CGFloat)from {
    
    CABasicAnimation *animation = [self animationOfRotationY:from to:0];
    CATransform3D trTo = CATransform3DMakeRotation(0, 0, 1, 0);
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.17 :0.1 :0.9 :1.7];
    
    layer.transform = trTo;
    [layer addAnimation:animation forKey:@"animateRotationY:from:"];
}

// -----

- (void)animateSpringRotationX:(CALayer *)layer to:(CGFloat)to {
    
    CABasicAnimation *animation = [self animationOfRotationX:0 to:to];
    CATransform3D trTo = CATransform3DMakeRotation(to, 0, 1, 0);
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.1 :0.7 :0.9 :0.7];
    
    layer.transform = trTo;
    [layer addAnimation:animation forKey:@"animateRotationX:to:"];
}


- (void)animateSpringRotationX:(CALayer *)layer from:(CGFloat)from {
    
    CABasicAnimation *animation = [self animationOfRotationX:from to:0];
    CATransform3D trTo = CATransform3DMakeRotation(0, 0, 1, 0);
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.17 :0.1 :0.9 :1.7];
    
    layer.transform = trTo;
    [layer addAnimation:animation forKey:@"animateRotationX:from:"];
}

// -----

- (void)animateSpringScale:(CALayer *)layer from:(CGFloat)from to:(CGFloat)to {
    
    CABasicAnimation *animation = [self animationScaleFrom:from to:to];
    CATransform3D trTo = CATransform3DMakeScale(to, to, 1);
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.17 :0.1 :0.9 :1.7];
    
    layer.transform = trTo;
    [layer addAnimation:animation forKey:@"animateSpringScale:"];
}




// ----- Private

- (CABasicAnimation *)animationOfRotationY:(CGFloat)from to:(CGFloat)to {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D trFrom = CATransform3DMakeRotation(from, 0, 1, 0);
    CATransform3D trTo = CATransform3DMakeRotation(to, 0, 1, 0);
    animation.duration = self.duration;
    
    animation.fromValue = [NSValue valueWithCATransform3D:trFrom];
    animation.toValue = [NSValue valueWithCATransform3D:trTo];
    animation.removedOnCompletion = YES;
    
    return animation;
}


- (CABasicAnimation *)animationOfRotationX:(CGFloat)from to:(CGFloat)to {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D trFrom = CATransform3DMakeRotation(from, 1, 0, 0);
    CATransform3D trTo = CATransform3DMakeRotation(to, 1, 0, 0);
    animation.duration = self.duration;
    
    animation.fromValue = [NSValue valueWithCATransform3D:trFrom];
    animation.toValue = [NSValue valueWithCATransform3D:trTo];
    animation.removedOnCompletion = YES;
    
    return animation;
}


- (CABasicAnimation *)animationScaleFrom:(CGFloat)from to:(CGFloat)to {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D trFrom = CATransform3DMakeScale(from, from, 1);
    CATransform3D trTo = CATransform3DMakeScale(to, to, 1);
    animation.duration = self.duration;
    
    animation.fromValue = [NSValue valueWithCATransform3D:trFrom];
    animation.toValue = [NSValue valueWithCATransform3D:trTo];
    animation.removedOnCompletion = YES;
    
    return animation;
}


@end
