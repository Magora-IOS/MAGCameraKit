//
//  ITPaintColor.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 13/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITPaintColor : NSObject

@property (strong) UIColor *color;

+ (instancetype)paintColor:(UIColor *)color;

@end
