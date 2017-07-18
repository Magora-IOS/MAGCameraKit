//
//  ITGesturesTransformer.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 17/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface MAGGesturesViewTransformer : NSObject

@property (weak, nonatomic) UIView *transformableView;

- (void)handlePinchAndRotateGesture:(UIGestureRecognizer *)recognizer;
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer;

@end
