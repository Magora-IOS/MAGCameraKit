//
//  ITColorsPanelDataSource.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 13/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import "MAGColorsPanelDataSource.h"


@interface MAGColorsPanelDataSource ()

@property (copy, nonatomic) NSArray *items;

@end


@implementation MAGColorsPanelDataSource

/*
- (instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}*/



- (void)loadItems {
    /*
    self.items = @[[ITPaintColor paintColor:[UIColor blueColor]],
                   [ITPaintColor paintColor:[UIColor greenColor]],
                   [ITPaintColor paintColor:[UIColor purpleColor]],
                   [ITPaintColor paintColor:[UIColor redColor]],
                   [ITPaintColor paintColor:[UIColor orangeColor]],
                   [ITPaintColor paintColor:[UIColor yellowColor]],
                   [ITPaintColor paintColor:[UIColor whiteColor]],
                   ];
     */
    
    self.items = @[[MAGPaintColor paintColor:UIColorRGB(255, 255, 255)],
                   [MAGPaintColor paintColor:UIColorRGB(0, 186, 255)],
                   [MAGPaintColor paintColor:UIColorRGB(12, 255, 1)],
                   [MAGPaintColor paintColor:UIColorRGB(255, 1, 252)],
                   [MAGPaintColor paintColor:UIColorRGB(238, 28, 37)],
                   [MAGPaintColor paintColor:UIColorRGB(255, 126, 0)],
                   [MAGPaintColor paintColor:UIColorRGB(255, 252, 0)],
                   [MAGPaintColor paintColor:UIColorRGB(0, 0, 0)]
                   ];
}


- (NSUInteger)numberOfColors {
    
    return self.items.count;
}


- (MAGPaintColor *)colorByIndex:(NSUInteger)index {
    
    return self.items[index];
}


@end
