//
//  ITCameraViewController.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 30/11/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "MAGCameraViewController.h"
#import "MAGRecAnimationView.h"

//#import "RBVolumeButtons.h"
#import "JPSVolumeButtonHandler.h"
#import "MAGCameraKitCommon.h"

@interface MAGCameraViewController ()

@property (weak, nonatomic) IBOutlet UIView *cameraView;

@property (strong, nonatomic) MAGCamera *camera;
@property (strong, nonatomic) NSDate *lastTapDate;
@property (assign, nonatomic) MAGFlashMode flasMode;
//@property (strong, nonatomic) RBVolumeButtons *volumeButtons;
@property (strong, nonatomic) JPSVolumeButtonHandler *volumeHandler;

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
    self.camera = [MAGCamera new];
    self.camera.cameraView = self.cameraView;
    self.flasMode = MAGFlashModeAuto;
    
    self.recordAnimationView.recRadius = 50;
    self.recordAnimationView.maxRecDuration = 60;
    self.recordAnimationView.recDelaing = 0.5;
    
    [self.tapRecognizer requireGestureRecognizerToFail:self.doubleTapRecognizer];
    
    //[self sibscribeToSoundVolumeButtons];
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
    [self.camera layoutCameraLayer];
}



- (void)setFlasMode:(MAGFlashMode)flasMode {
    _flasMode = flasMode;
    
    self.camera.flashMode = flasMode;
    
    //self.flashButton.highlighted = (self.flasMode == ITFlashModeAuto);
    //self.flashButton.selected = (self.flasMode == ITFlashModeOn);
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    UIImage *imageFlashOff = [UIImage imageNamed:@"FlashOff" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage *imageFlashAuto = [UIImage imageNamed:@"FlashAuto" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage *imageFlashOn = [UIImage imageNamed:@"FlashOn" inBundle:bundle compatibleWithTraitCollection:nil];
    
    if (self.flasMode == MAGFlashModeOff) {
        [self.flashButton setImage:imageFlashOff forState:UIControlStateNormal];
        
    } else if (self.flasMode == MAGFlashModeAuto) {
        [self.flashButton setImage:imageFlashAuto forState:UIControlStateNormal];
        
    } else if (self.flasMode == MAGFlashModeOn) {
        [self.flashButton setImage:imageFlashOn forState:UIControlStateNormal];
    }
}


- (void)sibscribeToSoundVolumeButtons {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soundVolumeChanged:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    
}



- (void)setupVolumeHandler {
    
    @weakify(self);
    self.volumeHandler = [JPSVolumeButtonHandler volumeButtonHandlerWithUpBlock:^{
        @strongify(self);
        [self actionTap:nil];
        
    } downBlock:^{
        @strongify(self);
        [self actionTap:nil];
    }];
}


- (void)takePhoto {
    
    [self.recordAnimationView showEndTapping];
    @weakify(self);
    [self.camera takePhoto:^(UIImage *image) {
        @strongify(self);
        MAGRecordSession *item = nil;
        
        if (image) {
            item = [MAGRecordSession new];
            //item.type = ITMediaTypeImage;
            item.photoImage = image;
        }
        
        if (self.mediaRecorded && item) {
            self.mediaRecorded(item);
        }
    }];
}


- (void)startRec {
    @weakify(self);
    [self.camera startRecording:^(AVAsset *asset) {
        @strongify(self);
        
        [self.recordAnimationView stopProgress];
        [self restoreFlashLight];
        
        MAGRecordSession *item = [MAGRecordSession new];
        item.videoAsset = asset;
        
        if (self.mediaRecorded) {
            self.mediaRecorded(item);
        }
    }];
    
    [self.recordAnimationView startProgress];
    [self setupFlashLight];
}


- (void)stopRec {
    [self.camera stopRecording];
    
    [self.recordAnimationView stopProgress];
    [self restoreFlashLight];
}


- (void)setupFlashLight {
    if (self.flasMode == MAGFlashModeOn) {
        self.flasMode = MAGFlashModeLight;
    }
}


- (void)restoreFlashLight {
    if (self.flasMode == MAGFlashModeLight) {
        self.flasMode = MAGFlashModeOn;
    }
}


- (void)startSession {
    
    //[self setupVolumeButtons];
    //[self.volumeButtons startStealingVolumeButtonEvents];
    
    [self setupVolumeHandler];
    [self.volumeHandler startHandler:YES];
    
    [self.camera startSession];
}


- (void)stopSession {
    [self.camera stopSession];
    
    //[self.volumeButtons stopStealingVolumeButtonEvents];
    //self.volumeButtons = nil;
    
    [self.volumeHandler stopHandler];
    self.volumeHandler = nil;
}


- (void)removeRecordedSession {
    [self.camera removeAllSessionSegments];
}


- (IBAction)actionRecTouchDown:(id)sender {
    self.lastTapDate = [NSDate date];
    
    [self.recordAnimationView showStartTapping];
}


- (IBAction)actionRecTouchUp:(id)sender {
    
    NSDate *now = [NSDate date];
    NSTimeInterval tapDelay = [now timeIntervalSinceDate:self.lastTapDate];
    
    if (tapDelay < 0.5) {
        [self takePhoto];
    }
    
    [self.recordAnimationView showEndTapping];
}


- (IBAction)actionTapBegin:(id)sender {
    
    [self.recordAnimationView showStartTapping];
}


- (IBAction)actionTapCancel:(id)sender {
    
    if ([self.camera isRecording] == NO) {
        [self.recordAnimationView showEndTapping];
    }
}


- (void)actionTap:(id)sender {
    
    if (self.camera.isRunning) {
        [self takePhoto];
    }
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
            [self startRec];
            break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            [self.recordAnimationView showEndTapping];
            [self stopRec];
            break;
            
        default:
            break;
    }
}


- (IBAction)actionClose:(id)sender {
    
    if (self.cancelled) {
        self.cancelled();
    }
}


- (IBAction)actionFlash:(id)sender {
    
    if (self.flasMode == MAGFlashModeOff) {
        self.flasMode = MAGFlashModeAuto;
        
    } else if (self.flasMode == MAGFlashModeAuto) {
        self.flasMode = MAGFlashModeOn;
        
    } else if (self.flasMode == MAGFlashModeOn) {
        self.flasMode = MAGFlashModeOff;
    }
}


- (IBAction)actionRotate:(id)sender {
    
    [self.camera rotateCamera];
}


- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.view];
    [self.camera focusAndExposure:point];
}


- (IBAction)soundVolumeChanged:(id)sender{
    
    NSNotification *notification = sender;
    NSString *reason = notification.userInfo[@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"];
    
    if ([reason isEqualToString:@"ExplicitVolumeChange"]) {
        if (self.camera.isRunning) {
            [self actionTap:sender];
        }
    }
}


- (IBAction)pinchGestureAction:(UIPinchGestureRecognizer *)gesture {
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self.camera beginPinchZoom];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self.camera changePinchZoom:gesture.scale];
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
