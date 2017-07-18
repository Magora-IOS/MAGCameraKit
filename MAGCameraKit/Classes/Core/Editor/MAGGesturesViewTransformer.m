//
//  ITGesturesTransformer.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 17/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import "MAGGesturesViewTransformer.h"

@interface MAGGesturesViewTransformer ()

@property (strong, nonatomic) NSMutableSet *activeRecognizers;
@property (assign, nonatomic) CGAffineTransform originTransform;
@property (assign, nonatomic) CGPoint originPosition;
@property (assign, nonatomic) CGFloat originScale;

@end


static const CGFloat maxTransformScale = 5;
static const CGFloat minTransformScale = 0.1;


@implementation MAGGesturesViewTransformer


- (void)handlePinchAndRotateGesture:(UIGestureRecognizer *)recognizer {
    UIView *view = self.transformableView;
    
    if (!self.activeRecognizers) {
        self.activeRecognizers = [NSMutableSet set];
    }
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (self.activeRecognizers.count == 0) {
                self.originTransform = view.transform;
                
                CGAffineTransform transform = view.transform;
                self.originScale = sqrt(fabs(transform.a * transform.d - transform.b * transform.c));
            }
            [self.activeRecognizers addObject:recognizer];
            
            break;
            
        case UIGestureRecognizerStateEnded:
            self.originTransform = [self applyRecognizer:recognizer toTransform:self.originTransform];
            [self.activeRecognizers removeObject:recognizer];
            
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGAffineTransform transform = self.originTransform;
            for (UIGestureRecognizer *recognizer in self.activeRecognizers) {
                transform = [self applyRecognizer:recognizer toTransform:transform];
            }
            view.transform = transform;
            
            break;
        }
            
        default:
            break;
    }
}


- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.originPosition = self.transformableView.center;
            break;
            
        case UIGestureRecognizerStateChanged:
            self.transformableView.center = [recognizer locationInView:recognizer.view];
            [self move:[recognizer translationInView:recognizer.view]];
            break;
            
        case UIGestureRecognizerStateEnded:
            //[self move:[recognizer translationInView:recognizer.view]];
            break;
            
        default:
            break;
    }
}


- (void)move:(CGPoint)moving {
    
        CGPoint position = self.originPosition;
        
        position.x += moving.x;
        position.y += moving.y;
        self.transformableView.center = position;
}


- (CGAffineTransform)applyRecognizer:(UIGestureRecognizer *)recognizer toTransform:(CGAffineTransform)transform
{
    if ([recognizer respondsToSelector:@selector(rotation)])
        return CGAffineTransformRotate(transform, [(UIRotationGestureRecognizer *)recognizer rotation]);
    
    else if ([recognizer respondsToSelector:@selector(scale)]) {
        CGFloat scale = [(UIPinchGestureRecognizer *)recognizer scale];
        
        if (scale * self.originScale < minTransformScale) {
            scale = minTransformScale / self.originScale;
            
        } else if (scale * self.originScale > maxTransformScale) {
            scale = maxTransformScale / self.originScale;
        }
        
        CGAffineTransform scaledTransform = CGAffineTransformScale(transform, scale, scale);
        
        return scaledTransform;
    }
    else
        return transform;
}



@end
