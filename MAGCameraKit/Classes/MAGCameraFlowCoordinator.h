//
//  MAGCameraFlowCoordinator.h
//  Pods
//
//  Created by Stepanov Evgeniy on 19/07/2017.
//
//

#import <Foundation/Foundation.h>
#import "MAGMediaPickerPresenter.h"


@interface MAGCameraFlowCoordinator : NSObject

@property (weak, nonatomic) UIViewController<MAGMediaPickerVCProtocol> *mediaPickerVC;

- (void)showMediaPicker:(UIViewController<MAGMediaPickerVCProtocol> *)pickerVC rootVC:(UIViewController *)rootVC completion:(MAGTakeMediaCompletion)completion;
- (void)hideMediaPicker;

- (void)prepareForSegue:(UIStoryboardSegue *)segue;

- (void)showCameraView;
- (void)hideCameraView;

- (void)showPreView;
- (void)hidePreView;

- (void)showEditView;
- (void)hideEditView;

@end
