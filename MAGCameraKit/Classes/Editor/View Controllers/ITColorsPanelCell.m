//
//  ITColorsPanelCell.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 12/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import "ITColorsPanelCell.h"

@interface ITColorsPanelCell ()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorViewHeight;

@end


static const CGFloat colorViewSize = 28;
static const CGFloat colorViewSelectedSize = 44;
static const CGFloat colorViewBorderWidth = 2;
static const CGFloat colorViewSelectedBorderWidth = 0;


@implementation ITColorsPanelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.colorView.clipsToBounds = YES;
    self.colorView.layer.cornerRadius = self.colorView.bounds.size.width / 2;
    self.colorView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.colorView.layer.borderWidth = colorViewBorderWidth;
}


- (void)configure:(UIColor *)color {
    
    self.colorView.backgroundColor = color;
}


- (void)setupLayerAnimation:(BOOL)selected {
    
    CALayer *layer = self.colorView.layer;
    
    CABasicAnimation *radiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    CGFloat width = selected ? colorViewSelectedSize : colorViewSize;
    CGFloat toRadius = width / 2;
    
    radiusAnimation.fromValue = @(layer.cornerRadius);
    radiusAnimation.toValue = @(toRadius);
    layer.cornerRadius = toRadius;
    
    CABasicAnimation *borderAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    CGFloat toWidth = selected ? colorViewSelectedBorderWidth : colorViewBorderWidth;
    
    borderAnimation.fromValue = @(layer.borderWidth);
    borderAnimation.toValue = @(toWidth);
    layer.borderWidth = toWidth;
    
    CAAnimationGroup *bothAnimation = [CAAnimationGroup animation];
    
    bothAnimation.duration = 0.17;
    bothAnimation.animations = @[radiusAnimation, borderAnimation];
    bothAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [layer addAnimation:bothAnimation forKey:@"RadiusAndBorder"];
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.colorViewWidth.constant = selected ? colorViewSelectedSize : colorViewSize;
    self.colorViewHeight.constant = selected ? colorViewSelectedSize : colorViewSize;
    
    [self setupLayerAnimation:selected];
    
    [UIView animateWithDuration:0.17 animations:^{
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        //
    }];
}



@end
