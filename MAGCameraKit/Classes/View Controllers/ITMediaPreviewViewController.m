//
//  ITCameraPreviewViewController.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 05/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "ITMediaPreviewViewController.h"
#include "ITMediaPlayer.h"
#include "ITMediaEditorViewController.h"
#include "ITLayerAnimator.h"
#import "MAGCameraKitCommon.h"

#import <SVProgressHUD/SVProgressHUD.h>


@interface ITMediaPreviewViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet SCSwipeableFilterView *filterView;
@property (weak, nonatomic) IBOutlet SCVideoPlayerView *playerView;
@property (strong, nonatomic) ITMediaPlayer *mediaPlayer;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton; //will deprecate
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *retakeButton;

@property (weak, nonatomic) IBOutlet UIView *topButtonsView;
//@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneButtonRight;

@property (strong, nonatomic) ITMediaEditorViewController *editorVC;
@property (weak, nonatomic) IBOutlet UIView *editorView;


@end


@implementation ITMediaPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mediaPlayer = [[ITMediaPlayer alloc] initWithFilterView:self.filterView playerView:self.playerView];
    
    [self.cancelButton setTitle:NSLocalizedString(@"camera.preview.cancel", @"Retake") forState:UIControlStateNormal];
    [self.uploadButton setTitle:NSLocalizedString(@"camera.preview.upload", @"Upload") forState:UIControlStateNormal];
    
    //[self.retakeButton setImage:nil forState:UIControlStateNormal];
    //[self.retakeButton setTitle:NSLocalizedString(@"camera.preview.cancel", @"Retake") forState:UIControlStateNormal];
    
    [self showPopButtonsAnimation];
    [self hideCompleteButton];
    
    [self setupTrackShowingTrash];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


- (void)showRecordSession:(ITRecordSession *)recordSession {
    
    self.mediaPlayer.recordSession = recordSession;
    
    SCFilter *emptyFilter = [SCFilter emptyFilter];
    emptyFilter.name = @"#nofilter";
    
    if (recordSession.photoImage) {
        self.imageView.image = recordSession.photoImage;
        self.imageView.hidden = NO;
        
    } else if (recordSession) {
        self.filterView.filters = @[emptyFilter];
        self.filterView.selectedFilter = emptyFilter;
        
        self.imageView.image = nil;
        self.imageView.hidden = YES;
        [self.mediaPlayer play];
        
    } else {
        //error
    }
    
    [self.editorVC removeEditedViews];
    [self.editorVC removeEditedLayers];
    
    CGSize mediaSize = [recordSession mediaSize];
    [self.editorVC setupContentSize:mediaSize];
    
    [self showPushButtonsAnimation];
    [self showCompleteButton];
}


- (void)setupTrackShowingTrash {
    
    @weakify(self);
    [self.editorVC trackShowingTrash:^(BOOL show) {
        @strongify(self);
        
        if (show) {
            [self hideCompleteButton];
        } else {
            [self showCompleteButton];
        }
    }];
}


- (void)showTopButtons {
    self.topButtonsView.hidden = NO;
}


- (void)hideTopButtons {
    self.topButtonsView.hidden = YES;
}


- (void)showCompleteButton {
    self.completeButton.enabled = YES;
    
    CGFloat rotation = 3.14/2;
    ITLayerAnimator *animator = [ITLayerAnimator new];
    animator.duration  = 0.3;
    [animator animateSpringRotationY:self.completeButton.imageView.layer from:rotation];
}


- (void)hideCompleteButton {
    self.completeButton.enabled = NO;
    
    CGFloat rotation = 3.14/2;
    ITLayerAnimator *animator = [ITLayerAnimator new];
    animator.duration  = 0.1;
    [animator animateSpringRotationX:self.completeButton.imageView.layer to:rotation];
}


- (IBAction)actionCancel:(id)sender {
    
    [self.mediaPlayer pause];
    
    if (self.cancelled) {
        self.cancelled();
    }
    
    [self showPopButtonsAnimation];
}


- (IBAction)actionComplete:(id)sender {
    
    CGSize mediaSize = [self.mediaPlayer.recordSession mediaSize];
    UIImage *overlayImage = nil;
    
    overlayImage = [self.editorVC overlayImage:mediaSize];
    self.mediaPlayer.recordSession.overlayImage = overlayImage;
    [self.mediaPlayer pause];
    
    @weakify(self);
    [self.mediaPlayer exportMediaItem:^(ITMediaPickerItem *item, NSError *error) {
        @strongify(self);
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        } else {
            if (item) {
                if (self.completed) {
                    self.completed(item);
                }
            }
        }
    }];
}


- (IBAction)actionText:(id)sender {
    [self hideTopButtons];
    [self showPopButtonsAnimation];
    [self hideCompleteButton];
    
    @weakify(self);
    [self.editorVC goTextEdit:^{
        @strongify(self);
        [self showTopButtons];
        [self showPushButtonsAnimation];
        [self showCompleteButton];
    }];
}


- (IBAction)actionPaint:(id)sender {
    [self hideTopButtons];
    [self showPopButtonsAnimation];
    [self hideCompleteButton];
    
    @weakify(self);
    [self.editorVC goPaintEdit:^{
        @strongify(self);
        [self showTopButtons];
        [self showPushButtonsAnimation];
        [self showCompleteButton];
    }];
    
    //self.imageView.image = [self.editorVC overlayImage];
    //[self.editorVC removeEditedLayers];
}


- (IBAction)actionEmoji:(id)sender {
    [self hideTopButtons];
    [self showPopButtonsAnimation];
    [self hideCompleteButton];
    
    @weakify(self);
    [self.editorVC goEmojiEdit:^{
        @strongify(self);
        [self showTopButtons];
        [self showPushButtonsAnimation];
        [self showCompleteButton];
    }];
}


- (void)showPushButtonsAnimation {
    
    CGFloat inset = 10;
    self.cancelButtonLeft.constant = inset;
    self.doneButtonRight.constant = inset;
    
    self.uploadButton.enabled = YES;
    self.cancelButton.enabled = YES;
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //
    }];
    
}


- (void)showPopButtonsAnimation {
    
    CGFloat inset = - ( self.cancelButton.frame.origin.x + self.cancelButton.bounds.size.width);
    self.cancelButtonLeft.constant = inset;
    self.doneButtonRight.constant = inset;
    
    self.uploadButton.enabled = NO;
    self.cancelButton.enabled = NO;
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Editor"]) {
        self.editorVC = segue.destinationViewController;
    }
}




@end
