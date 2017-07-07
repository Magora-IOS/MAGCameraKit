//
//  ITPainter.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 09/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import "ITPainter.h"


@interface ITPainter ()

@property (weak, nonatomic) UIView *canvasView;
@property (weak, nonatomic) CAShapeLayer *currentShapeLayer;
@property (strong, nonatomic) UIBezierPath *currentShapePath;
@property (assign, nonatomic) CGPoint startLinePoint;

@property (assign, nonatomic) CGPoint currentPoint;
@property (assign, nonatomic) CGPoint prevPoint;
@property (assign, nonatomic) CGPoint prevControlVector;
@property (assign, nonatomic) NSInteger pointsCount;

@property (strong, nonatomic) NSMutableArray *shapeLayers;
@property (strong, nonatomic) UIColor *currentColor;


@end


@implementation ITPainter

#pragma mark - Public

- (instancetype)initWithCanvas:(UIView *)view {
    if (self = [super init]) {
        self.canvasView = view;
        self.shapeLayers = @[].mutableCopy;
        self.currentColor = [UIColor purpleColor];
    }
    
    return self;
}


- (void)beginMove:(CGPoint)point {
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineCapStyle = kCGLineCapRound;
    [path moveToPoint:point];
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = self.currentColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 8;
    shapeLayer.lineJoin = @"round";
    shapeLayer.lineCap = @"round";
    shapeLayer.contentsScale = [UIScreen mainScreen].scale;
    
    [[self.canvasView layer] addSublayer:shapeLayer];
    self.currentShapeLayer = shapeLayer;
    self.currentShapePath = path;
    self.startLinePoint = point;
    
    [self.shapeLayers addObject:shapeLayer];
    
    self.currentPoint = point;
    self.prevPoint = CGPointZero;
    self.prevControlVector = CGPointZero;
    self.pointsCount = 0;
}


- (void)move:(CGPoint)moving {
    
    self.pointsCount++;
    if ((self.pointsCount % 2) == 0) {
        //return;
    }
    
    UIBezierPath *path = self.currentShapePath;
    CGPoint point = self.startLinePoint;
    point.x += moving.x;
    point.y += moving.y;
    
    CGPoint prevPoint = self.prevPoint;
    CGPoint currPoint = self.currentPoint;
    CGPoint newPoint = point;
    
    [self addApproximateQuadCurveToPath:path point1:prevPoint point2:currPoint point3:newPoint];
    //Experiments:
    //[self addQubicCurveToPath:path point1:prevPoint point2:currPoint point3:newPoint];
    //[self addQuadCurveToPath:path point1:prevPoint point2:currPoint point3:newPoint];
    
    
    self.currentShapeLayer.path = path.CGPath;
    
    self.prevPoint = self.currentPoint;
    self.currentPoint = point;
}


- (void)endMove:(CGPoint)point {
    
    //UIBezierPath *path = self.currentShapePath;
    
    //[path addLineToPoint:point];
    
    //self.currentShapeLayer.path = path.CGPath;
}


- (void)changeColor:(UIColor *)color {
    self.currentColor = color;
}


- (BOOL)hasShapeLayers {
    
    BOOL result = self.shapeLayers.count > 0;
    return result;
}


- (void)cancelAll {
    
    [self removeAllLayers];
}


- (void)cancel {
    
    [self removeLastLayer];
}


#pragma mark - Private

- (void)removeLastLayer {
    
    NSArray *items = self.shapeLayers;
    CALayer *layer = items.lastObject;
    
    if (layer) {
        [self.shapeLayers removeObject:layer];
        [layer removeFromSuperlayer];
    }
}


- (void)removeAllLayers {
    
    NSArray *items = self.shapeLayers.copy;
    
    for (CALayer *layer in items) {
        [self.shapeLayers removeObject:layer];
        [layer removeFromSuperlayer];
    }
}


- (void)addApproximateQuadCurveToPath:(UIBezierPath *)path point1:(CGPoint)point1 point2:(CGPoint)point2 point3:(CGPoint)point3 {
    
    if (CGPointEqualToPoint(point3, CGPointZero) == NO && CGPointEqualToPoint(point2, CGPointZero) == NO) {
        //CGPoint vec1 = CGPointMake(currPoint.x - prevPoint.x, currPoint.y - prevPoint.y);
        CGPoint vec2 = CGPointMake(point3.x - point2.x, point3.y - point2.y);
        CGFloat median = 0.5;
        if (CGPointEqualToPoint(point1, CGPointZero) == YES) {
            median = 0;
        }
        //CGPoint pos1 = CGPointMake(prevPoint.x + median * vec1.x, prevPoint.y + median * vec1.y);
        CGPoint pos2 = CGPointMake(point2.x + median * vec2.x, point2.y + median * vec2.y);
        
        [path addQuadCurveToPoint:pos2 controlPoint:point2];
    }
}


- (void)addQubicCurveToPath:(UIBezierPath *)path point1:(CGPoint)point1 point2:(CGPoint)point2 point3:(CGPoint)point3 {
    
    if (CGPointEqualToPoint(point1, CGPointZero) == NO && CGPointEqualToPoint(point2, CGPointZero) == NO) {
        CGPoint prevControlVector = self.prevControlVector;
        CGPoint controlVector = [self controlVectorForFirst:point1 second:point2 third:point3];
        
        CGPoint controlPoint1 = CGPointMake(point1.x + prevControlVector.x, point1.y + prevControlVector.y);
        CGPoint controlPoint2 = CGPointMake(point2.x - controlVector.x, point2.y - controlVector.y);
        
        self.prevControlVector = controlVector;
        
        [path addCurveToPoint:self.currentPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        
    }
}


- (void)addQuadCurveToPath:(UIBezierPath *)path point1:(CGPoint)point1 point2:(CGPoint)point2 point3:(CGPoint)point3 {
    
    if (CGPointEqualToPoint(point1, CGPointZero)) {
        //[path addLineToPoint:point];
    } else {
        CGPoint controlPoint = [self controlPointForCurrent:point2 prevPoint:point1];
        [path addQuadCurveToPoint:point3 controlPoint:controlPoint];
        //NSLog(@"addQuadCurveToPoint: %f %f", point.x, point.y);
    }
}


- (CGPoint)controlPointForCurrent:(CGPoint)currPoint prevPoint:(CGPoint)prevPoint {
    
    CGPoint controlPoint = currPoint;
    
    if (CGPointEqualToPoint(currPoint, CGPointZero) == YES) {
        controlPoint = currPoint;
    }
    
    if (CGPointEqualToPoint(prevPoint, CGPointZero) == NO) {
        CGFloat divC = 0.3;
        CGPoint div = CGPointMake(currPoint.x - prevPoint.x, currPoint.y - prevPoint.y);
        controlPoint = CGPointMake(currPoint.x + div.x * divC, currPoint.y + div.y * divC);
    }
    
    return controlPoint;
}


- (CGPoint)controlVectorForFirst:(CGPoint)point1 second:(CGPoint)point2 third:(CGPoint)point3 {
    
    //CGPoint controlPoint = currPoint;
    CGPoint resultVector = CGPointZero;
    
    CGPoint vector1 = CGPointZero;
    CGPoint vector2 = CGPointZero; //CGPointMake(point3.x - point2.x, point3.y - point2.y);
    
    
    if (CGPointEqualToPoint(point1, CGPointZero) == NO && CGPointEqualToPoint(point2, CGPointZero) == NO) {
        vector1 = CGPointMake(point2.x - point1.x, point2.y - point1.y);
    }
    
    if (CGPointEqualToPoint(point2, CGPointZero) == NO && CGPointEqualToPoint(point3, CGPointZero) == NO) {
        vector2 = CGPointMake(point3.x - point2.x, point3.y - point2.y);
    }
    
    CGFloat coeff = 0.3;
    resultVector = CGPointMake(coeff * vector1.x + (1 - coeff) * vector2.x, coeff * vector1.y + (1 - coeff) * vector2.y);
    resultVector.x *= 0.5;
    resultVector.y *= 0.5;
    
    return resultVector;
}


@end
