//
//  ITColorsPanelDataSource.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 13/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITPaintColor.h"

@protocol ITColorsPanelDataSourceProtocol <NSObject>

- (void)loadItems;
- (NSUInteger)numberOfColors;
- (ITPaintColor *)colorByIndex:(NSUInteger)index;

@end


@interface ITColorsPanelDataSource : NSObject <ITColorsPanelDataSourceProtocol>

@end
