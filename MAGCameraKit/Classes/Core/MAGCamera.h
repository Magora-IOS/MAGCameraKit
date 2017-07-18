//
//  ITCamera.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 30/11/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;
@import UIKit;

typedef enum : NSUInteger {
    MAGFlashModeOff,
    MAGFlashModeOn,
    MAGFlashModeAuto,
    MAGFlashModeLight
} MAGFlashMode;

@class SCRecordSession;

typedef void(^MAGTakenPhoto)(UIImage *image);
typedef void(^MAGRecordedVideo)(AVAsset *asset);


@interface MAGCamera : NSObject

@property (weak, nonatomic) UIView *cameraView;
@property (assign, nonatomic) MAGFlashMode flashMode;
@property (assign, nonatomic, readonly) BOOL isRunning;

- (void)startSession;
- (void)stopSession;

- (void)startRecording:(MAGRecordedVideo)recorded;
- (void)stopRecording;
- (void)takePhoto:(MAGTakenPhoto)completion;

- (BOOL)isRecording;

- (void)removeAllSessionSegments;
- (void)layoutCameraLayer;

- (void)focusAndExposure:(CGPoint)position;
- (void)rotateCamera;

- (void)beginPinchZoom;
- (void)changePinchZoom:(CGFloat)zoom;

@end
