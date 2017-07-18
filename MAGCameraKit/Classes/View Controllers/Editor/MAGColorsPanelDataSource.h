//
//  ITColorsPanelDataSource.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 13/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAGPaintColor.h"

@protocol MAGColorsPanelDataSourceProtocol <NSObject>

- (void)loadItems;
- (NSUInteger)numberOfColors;
- (MAGPaintColor *)colorByIndex:(NSUInteger)index;

@end


@interface MAGColorsPanelDataSource : NSObject <MAGColorsPanelDataSourceProtocol>

@end
