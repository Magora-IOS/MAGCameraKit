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


@protocol ITMediaPickerPresenterProtocol <NSObject>

@property (copy, nonatomic) ITTakeMediaCompletion completion;
@property (weak, nonatomic) UIViewController *viewController;


//- (void)uploadMedia:(ITMediaPickerItem *)item;

@end


@interface ITMediaPickerPresenter : NSObject <ITMediaPickerPresenterProtocol>

@property (copy, nonatomic) ITTakeMediaCompletion completion;
@property (weak, nonatomic) UIViewController *viewController;

@end
