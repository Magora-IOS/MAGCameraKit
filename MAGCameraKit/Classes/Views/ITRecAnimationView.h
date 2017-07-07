//
//  ITRecAnimationView.h
//  InTouch
//
//  Created by stepanov on 08/12/2016.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITRecAnimationView : UIView

@property (assign, nonatomic) CGFloat maxRecDuration;
@property (assign, nonatomic) CGFloat recRadius;
@property (assign, nonatomic) CGFloat recDelaing;


- (void)startProgress;
- (void)stopProgress;
- (void)pauseProgress;

- (void)showStartTapping;
- (void)showEndTapping;

@end
