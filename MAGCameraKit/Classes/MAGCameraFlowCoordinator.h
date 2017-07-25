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


- (void)configureMediaPicker:(UIViewController<MAGMediaPickerVCProtocol> *)pickerVC completion:(MAGTakeMediaCompletion)completion;
- (void)showMediaPicker:(UIViewController *)rootVC;
- (void)hideMediaPicker;

- (void)prepareForSegue:(UIStoryboardSegue *)segue;

//- (void)showCameraView;
//- (void)hideCameraView;

//- (void)showPreView;
//- (void)hidePreView;

//- (void)showEditView;
//- (void)hideEditView;

- (void)openTextEdit;
- (void)openPaintEdit;
- (void)openEmojiEdit;


@end
