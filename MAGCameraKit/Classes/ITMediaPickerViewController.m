//
//  ITMediaPickerViewController.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 06/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "ITMediaPickerViewController.h"
#import "ITCameraViewController.h"
#import "ITMediaPreviewViewController.h"
#import "ITMediaLibraryViewController.h"

@interface ITMediaPickerViewController ()

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIView *mediaView;

@property (weak, nonatomic) ITCameraViewController *cameraVC;
@property (weak, nonatomic) ITMediaPreviewViewController *previewVC;
@property (weak, nonatomic) ITMediaLibraryViewController *mediaVC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraBottom;
@property (weak, nonatomic) UIVisualEffectView *blurCameraView;


@end


@implementation ITMediaPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hidePreview];
    
    self.mediaVC.maxVideoDuration = 60;
    
    @weakify(self);
    [self.cameraVC setMediaRecorded:^(ITRecordSession *session) {
        @strongify(self);
        [self.previewVC showRecordSession:session];
        [self showPreview];
    }];
    
    [self.cameraVC setCancelled:^() {
        @strongify(self);
        [self.cameraVC removeRecordedSession];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    [self.previewVC setCancelled:^() {
        @strongify(self);
        [self.cameraVC removeRecordedSession];
        [self hidePreview];
    }];
    
    [self.previewVC setCompleted:^(ITMediaPickerItem *item) {
        @strongify(self);
        [self.cameraVC removeRecordedSession];
        if (self.presenter.completion) {
            self.presenter.completion(item);
        }
    }];
    
    
    [self.mediaVC setSelectedMediaItem:^(ITRecordSession *session) {
        @strongify(self);
        [self.previewVC showRecordSession:session];
        [self showPreview];
    }];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)showPreview {
    
    self.cameraView.hidden = YES;
    self.previewView.hidden = NO;
    
    [self suspendCamera];
    
    [UIView transitionWithView:self.previewView duration:0.3 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        [self.previewView layoutIfNeeded];
    } completion:^(BOOL finished) {
        //
    }];
}


- (void)hidePreview {
    self.cameraView.hidden = NO;
    self.previewView.hidden = YES;
    
    [self awakeCamera];
}


- (void)suspendCamera {
    [self.cameraVC stopSession];
}

- (void)awakeCamera {
    [self.cameraVC startSession];
}


- (void)showBlurCameraView {
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.cameraView.bounds;
    effectView.alpha = 0.0;
    
    [self.blurCameraView removeFromSuperview];
    self.blurCameraView = effectView;
    
    [self.cameraView addSubview:effectView];
    
    [UIView transitionWithView:effectView duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        effectView.alpha = 0.97;
    } completion:^(BOOL finished) {
        //
    }];
}


- (void)hideBlurCameraView {
    
    UIVisualEffectView *effectView = self.blurCameraView;
    
    [UIView transitionWithView:effectView duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        effectView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [effectView removeFromSuperview];
    }];
}


- (IBAction)actionCameraSwipedUp:(UISwipeGestureRecognizer *)recognizer {
    
    CGFloat cameraBottom = self.mediaView.bounds.size.height;
    if (self.cameraBottom.constant == cameraBottom) {
        return;
    }
    self.cameraBottom.constant = cameraBottom;
    
    [self showBlurCameraView];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self.mediaVC loadAssetsIfNeed];
    }];
}


- (IBAction)actionCameraSwipedDown:(UISwipeGestureRecognizer *)recognizer {
    
    CGFloat cameraBottom = 0;
    if (self.cameraBottom.constant == cameraBottom) {
        return;
    }
    self.cameraBottom.constant = cameraBottom;
    
    [self hideBlurCameraView];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //
    }];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Camera"]) {
        self.cameraVC = segue.destinationViewController;
        
    } else if ([segue.identifier isEqualToString:@"Preview"]) {
        self.previewVC = segue.destinationViewController;
        
    } else if ([segue.identifier isEqualToString:@"Media"]) {
        self.mediaVC = segue.destinationViewController;
    }
}


@end
