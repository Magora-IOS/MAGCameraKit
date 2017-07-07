//
//  ITRecAnimationView.m
//  InTouch
//
//  Created by stepanov on 08/12/2016.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "ITRecAnimationView.h"

@interface ITRecAnimationView ()

@property (strong, nonatomic) CAShapeLayer *circleProgressLayer;
@property (strong, nonatomic) CAShapeLayer *circleBackgroundLayer;
@property (strong, nonatomic) CABasicAnimation *drawCircleAnimation;
//@property(strong, nonatomic) NSTimer *recTimer;

@end


static CGFloat const RecBackgroundRadius = 40.0;


@implementation ITRecAnimationView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self createBackgroundLayer];
}


- (void)createBackgroundLayer {
    
    int radius = RecBackgroundRadius;
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0 * radius, 2.0 * radius)
                                             cornerRadius:radius].CGPath;
    circle.position = CGPointMake(CGRectGetMidX(self.bounds) - radius,
                                  CGRectGetMidY(self.bounds) - radius);
    
    circle.fillColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    
    [self.layer addSublayer:circle];
    self.circleBackgroundLayer = circle;
}


- (CATransform3D)scaleCenterTransform:(CGFloat)scale radius:(CGFloat)radius {
    
    CATransform3D transform = CATransform3DIdentity;
    
    transform = CATransform3DTranslate(transform, radius, radius, 0);
    transform = CATransform3DScale(transform, scale, scale, 1);
    transform = CATransform3DTranslate(transform, -radius, -radius, 0);
    
    return transform;
}


- (CABasicAnimation *)animationOfTouchDown {

    int radius = RecBackgroundRadius;
    CGFloat scale = 1.25;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D trFrom = [self scaleCenterTransform:1.0 radius:radius];
    CATransform3D trTo = [self scaleCenterTransform:scale radius:radius];
    animation.duration = 0.3;

    animation.fromValue = [NSValue valueWithCATransform3D:trFrom];
    animation.toValue = [NSValue valueWithCATransform3D:trTo];
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :3.0 :0.9 :0.5];
    animation.removedOnCompletion = YES;
    
    return animation;
}


- (CABasicAnimation *)animationOfTouchUp {
    
    int radius = RecBackgroundRadius;
    CGFloat scale = 1.25;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D trFrom = [self scaleCenterTransform:scale radius:radius];
    CATransform3D trTo = [self scaleCenterTransform:1.0 radius:radius];
    animation.duration = 0.3;
    
    animation.fromValue = [NSValue valueWithCATransform3D:trFrom];
    animation.toValue = [NSValue valueWithCATransform3D:trTo];
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :-1.7 :0.9 :1.9];
    animation.removedOnCompletion = YES;
    
    return animation;
}

- (CAShapeLayer *)progressShapeLayer {
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    int radius = self.recRadius;
    
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0 * radius, 2.0 * radius)
                                             cornerRadius:radius].CGPath;
    circle.position = CGPointMake(CGRectGetMidX(self.bounds) - radius,
                                  CGRectGetMidY(self.bounds) - radius);
    
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor redColor].CGColor;
    circle.lineWidth = 4.0;
    
    return circle;
}


- (CABasicAnimation *)animationOfProgress {
    
    CGFloat from = 0;
    CGFloat to = 1.0;
    CGFloat allCircleDuration = self.maxRecDuration;
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = (to - from) * allCircleDuration;
    drawAnimation.repeatCount         = 1.0;
    
    drawAnimation.fromValue = [NSNumber numberWithFloat:from];
    drawAnimation.toValue   = [NSNumber numberWithFloat:to];
    drawAnimation.removedOnCompletion = YES;
    
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    return drawAnimation;
}


- (void)showStartTapping {

    CABasicAnimation *animation = [self animationOfTouchDown];
    
    //[self.circleBackgroundLayer removeAnimationForKey:@"animationOfTouchUp"];
    [self.circleBackgroundLayer removeAnimationForKey:@"animationOfTouchDown"];
    self.circleBackgroundLayer.transform = [self scaleCenterTransform:1.25 radius:RecBackgroundRadius];
    [self.circleBackgroundLayer addAnimation:animation forKey:@"animationOfTouchDown"];
}

- (void)showEndTapping {
    
    CABasicAnimation *animation = [self animationOfTouchUp];
    
    //[self.circleBackgroundLayer removeAnimationForKey:@"animationOfTouchDown"];
    [self.circleBackgroundLayer removeAnimationForKey:@"animationOfTouchUp"];
    self.circleBackgroundLayer.transform = [self scaleCenterTransform:1.0 radius:RecBackgroundRadius];
    [self.circleBackgroundLayer addAnimation:animation forKey:@"animationOfTouchUp"];
}


- (void)startProgress {
    [self startCircleAnimation];
}


- (void)stopProgress {
    [self stopCircleAnimation];
}


- (void)pauseProgress {
    [self stopCircleAnimation];
}


- (void)startAnimationCirleFrom:(CGFloat)from to:(CGFloat)to {
    
    [self.circleProgressLayer removeAnimationForKey:@"circleProgressLayer"];
    //[self resumeLayer:self.circleProgressLayer];
    
    CAShapeLayer *circle = self.circleProgressLayer;
    if (self.circleProgressLayer.superlayer != self.layer) {
        circle = [self progressShapeLayer];
        self.circleProgressLayer = circle;
        
        [self.layer addSublayer:circle];
    }
    
    CABasicAnimation *animation = [self animationOfProgress];
    self.drawCircleAnimation = animation;
    [circle addAnimation:animation forKey:@"circleProgressLayer"];
}


- (void)startCircleAnimation {
    
    [self startAnimationCirleFrom:0.0 to:1.0];
}


- (void)stopCircleAnimation {
    
    //[self pauseLayer:self.circleProgressLayer];
    [self.circleProgressLayer removeFromSuperlayer];
}


- (void)pauseLayer:(CALayer*)layer {
    
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}


- (void)resumeLayer:(CALayer*)layer {
    
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}



- (void)onTickRecTimer
{
    //
}

@end
