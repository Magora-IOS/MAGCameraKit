//
//  UIImage+Additions.h
//  InTouch
//
//  Created by Poluektov Yuriy on 29.10.15.
//  Copyright © 2015 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MAGCameraKit)

- (UIImage *)makeRoundCornersWithRadius:(const CGFloat)RADIUS;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)fixOrientation;

- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)scaleProportionalToSize:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage *)scaledByAspectFit:(CGSize)maxSize;
- (UIImage *)scaledByFullHDAspectFit;

@end
