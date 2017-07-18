//
//  ITCamera.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 30/11/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "MAGCamera.h"
//#import <SCRecorder/SCRecorder.h>
#import "SCRecorder.h"
#import "UIImage+MAGCameraKit.h"
#import "MAGCameraKitCommon.h"


@interface MAGCamera () <SCRecorderDelegate>

@property (strong, nonatomic) SCRecorder *recorder;
@property (strong, nonatomic) CAShapeLayer *focusLayer;
@property (strong, nonatomic) UIImageView *blurCameraView;

@property (copy, nonatomic) MAGRecordedVideo recordedVideo;
@property (assign, nonatomic) BOOL isRunning;
@property (assign, nonatomic) CGFloat originZoomFactor;

@end


static const CGFloat maxCameraZoom = 4;


@implementation MAGCamera

-(instancetype)init {
    if (self = [super init]) {
        [self initialization];
    }
    
    return self;
}


- (void)dealloc {
    NSLog(@"Camera is released.");
    
    [self stopSession];
}

#pragma mark - Initialization

- (void)initialization {
    
    SCRecorder *recorder = [SCRecorder sharedRecorder];
    self.recorder = recorder;
    
    [self setupRecorder];
    //[self setupSession];
    [self setupPhotoConfiguration];
    [self setupVideoConfiguration];
    [self setupAudioConfiguration];
    
    [self startSession];
}


- (void)startSession {
    self.isRunning = YES;
    //#ifndef TARGET_OS_SIMULATOR
    // Start running the flow of buffers
    if (![self.recorder startRunning]) {
        NSLog(@"setupRecorder: %@", self.recorder.error);
    }
    //#endif
}

- (void)stopSession {
    self.isRunning = NO;
    [self.recorder stopRunning];
}


- (void)setCameraView:(UIView *)cameraView {
    _cameraView = cameraView;
    
    self.recorder.previewView = cameraView;
}


- (void)layoutCameraLayer {
    [self.recorder previewViewFrameChanged];
}


- (void)setupRecorder {
    
    SCRecorder *recorder = self.recorder;
    
    // Create a new session and set it to the recorder
    recorder.session = [SCRecordSession recordSession];
    
    // Set the AVCaptureSessionPreset for the underlying AVCaptureSession.
    recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetForDevicePosition:AVCaptureDevicePositionFront withMaxSize:CGSizeMake(3840, 3840)]; //AVCaptureSessionPresetHigh
    
#ifdef DEBUG
    // Set the video device to use
    recorder.device = AVCaptureDevicePositionFront;
#else
    recorder.device = AVCaptureDevicePositionBack;
#endif
    
    // Set the maximum record duration
    recorder.maxRecordDuration = CMTimeMake(60, 1);
    
    // Listen to the messages SCRecorder can send
    recorder.delegate = self;
    
    recorder.videoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
    recorder.videoOrientation = AVCaptureVideoOrientationPortrait;
    recorder.autoSetVideoOrientation = NO;
    recorder.automaticallyConfiguresApplicationAudioSession = YES;
    recorder.keepMirroringOnWrite = YES;
    //recorder.mirrorOnFrontCamera = YES;
    //recorder.previewView = self.cameraView;
    recorder.initializeSessionLazily = NO;
    recorder.resetZoomOnChangeDevice = YES;

}


- (void)setupSession {
    
    NSError *error = nil;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                     withOptions:0
                                           error:&error];
    
    //AVAudioSession *session = [AVAudioSession sharedInstance];
    //[session setActive:YES withOptions:(AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation) error:&error];
}


- (void)setupVideoConfiguration {
    
    // Get the video configuration object
    SCVideoConfiguration *video = self.recorder.videoConfiguration;
    
    // Whether the video should be enabled or not
    video.enabled = YES;
    // The bitrate of the video video
    video.bitrate = 3000000; // 2Mbit/s
    // Size of the video output
    //video.size = CGSizeMake(720, 1280);
    // Scaling if the output aspect ratio is different than the output one
    video.scalingMode = AVVideoScalingModeResizeAspectFill;
    // The timescale ratio to use. Higher than 1 makes a slow motion, between 0 and 1 makes a timelapse effect
    video.timeScale = 1;
    // Whether the output video size should be infered so it creates a square video
    video.sizeAsSquare = NO;
    // The filter to apply to each output video buffer (this do not affect the presentation layer)
    //video.filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"];
    //[self setupCameraFilter];
}


- (void)setupCameraFilter {
    
    SCVideoConfiguration *video = self.recorder.videoConfiguration;
    
    video.filter = [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"];
}


- (void)setupAudioConfiguration {
    
    // Get the audio configuration object
    SCAudioConfiguration *audio = self.recorder.audioConfiguration;
    
    // Whether the audio should be enabled or not
    audio.enabled = YES;
    // the bitrate of the audio output
    audio.bitrate = 128000; // 128kbit/s
    // Number of audio output channels
    audio.channelsCount = 1; // Mono output
    // The sample rate of the audio output
    audio.sampleRate = 0; // Use same input
    // The format of the audio output
    audio.format = kAudioFormatMPEG4AAC; // AAC
}


- (void)setupPhotoConfiguration {
    
    SCPhotoConfiguration *photo = self.recorder.photoConfiguration;
    photo.enabled = YES;
}


#pragma mark - Public

- (void)startRecording:(MAGRecordedVideo)recorded {
    self.recordedVideo = recorded;
    
    [self.recorder record];
}


- (void)stopRecording {
    
    [self.recorder pause:^{
        //
    }];
}


- (void)removeAllSessionSegments {
    [self.recorder.session removeAllSegments];
}


- (void)takePhoto:(MAGTakenPhoto)completion {
    [self showPhotoAnimation];
    @weakify(self);
    [self.recorder capturePhoto:^(NSError * _Nullable error, UIImage * _Nullable image) {
        @strongify(self);
        UIImage* resultImage = image;
        
        if (self.recorder.keepMirroringOnWrite == YES && self.recorder.device == AVCaptureDevicePositionFront) {
            UIImage* flippedImage = [UIImage imageWithCGImage:image.CGImage
                                                        scale:image.scale
                                                  orientation:UIImageOrientationLeftMirrored];
            resultImage = [flippedImage fixOrientation];
            
        } else {
            resultImage = [image fixOrientation];
        }

        if (completion) {
            completion(resultImage);
        }
    }];
}


- (BOOL)isRecording {
    return self.recorder.isRecording;
}


- (void)rotateCamera {
    
    [self showFlipAnimation];
    @weakify(self);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        @strongify(self);
        if (self.recorder.device == AVCaptureDevicePositionBack) {
            self.recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetForDevicePosition:AVCaptureDevicePositionFront withMaxSize:CGSizeMake(3840, 3840)];
        }
        
        [self.recorder switchCaptureDevices];
        
        if (self.recorder.device == AVCaptureDevicePositionBack) {
            self.recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetForDevicePosition:AVCaptureDevicePositionBack withMaxSize:CGSizeMake(3840, 3840)];
        }

    }];
}


- (void)focusAndExposure:(CGPoint)position {
    
    CGPoint convertedFocusPoint = [self.recorder convertToPointOfInterestFromViewCoordinates:position];
    [self.recorder autoFocusAtPoint:convertedFocusPoint];
    
    [self showFocusLayer:position];
}


- (void)beginPinchZoom {
    self.originZoomFactor = self.recorder.videoZoomFactor;
}


- (void)changePinchZoom:(CGFloat)zoom {
    CGFloat zoomFactor = self.originZoomFactor * zoom;
    zoomFactor = (zoomFactor < 1) ? 1 : zoomFactor;
    zoomFactor = (zoomFactor > maxCameraZoom) ? maxCameraZoom : zoomFactor;
    
    self.recorder.videoZoomFactor = zoomFactor;
}


- (void)setupFlashAuto {
    self.recorder.flashMode = SCFlashModeAuto;
}


- (void)setFlashMode:(MAGFlashMode)flashMode {
    _flashMode = flashMode;
    
    switch (flashMode) {
        case MAGFlashModeOff:
            self.recorder.flashMode = SCFlashModeOff;
            break;
        case MAGFlashModeOn:
            self.recorder.flashMode = SCFlashModeOn;
            break;
        case MAGFlashModeAuto:
            self.recorder.flashMode = SCFlashModeAuto;
            break;
        case MAGFlashModeLight:
            self.recorder.flashMode = SCFlashModeLight;
            break;
            
        default:
            break;
    }
}


- (void)showPhotoAnimation {
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.35;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.type = kCATransitionFade;
    @weakify(self);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        @strongify(self);
        [self.recorder.previewLayer addAnimation:animation forKey:nil];
    }];
}


- (void)showFlipAnimation {
    
    CATransition *animation = [CATransition animation];
    animation.duration = (self.recorder.device == AVCaptureDevicePositionFront ? 0.5f : 0.66f);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.type = @"oglFlip";
    
    if (self.recorder.device == AVCaptureDevicePositionFront) {
        animation.subtype = kCATransitionFromRight;
    }
    else if(self.recorder.device == AVCaptureDevicePositionBack){
        animation.subtype = kCATransitionFromLeft;
    }
    
    @weakify(self);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        @strongify(self);
        [self.recorder.previewLayer addAnimation:animation forKey:nil];
    }];
    
}


- (void)showFocusLayer:(CGPoint)position
{
    int radius = 35;
    
    [self.focusLayer removeFromSuperlayer];
    CAShapeLayer *shape = [CAShapeLayer layer];
    self.focusLayer = shape;
    
    shape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2 * radius, 2 * radius)
                                            cornerRadius:1].CGPath;
    shape.position = CGPointMake(position.x - radius, position.y - radius);
    
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.strokeColor = [UIColor whiteColor].CGColor;
    shape.lineWidth = 1.5f;
    
    [self.cameraView.layer addSublayer:shape];
    
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    drawAnimation.duration            = 1.0f;
    drawAnimation.repeatCount         = 1.0;
    
    drawAnimation.fromValue = [UIColor clearColor];
    drawAnimation.toValue   = [UIColor whiteColor];
    
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [shape addAnimation:drawAnimation forKey:@"showFocusLayerAnimation"];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFocusLayer) object:nil];
    [self performSelector:@selector(hideFocusLayer) withObject:nil afterDelay:1.5f];
}


- (void)hideFocusLayer
{
    [self.focusLayer removeFromSuperlayer];
    self.focusLayer = nil;
}


- (void)showBlurEffect:(CGFloat)duration {
    
    UIImage * image = [_recorder snapshotOfLastVideoBuffer];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@78.0f forKey:@"inputRadius"];
    CIImage *result = [filter outputImage];
    //NSLog(@"Blur image: %@", result);
    
    CGRect extent = [inputImage extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    
    [self.blurCameraView.layer removeFromSuperlayer];
    UIImageView *blurView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:cgImage]];
    CGImageRelease(cgImage);
    blurView.layer.bounds = _recorder.previewLayer.bounds;
    blurView.layer.position = CGPointMake(_recorder.previewLayer.bounds.size.width / 2, _recorder.previewLayer.bounds.size.height / 2);
    
    if (_recorder.device == AVCaptureDevicePositionFront) {
        blurView.layer.affineTransform = CGAffineTransformMakeScale(-1, 1);
    }
    [_recorder.previewLayer addSublayer:blurView.layer];
    self.blurCameraView = blurView;
    
    CGFloat blurShowDuration = 0.1;
    duration -= blurShowDuration;
    
    blurView.alpha = 0;
    [UIView animateWithDuration:blurShowDuration animations:^{
        blurView.alpha = 1.0f;
    }];
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self hideBlurEffect:blurView];
        self.blurCameraView = nil;
    });
    
}

- (void)hideBlurEffect:(UIView *)view {
    
    view.alpha = 1.f;
    CGFloat blurHideDuration = 0.1;
    @weakify(view);
    [UIView animateWithDuration:blurHideDuration animations:^{
        @strongify(view);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        @strongify(view);
        [view.layer removeFromSuperlayer];
    }];
    
}


- (void)recorder:(SCRecorder *)recorder didCompleteSession:(SCRecordSession *)session {
    NSLog(@"didCompleteSession!");
}


- (void)recorder:(SCRecorder *)recorder didCompleteSegment:(SCRecordSessionSegment *)segment inSession:(SCRecordSession *)session error:(NSError *)error {
    NSLog(@"didCompleteSegment!");
    
    if (self.recordedVideo) {
        self.recordedVideo(session.assetRepresentingSegments);
        self.recordedVideo = nil;
    }
}


@end
