//
//  MAGMediaPreviewPresenter.h
//  Pods
//
//  Created by Stepanov Evgeniy on 19/07/2017.
//
//

#import <Foundation/Foundation.h>

@class MAGMediaPreviewPresenter;
@class MAGCameraFlowCoordinator;


typedef void(^MAGMediaPreviewCompleted)(MAGMediaPickerItem *item);
typedef void(^MAGMediaPreviewCancelled)();


@protocol MAGMediaPreviewVCProtocol <NSObject>

@property (strong, nonatomic) MAGMediaPreviewPresenter *presenter;
@property (strong, nonatomic) MAGCameraFlowCoordinator *coordinator;

@end


@interface MAGMediaPreviewPresenter : NSObject

@property (weak, nonatomic) UIViewController<MAGMediaPreviewVCProtocol> *viewController;

@property(copy, nonatomic) MAGMediaPreviewCompleted completed;
@property(copy, nonatomic) MAGMediaPreviewCancelled cancelled;

@end
