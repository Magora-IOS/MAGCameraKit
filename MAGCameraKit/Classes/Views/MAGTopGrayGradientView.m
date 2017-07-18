//
//  ITTopGrayGradientView.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 23/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import "MAGTopGrayGradientView.h"

@implementation MAGTopGrayGradientView


@dynamic layer;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.layer.colors = @[ (id)[[UIColor blackColor] colorWithAlphaComponent:0.9].CGColor,
                               (id)[[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor,
                               (id)[UIColor clearColor].CGColor];
        self.layer.locations = @[@0.0, @0.5, @1];
        return self;
    }
    return nil;
}


+ (Class)layerClass {
    return [CAGradientLayer class];
}

@end
