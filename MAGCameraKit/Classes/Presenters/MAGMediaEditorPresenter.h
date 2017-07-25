//
//  MAGMediaEditorPresenter.h
//  Pods
//
//  Created by Stepanov Evgeniy on 19/07/2017.
//
//

#import <Foundation/Foundation.h>
#import "MAGEditingAreaView.h"
#import "MAGMediaEditor.h"


typedef void(^MAGMediaEditCompletion)();
typedef void(^MAGMediaEditDidDrag)(UIPanGestureRecognizer *recognizer, MAGMediaEditorState state);
typedef void(^MAGMediaEditDidShowTrash)(BOOL show);


@class MAGMediaEditorPresenter;
@class MAGCameraFlowCoordinator;

@protocol MAGMediaEditorVCProtocol <NSObject>

@property (strong, nonatomic) MAGMediaEditorPresenter *presenter;
@property (strong, nonatomic) MAGCameraFlowCoordinator *coordinator;

//- (void)trackShowingTrash:(MAGMediaEditDidShowTrash)didShow;
- (UITextView *)editorTextView;
- (CGRect)trashFrame;
- (void)highlightTrash:(BOOL)highlight;

- (void)showTextView;
- (void)hideTextView;
- (void)showTopButtons;
- (void)hideTopButtons;
- (void)showColorsPanel;
- (void)hideColorsPanel;
- (void)showTrash;
- (void)hideTrash;
- (void)showUndoButton;
- (void)hideUndoButton;

@end


@interface MAGMediaEditorPresenter : NSObject

@property (weak, nonatomic) UIViewController<MAGMediaEditorVCProtocol> *viewController;
@property (copy, nonatomic) MAGMediaEditCompletion completed;
@property (copy, nonatomic) MAGMediaEditCompletion cancelled;

- (void)configureWithAreaView:(MAGEditingAreaView *)view;

- (UIImage *)overlayImage:(CGSize)size;
- (void)choiceColor:(UIColor *)color;
- (void)setupContentSize:(CGSize)size;

- (void)openTextEdit;
- (void)openPaintEdit;
- (void)openEmojiEdit;

- (void)removeEditedLayers;
- (void)removeEditedViews;

- (void)touchesBeganAction:(NSSet<UITouch *> *)touches;
- (void)panGestureAction:(UIPanGestureRecognizer *)recognizer;
- (void)pinchGestureAction:(UIPinchGestureRecognizer *)recognizer;
- (void)rotationGestureAction:(UIRotationGestureRecognizer *)recognizer;

- (void)observeDragging:(MAGMediaEditDidDrag)drag;
- (void)observeShowingTrash:(MAGMediaEditDidShowTrash)didShow;

- (void)completeAction;
- (void)cancelAction;
- (void)undoAction;

@end
