//
//  ITCamera.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 30/11/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

typedef enum : NSUInteger {
    ITFlashModeOff,
    ITFlashModeOn,
    ITFlashModeAuto,
    ITFlashModeLight
} ITFlashMode;

@class SCRecordSession;

typedef void(^ITTakenPhoto)(UIImage *image);
typedef void(^ITRecordedVideo)(AVAsset *asset);


@interface ITCamera : NSObject

@property (weak, nonatomic) UIView *cameraView;
@property (assign, nonatomic) ITFlashMode flashMode;
@property (assign, nonatomic, readonly) BOOL isRunning;

- (void)startSession;
- (void)stopSession;

- (void)startRecording:(ITRecordedVideo)recorded;
- (void)stopRecording;
- (void)takePhoto:(ITTakenPhoto)completion;

- (BOOL)isRecording;

- (void)removeAllSessionSegments;
- (void)layoutCameraLayer;

- (void)focusAndExposure:(CGPoint)position;
- (void)rotateCamera;

- (void)beginPinchZoom;
- (void)changePinchZoom:(CGFloat)zoom;

@end
