//
//  ITBottomGrayGradientView.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 19/12/2016.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "MAGBottomGrayGradientView.h"

@implementation MAGBottomGrayGradientView

@dynamic layer;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.layer.colors = @[ (id)[UIColor clearColor].CGColor,
                               (id)[[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor,
                               (id)[[UIColor blackColor] colorWithAlphaComponent:0.9].CGColor];
        self.layer.locations = @[@0.0, @0.5, @1];
        return self;
    }
    return nil;
}


+ (Class)layerClass {
    return [CAGradientLayer class];
}

@end
