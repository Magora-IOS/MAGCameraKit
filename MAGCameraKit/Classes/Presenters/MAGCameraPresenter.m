//
//  ITCameraPresenter.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 30/11/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "MAGCameraPresenter.h"
#import "MAGCameraKitCommon.h"
#import "JPSVolumeButtonHandler.h"


@interface MAGCameraPresenter ()

@property (strong, nonatomic) MAGCamera *camera;
@property (strong, nonatomic) JPSVolumeButtonHandler *volumeHandler;

@end


@implementation MAGCameraPresenter

- (instancetype)initWithCameraView:(UIView *)view {
    
    if (self = [super init]) {
        self.camera = [MAGCamera new];
        self.camera.cameraView = view;
    }
    
    return self;
}


- (instancetype)init {
    
    if (self = [super init]) {
        self.camera = [MAGCamera new];
    }
    
    return self;
}


- (void)setupCameraView:(UIView *)view {
    self.camera.cameraView = view;
}


- (void)setFlashMode:(MAGFlashMode)flasMode {
    self.camera.flashMode = flasMode;
}


- (MAGFlashMode)flashMode {
    return self.camera.flashMode;
}


- (void)layoutCameraLayer {
    [self.camera layoutCameraLayer];
}


- (BOOL)isRecording {
    return self.camera.isRecording;
}


- (void)rotateCameraAction {
    [self.camera rotateCamera];
}


- (void)focusAndExposure:(CGPoint)position {
    [self.camera focusAndExposure:position];
}


- (void)takePhotoAction {
    
    if ([self.camera isRunning]) {
        @weakify(self);
        [self.camera takePhoto:^(UIImage *image) {
            @strongify(self);
            MAGRecordSession *item = nil;
            
            if (image) {
                item = [MAGRecordSession new];
                //item.type = ITMediaTypeImage;
                item.photoImage = image;
            }
            
            if (self.completed && item) {
                self.completed(item);
            }
        }];
    }
}


- (void)startRecordAction {
    @weakify(self);
    [self.camera startRecording:^(AVAsset *asset) {
        @strongify(self);
        
        //[self.recordAnimationView stopProgress];
        [self restoreFlashLight];
        [self.viewController onStopRecording];
        
        MAGRecordSession *item = [MAGRecordSession new];
        item.videoAsset = asset;
        
        if (self.completed) {
            self.completed(item);
        }
    }];
    
    //[self.recordAnimationView startProgress];
    [self setupFlashLight];
    [self.viewController onStartRecording];
}


- (void)stopRecordAction {
    [self.camera stopRecording];
    
    ///[self.recordAnimationView stopProgress];
    ///[self restoreFlashLight];
    
    //[self.viewController onStopRecording];
}


- (void)setupFlashLight {
    if (self.flashMode == MAGFlashModeOn) {
        self.flashMode = MAGFlashModeLight;
    }
}


- (void)restoreFlashLight {
    if (self.flashMode == MAGFlashModeLight) {
        self.flashMode = MAGFlashModeOn;
    }
}


- (void)startCameraSession {
    
    //[self setupVolumeButtons];
    //[self.volumeButtons startStealingVolumeButtonEvents];
    
    [self setupVolumeHandler];
    [self.volumeHandler startHandler:YES];
    
    [self.camera startSession];
}


- (void)stopCameraSession {
    [self.camera stopSession];
    
    //[self.volumeButtons stopStealingVolumeButtonEvents];
    //self.volumeButtons = nil;
    
    [self.volumeHandler stopHandler];
    self.volumeHandler = nil;
}


- (void)beginPinchZoom {
    [self.camera beginPinchZoom];
}


- (void)changePinchZoom:(CGFloat)zoom {
    [self.camera changePinchZoom:zoom];
}


- (void)setupVolumeHandler {
    
    @weakify(self);
    self.volumeHandler = [JPSVolumeButtonHandler volumeButtonHandlerWithUpBlock:^{
        @strongify(self);
        //[self actionTap:nil];
        [self.viewController onSoundVolumeChanged];
        
    } downBlock:^{
        @strongify(self);
        //[self actionTap:nil];
        [self.viewController onSoundVolumeChanged];
    }];
}


- (void)removeRecordedSession {
    [self.camera removeAllSessionSegments];
}


- (void)closeAction {
    [self removeRecordedSession];
    if (self.cancelled) {
        self.cancelled();
    }
}






/*
- (void)viewDidLayout {
    [self.camera layoutCameraLayer];
}


- (void)actionStartRecording {
    [self.camera startRecording:^(AVAsset *asset) {
        //
    }];
}

- (void)actionStopRecording {
    [self.camera stopRecording];
}

- (void)actionTakePhoto {
    @weakify(self);
    [self.camera takePhoto:^(UIImage *image) {
        MAGMediaPickerItem *item = nil;
        
        if (image) {
            item = [MAGMediaPickerItem new];
            item.type = MAGMediaTypeImage;
            item.image = image;
        }
        @strongify(self);
        if (self.pickItemCompletion) {
            self.pickItemCompletion(item);
        }
    }];
}
*/

@end
