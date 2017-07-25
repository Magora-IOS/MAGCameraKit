//
//  ITCameraPresenter.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 30/11/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAGMediaPickerItem.h"
#import "MAGRecordSession.h"
#import "MAGCamera.h"
#import "MAGCameraPresenter.h"

typedef void(^MAGCameraCompleted)(MAGRecordSession *session);
typedef void(^MAGCameraCancelled)();

//typedef void(^PickItemCompletion)(MAGMediaPickerItem *item);

/*
@protocol MAGCameraPresenterProtocol <NSObject>

@property (readonly, nonatomic) MAGCamera *camera;

- (void)actionStartRecording;
- (void)actionStopRecording;
- (void)actionTakePhoto;

- (void)setPickItemCompletion:(PickItemCompletion)completion;
- (void)viewDidLayout;

@end
*/

@class MAGCameraPresenter;
@class MAGCameraFlowCoordinator;

@protocol MAGCameraVCProtocol <NSObject>

@property (strong, nonatomic) MAGCameraPresenter *presenter;
@property (strong, nonatomic) MAGCameraFlowCoordinator *coordinator;

- (void)onComplete;
- (void)onCancel;

//- (void)onCameraSesionStart;
//- (void)onCameraSesionStop;

- (void)onSoundVolumeChanged;
- (void)onStartRecording;
- (void)onStopRecording;

- (void)showPreview;
- (void)hidePreview;


@end


@interface MAGCameraPresenter : NSObject ///<MAGCameraPresenterProtocol>

@property (weak, nonatomic) UIViewController<MAGCameraVCProtocol> *viewController;
@property (copy, nonatomic) MAGCameraCompleted completed;
@property (copy, nonatomic) MAGCameraCancelled cancelled;

@property (assign, nonatomic) MAGFlashMode flashMode;
@property (readonly, nonatomic) BOOL isRecording;

//@property (readonly, nonatomic) MAGCamera *camera;
//@property(copy, nonatomic) PickItemCompletion pickItemCompletion;

- (instancetype)initWithCameraView:(UIView *)view;
- (void)setupCameraView:(UIView *)view;
- (void)layoutCameraLayer;
- (void)rotateCameraAction;
- (void)focusAndExposure:(CGPoint)position;

- (void)startCameraSession;
- (void)stopCameraSession;

- (void)takePhotoAction;
- (void)startRecordAction;
- (void)stopRecordAction;

- (void)beginPinchZoom;
- (void)changePinchZoom:(CGFloat)zoom;

- (void)removeRecordedSession;
- (void)closeAction;


@end
