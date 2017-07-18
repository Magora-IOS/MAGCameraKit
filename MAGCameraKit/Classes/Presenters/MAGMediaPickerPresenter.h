//
//  ITMediaPickerPresenter.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 06/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAGMediaPickerItem.h"

typedef void(^MAGTakeMediaCompletion)(MAGMediaPickerItem *item);


@protocol MAGMediaPickerPresenterProtocol <NSObject>

@property (copy, nonatomic) MAGTakeMediaCompletion completion;
@property (weak, nonatomic) UIViewController *viewController;


//- (void)uploadMedia:(ITMediaPickerItem *)item;

@end


@interface MAGMediaPickerPresenter : NSObject <MAGMediaPickerPresenterProtocol>

@property (copy, nonatomic) MAGTakeMediaCompletion completion;
@property (weak, nonatomic) UIViewController *viewController;

@end
