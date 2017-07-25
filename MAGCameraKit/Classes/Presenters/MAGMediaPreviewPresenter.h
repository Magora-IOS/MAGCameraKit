//
//  MAGMediaPreviewPresenter.h
//  Pods
//
//  Created by Stepanov Evgeniy on 19/07/2017.
//
//

#import <Foundation/Foundation.h>
#import "MAGMediaPlayerView.h"
#import "MAGMediaFilterView.h"
#import "MAGRecordSession.h"
#import "MAGMediaEditorPresenter.h"


@class MAGMediaPreviewPresenter;
@class MAGCameraFlowCoordinator;


typedef void(^MAGMediaPreviewCompleted)(MAGMediaPickerItem *item);
typedef void(^MAGMediaPreviewCancelled)();


@protocol MAGMediaPreviewVCProtocol <NSObject>

@property (strong, nonatomic) MAGMediaPreviewPresenter *presenter;
@property (strong, nonatomic) MAGCameraFlowCoordinator *coordinator;

//- (void)showImage:(UIImage *)image;
//- (void)hideImage;

- (void)showTopButtons;
- (void)hideTopButtons;
- (void)showCompleteButton;
- (void)hideCompleteButton;

- (void)showErrorMessage:(NSString *)message;

@end


@interface MAGMediaPreviewPresenter : NSObject

@property (weak, nonatomic) UIViewController<MAGMediaPreviewVCProtocol> *viewController;

@property (weak, nonatomic) MAGMediaEditorPresenter *editorPresenter;
@property(copy, nonatomic) MAGMediaPreviewCompleted completed;
@property(copy, nonatomic) MAGMediaPreviewCancelled cancelled;

- (void)configurePlayerView:(MAGMediaPlayerView *)playerView filterView:(MAGMediaFilterView *)filterView;
- (void)configureRecordSesion:(MAGRecordSession *)recordSession;

- (void)openRecordSession:(MAGRecordSession *)recordSession;
- (void)playMedia;

- (void)completeAction;
- (void)cancelAction;

//- (void)textEditAction;
//- (void)emojiEditAction;
//- (void)paitAction;

- (void)showControls;
- (void)hideControls;

@end
