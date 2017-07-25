//
//  ITMediaPickerPresenter.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 06/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAGMediaPickerItem.h"
//#import "MAGCameraFlowCoordinator.h"


typedef void(^MAGTakeMediaCompletion)(MAGMediaPickerItem *item);
typedef void(^MAGTakeMediaCancellation)();

@class MAGMediaPickerPresenter;
@class MAGCameraFlowCoordinator;

@protocol MAGMediaPickerVCProtocol <NSObject>
@property (strong, nonatomic) MAGCameraFlowCoordinator *coordinator;
@property (strong, nonatomic) MAGMediaPickerPresenter *presenter;

- (void)close;

@end

/*
@protocol MAGMediaPickerPresenterProtocol <NSObject>

@property (copy, nonatomic) MAGTakeMediaCompletion completion;
@property (weak, nonatomic) UIViewController *viewController;
 
//- (void)uploadMedia:(ITMediaPickerItem *)item;

@end
*/


@interface MAGMediaPickerPresenter : NSObject

@property (weak, nonatomic) UIViewController<MAGMediaPickerVCProtocol> *viewController;
@property (copy, nonatomic) MAGTakeMediaCompletion completion;
@property (copy, nonatomic) MAGTakeMediaCancellation cancellation;

- (void)completeActionWithItem:(MAGMediaPickerItem *)item;
- (void)cancelAction;

@end
