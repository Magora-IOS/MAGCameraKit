//
//  ITMediaEditorViewController.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 01/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITMediaEditor.h"

typedef void(^ITMediaEditCompletion)();
typedef void(^ITMediaEditDidDrag)(UIPanGestureRecognizer *recognizer, ITMediaEditorState state);
typedef void(^ITMediaEditDidShowTrash)(BOOL show);

@interface ITMediaEditorViewController : UIViewController

- (void)goTextEdit:(ITMediaEditCompletion)completion;
- (void)goPaintEdit:(ITMediaEditCompletion)completion;
- (void)goEmojiEdit:(ITMediaEditCompletion)completion;

- (void)trackDragging:(ITMediaEditDidDrag)drag;
- (void)trackShowingTrash:(ITMediaEditDidShowTrash)didShow;

- (void)setupContentSize:(CGSize)size;
- (UIImage *)overlayImage:(CGSize)size;
- (void)removeEditedLayers;
- (void)removeEditedViews;

@end
