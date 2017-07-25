//
//  ITCameraPreviewViewController.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 05/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "MAGMediaPreviewViewController.h"
#include "MAGMediaEditorViewController.h"
//#include "MAGMediaPlayer.h"
#include "MAGLayerAnimator.h"
#import "MAGCameraKitCommon.h"
#import "MAGMediaPlayerView.h"
#import "MAGMediaFilterView.h"

#import <SVProgressHUD/SVProgressHUD.h>


@interface MAGMediaPreviewViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet MAGMediaFilterView *filterView;
@property (weak, nonatomic) IBOutlet MAGMediaPlayerView *playerView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton; //will deprecate
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *retakeButton;

@property (weak, nonatomic) IBOutlet UIView *topButtonsView;
//@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneButtonRight;

@property (strong, nonatomic) MAGMediaEditorViewController *editorVC;
@property (weak, nonatomic) IBOutlet UIView *editorView;


@end


@implementation MAGMediaPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.mediaPlayer = [[MAGMediaPlayer alloc] initWithFilterView:self.filterView playerView:self.playerView];
    [self.presenter configurePlayerView:self.playerView filterView:self.filterView];
    
    ////[self showPopButtonsAnimation];
    [self hideCompleteButton];
    
    //[self setupTrackShowingTrash];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

/*
- (void)showRecordSession:(MAGRecordSession *)recordSession {
    
    [self.presenter configureRecordSesion:recordSession];
    [self.presenter playMedia];
    
    [self.coordinator clearEditorVC];
    
    //[self showPushButtonsAnimation];
    [self showCompleteButton];
}
*/
/*
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
}*/


- (void)showTopButtons {
    self.topButtonsView.hidden = NO;
}


- (void)hideTopButtons {
    self.topButtonsView.hidden = YES;
}


- (void)showCompleteButton {
    self.completeButton.enabled = YES;
    
    CGFloat rotation = 3.14/2;
    MAGLayerAnimator *animator = [MAGLayerAnimator new];
    animator.duration  = 0.3;
    [animator animateSpringRotationY:self.completeButton.imageView.layer from:rotation];
}


- (void)hideCompleteButton {
    self.completeButton.enabled = NO;
    
    CGFloat rotation = 3.14/2;
    MAGLayerAnimator *animator = [MAGLayerAnimator new];
    animator.duration  = 0.1;
    [animator animateSpringRotationX:self.completeButton.imageView.layer to:rotation];
}


- (IBAction)actionCancel:(id)sender {
    [self.presenter cancelAction];
    
}


- (IBAction)actionComplete:(id)sender {
    
    [self.presenter completeAction];
    /*
    CGSize mediaSize = [self.mediaPlayer.recordSession mediaSize];
    UIImage *overlayImage = nil;
    
    overlayImage = [self.editorVC overlayImage:mediaSize];
    self.mediaPlayer.recordSession.overlayImage = overlayImage;
    [self.mediaPlayer pause];
    
    @weakify(self);
    [self.mediaPlayer exportMediaItem:^(MAGMediaPickerItem *item, NSError *error) {
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
    */
}


- (IBAction)actionText:(id)sender {
    //[self.presenter textEditAction];
    [self.coordinator openTextEdit];
}


- (IBAction)actionPaint:(id)sender {
    //[self.presenter paitAction];
    [self.coordinator openPaintEdit];
    
    //self.imageView.image = [self.editorVC overlayImage];
    //[self.editorVC removeEditedLayers];
}


- (IBAction)actionEmoji:(id)sender {
    //[self.presenter emojiEditAction];
    [self.coordinator openEmojiEdit];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.coordinator prepareForSegue:segue];
    /*
    if ([segue.identifier isEqualToString:@"Editor"]) {
        self.editorVC = segue.destinationViewController;
    }*/
}


- (void)showErrorMessage:(NSString *)message {
    [SVProgressHUD showErrorWithStatus:message];
}




@end
