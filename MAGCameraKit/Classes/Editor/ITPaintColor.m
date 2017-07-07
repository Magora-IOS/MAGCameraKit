//
//  ITPaintColor.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 13/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import "ITPaintColor.h"

@implementation ITPaintColor

+ (instancetype)paintColor:(UIColor *)color {
    
    ITPaintColor *item = [ITPaintColor new];
    item.color = color;
    
    return item;
}

@end
