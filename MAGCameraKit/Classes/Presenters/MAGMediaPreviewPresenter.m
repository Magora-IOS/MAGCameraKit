//
//  MAGMediaPreviewPresenter.m
//  Pods
//
//  Created by Stepanov Evgeniy on 19/07/2017.
//
//

#import "MAGMediaPreviewPresenter.h"
#include "MAGMediaPlayer.h"
#include "MAGCameraKitCommon.h"


@interface MAGMediaPreviewPresenter ()

@property (strong, nonatomic) MAGMediaPlayer *mediaPlayer;

@end


@implementation MAGMediaPreviewPresenter


- (void)configurePlayerView:(MAGMediaPlayerView *)playerView filterView:(MAGMediaFilterView *)filterView {
    self.mediaPlayer = [[MAGMediaPlayer alloc] initWithFilterView:filterView playerView:playerView];
}


- (void)configureRecordSesion:(MAGRecordSession *)recordSession {
    self.mediaPlayer.recordSession = recordSession;
}


- (void)openRecordSession:(MAGRecordSession *)recordSession {
    [self configureRecordSesion:recordSession];
    [self playMedia];
    
    [self configureEditor];
    [self setupObserveShowingTrash];
    [self showControls];
}


- (void)playMedia {
    
    [self.mediaPlayer play];
}


- (void)configureEditor {
    [self.editorPresenter removeEditedViews];
    [self.editorPresenter removeEditedLayers];
    
    CGSize mediaSize = [self.mediaPlayer.recordSession mediaSize];
    [self.editorPresenter setupContentSize:mediaSize];
}


- (void)completeAction {
    
    CGSize mediaSize = [self.mediaPlayer.recordSession mediaSize];
    UIImage *overlayImage = nil;
    
    overlayImage = [self.editorPresenter overlayImage:mediaSize];
    self.mediaPlayer.recordSession.overlayImage = overlayImage;
    [self.mediaPlayer pause];
    
    @weakify(self);
    [self.mediaPlayer exportMediaItem:^(MAGMediaPickerItem *item, NSError *error) {
        @strongify(self);
        if (error) {
            [self.viewController showErrorMessage:error.localizedDescription];
        } else {
            if (item) {
                if (self.completed) {
                    self.completed(item);
                }
            }
        }
    }];
}


- (void)cancelAction {
    [self.mediaPlayer pause];
    
    if (self.cancelled) {
        self.cancelled();
    }
}


- (void)showControls {
    [self.viewController showTopButtons];
    [self.viewController showCompleteButton];
}


- (void)hideControls {
    [self.viewController hideTopButtons];
    [self.viewController hideCompleteButton];
}


- (void)textEditAction {
    //[self hideControls];
    /*
    @weakify(self);
    [self.editorPresenter openTextEdit:^{
        @strongify(self);
        [self showControls];
    }];*/
}


- (void)emojiEditAction {
    //[self hideControls];
    /*
    @weakify(self);
    [self.editorPresenter openEmojiEdit:^{
        @strongify(self);
        [self showControls];
    }];*/
}


- (void)paitAction {
    //[self hideControls];
    /*
    @weakify(self);
    [self.editorPresenter openPaintEdit:^{
        @strongify(self);
        [self showControls];
    }];*/
}


- (void)setupObserveShowingTrash {
    
    @weakify(self);
    [self.editorPresenter observeShowingTrash:^(BOOL show) {
        @strongify(self);
        
        if (show) {
            [self.viewController hideCompleteButton];
        } else {
            [self.viewController showCompleteButton];
        }
    }];
}


@end
