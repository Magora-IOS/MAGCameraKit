//
//  ITMediaPickerPresenter.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 06/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITMediaPickerItem.h"

typedef void(^ITTakeMediaCompletion)(ITMediaPickerItem *item);

@class ITEvent, ITAnalyticsManager;

@protocol ITMediaPickerPresenterProtocol <NSObject>

@property (copy, nonatomic) ITTakeMediaCompletion completion;
@property (weak, nonatomic) UIViewController *viewController;
@property (strong , nonatomic) ITEvent *event;
@property (strong, nonatomic) ITAnalyticsManager *analyticsManager;


- (void)uploadMedia:(ITMediaPickerItem *)item;

@end


@interface ITMediaPickerPresenter : NSObject <ITMediaPickerPresenterProtocol>

@property (copy, nonatomic) ITTakeMediaCompletion completion;
@property (weak, nonatomic) UIViewController *viewController;
@property (strong , nonatomic) ITEvent *event;
@property (strong, nonatomic) ITAnalyticsManager *analyticsManager;

@end
