//
//  ITPaintColor.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 13/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import "MAGPaintColor.h"

@implementation MAGPaintColor

+ (instancetype)paintColor:(UIColor *)color {
    
    MAGPaintColor *item = [MAGPaintColor new];
    item.color = color;
    
    return item;
}


UIColor * UIColorRGB(CGFloat r, CGFloat g, CGFloat b) {
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1];
}

UIColor * UIColorRGBA(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a];
}

UIColor * UIColorWithHex(NSString *hexString) {
    NSMutableCharacterSet *characterSet = [[NSCharacterSet whitespaceAndNewlineCharacterSet] mutableCopy];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:characterSet] uppercaseString];
    
    if ([cString length] != 6) {
        return [UIColor colorWithWhite:0.0 alpha:0.0];
    } else {
        unsigned int rgbValue = 0;
        [[NSScanner scannerWithString:cString] scanHexInt:&rgbValue];
        
        return [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0
                               green:((CGFloat)((rgbValue & 0x00FF00) >> 8)) / 255.0
                                blue:((CGFloat)(rgbValue & 0x0000FF)) / 255.0
                               alpha:1.0];
    }
}

@end
