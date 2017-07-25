//
//  ITMediaEditorViewController.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 01/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAGMediaEditor.h"
#import "MAGMediaEditorPresenter.h"

//typedef void(^MAGMediaEditCompletion)();
//typedef void(^MAGMediaEditDidDrag)(UIPanGestureRecognizer *recognizer, MAGMediaEditorState state);
//typedef void(^MAGMediaEditDidShowTrash)(BOOL show);

@interface MAGMediaEditorViewController : UIViewController <MAGMediaEditorVCProtocol>

//- (void)goTextEdit:(MAGMediaEditCompletion)completion;
//- (void)goPaintEdit:(MAGMediaEditCompletion)completion;
//- (void)goEmojiEdit:(MAGMediaEditCompletion)completion;

//- (void)trackDragging:(MAGMediaEditDidDrag)drag;
//- (void)trackShowingTrash:(MAGMediaEditDidShowTrash)didShow;

//- (void)setupContentSize:(CGSize)size;
//- (UIImage *)overlayImage:(CGSize)size;

@end
