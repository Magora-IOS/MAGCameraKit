//
//  ITCameraViewController.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 30/11/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "MAGCameraViewController.h"
#import "MAGRecAnimationView.h"

#import "MAGCameraKitCommon.h"

@interface MAGCameraViewController ()

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *previewView;

//@property (strong, nonatomic) NSDate *lastTapDate;
@property (assign, nonatomic) MAGFlashMode flashMode;
//@property (strong, nonatomic) RBVolumeButtons *volumeButtons;

@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet MAGRecAnimationView *recordAnimationView;

@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapRecognizer;

@end


@implementation MAGCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.presenter = [[ITCameraPresenter alloc] initWithCameraView:self.cameraView];
    //self.camera = [MAGCamera new];
    //self.camera.cameraView = self.cameraView;
    
    [self.presenter setupCameraView:self.cameraView];
    self.flashMode = MAGFlashModeAuto;
    
    self.recordAnimationView.recRadius = 50;
    self.recordAnimationView.maxRecDuration = 60;
    self.recordAnimationView.recDelaing = 0.5;
    
    [self.tapRecognizer requireGestureRecognizerToFail:self.doubleTapRecognizer];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //[self.presenter viewDidLayout];
    [self.presenter layoutCameraLayer];
}


- (void)onComplete {
    
}

- (void)onCancel {
    
}


- (void)setFlashMode:(MAGFlashMode)flashMode {
    _flashMode = flashMode;
    
    self.presenter.flashMode = flashMode;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    UIImage *imageFlashOff = [UIImage imageNamed:@"FlashOff" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage *imageFlashAuto = [UIImage imageNamed:@"FlashAuto" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage *imageFlashOn = [UIImage imageNamed:@"FlashOn" inBundle:bundle compatibleWithTraitCollection:nil];
    
    if (self.flashMode == MAGFlashModeOff) {
        [self.flashButton setImage:imageFlashOff forState:UIControlStateNormal];
        
    } else if (self.flashMode == MAGFlashModeAuto) {
        [self.flashButton setImage:imageFlashAuto forState:UIControlStateNormal];
        
    } else if (self.flashMode == MAGFlashModeOn) {
        [self.flashButton setImage:imageFlashOn forState:UIControlStateNormal];
    }
}



- (void)onSoundVolumeChanged {
    [self actionTap:nil];
}


- (void)onStartRecording {
    [self.recordAnimationView startProgress];
}

- (void)onStopRecording {
    [self.recordAnimationView stopProgress];
}


- (void)showPreview {
    
    self.cameraView.hidden = YES;
    self.previewView.hidden = NO;
    
    //[self suspendCamera];
    [self.presenter stopCameraSession];
    
    [UIView transitionWithView:self.previewView duration:0.3 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        [self.previewView layoutIfNeeded];
    } completion:^(BOOL finished) {
        //
    }];
}


- (void)hidePreview {
    self.cameraView.hidden = NO;
    self.previewView.hidden = YES;
    
    //[self awakeCamera];
    [self.presenter startCameraSession];
}

/*
- (void)suspendCamera {
    [self.presenter stopCameraSession];
}


- (void)awakeCamera {
    [self.presenter startCameraSession];
}
*/

/*
- (IBAction)actionRecTouchDown:(id)sender {
    self.lastTapDate = [NSDate date];
    
    [self.recordAnimationView showStartTapping];
}
*/
/*
- (IBAction)actionRecTouchUp:(id)sender {
    
    NSDate *now = [NSDate date];
    NSTimeInterval tapDelay = [now timeIntervalSinceDate:self.lastTapDate];
    
    if (tapDelay < 0.5) {
        [self takePhoto];
    }
    
    [self.recordAnimationView showEndTapping];
}
*/

- (IBAction)actionTapBegin:(id)sender {
    
    [self.recordAnimationView showStartTapping];
}


- (IBAction)actionTapCancel:(id)sender {
    
    if ([self.presenter isRecording] == NO) {
        [self.recordAnimationView showEndTapping];
    }
}


- (void)actionTap:(id)sender {
    
    [self.recordAnimationView showEndTapping];
    [self.presenter takePhotoAction];
    
    //if (self.camera.isRunning) {
    //    [self takePhoto];
    //}
}


- (IBAction)actionOneTap:(UITapGestureRecognizer *)recognizer {
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.recordAnimationView showStartTapping];
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            [self.recordAnimationView showEndTapping];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self actionTap:recognizer];
            break;
            
        default:
            break;
    }
}


- (IBAction)actionLongTap:(UILongPressGestureRecognizer *)recognizer {
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.presenter startRecordAction];
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            [self.recordAnimationView showEndTapping];
            [self.presenter stopRecordAction];
            break;
            
        default:
            break;
    }
}


- (IBAction)actionClose:(id)sender {
    [self.presenter closeAction];
}


- (IBAction)actionFlash:(id)sender {
    
    if (self.flashMode == MAGFlashModeOff) {
        self.flashMode = MAGFlashModeAuto;
        
    } else if (self.flashMode == MAGFlashModeAuto) {
        self.flashMode = MAGFlashModeOn;
        
    } else if (self.flashMode == MAGFlashModeOn) {
        self.flashMode = MAGFlashModeOff;
    }
}


- (IBAction)actionRotate:(id)sender {
    [self.presenter rotateCameraAction];
}


- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer {
    
    CGPoint point = [gestureRecognizer locationInView:self.cameraView];
    [self.presenter focusAndExposure:point];
}


- (IBAction)pinchGestureAction:(UIPinchGestureRecognizer *)gesture {
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self.presenter beginPinchZoom];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self.presenter changePinchZoom:gesture.scale];
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            //
            break;
            
        default:
            break;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
