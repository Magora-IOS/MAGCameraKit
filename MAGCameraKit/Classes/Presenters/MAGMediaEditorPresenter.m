//
//  MAGMediaEditorPresenter.m
//  Pods
//
//  Created by Stepanov Evgeniy on 19/07/2017.
//
//

#import "MAGMediaEditorPresenter.h"

@interface MAGMediaEditorPresenter () <MAGMediaEditorDelegate>

@property (strong, nonatomic) MAGMediaEditor *mediaEditor;
//@property (copy, nonatomic) MAGMediaEditCompletion editCompletion;
@property (copy, nonatomic) MAGMediaEditDidDrag dragHandler;
@property (copy, nonatomic) MAGMediaEditDidShowTrash didShowTrash;

@end


@implementation MAGMediaEditorPresenter


- (void)configureWithAreaView:(MAGEditingAreaView *)view {
    self.mediaEditor = [[MAGMediaEditor alloc] initWithArea:view];
    self.mediaEditor.state = MAGMediaEditorStateDefault;
    self.mediaEditor.delegate = self;
}


- (UIImage *)overlayImage:(CGSize)size {
    UIImage *image = [self.mediaEditor renderOverlayImage:size];
    
    return image;
}


- (void)choiceColor:(UIColor *)color {
    [self.mediaEditor choiceColor:color];
}


- (void)setupContentSize:(CGSize)size {
    [self.mediaEditor configureContentSize:size];
}


- (void)openTextEdit {
    //self.completed = completion;
    
    self.mediaEditor.state = MAGMediaEditorStateText;
    [self.viewController showTopButtons];
    [self.viewController showColorsPanel];
    [self.viewController hideUndoButton];
    [self.viewController showTextView];
}


- (void)openPaintEdit {
    //self.completed = completion;
    
    self.mediaEditor.state = MAGMediaEditorStatePaint;
    [self.viewController showTopButtons];
    [self.viewController showColorsPanel];
    [self checkForPaintedItems];
    //[self removeEditedLayers];
    [self.mediaEditor beginPaintObject];
    
}


- (void)openEmojiEdit {
    //self.completed = completion;
    
    self.mediaEditor.state = MAGMediaEditorStateStickers;
    [self.viewController showTopButtons];
    [self.viewController showColorsPanel];
    [self.viewController hideUndoButton];
    [self.viewController showTextView];
    
    //[self showEmojiCollection];
}


- (void)removeEditedLayers {
    [self.mediaEditor removeEditedLayers];
}


- (void)removeEditedViews {
    [self.mediaEditor removeEditedViews];
}


- (void)touchesBeganAction:(NSSet<UITouch *> *)touches {
    UITouch *touch = touches.anyObject;
    [self.mediaEditor selectObjectWithTouch:touch];
}


- (void)panGestureAction:(UIPanGestureRecognizer *)recognizer {
    [self.mediaEditor handlePanGesture:recognizer];
    [self checkForPaintedItems];
    
    if (self.dragHandler) {
        self.dragHandler(recognizer, self.mediaEditor.state);
    }
}


- (void)pinchGestureAction:(UIPinchGestureRecognizer *)recognizer {
    [self.mediaEditor handlePinchGesture:recognizer];
}


- (void)rotationGestureAction:(UIRotationGestureRecognizer *)recognizer {
    [self.mediaEditor handleRotateGesture:recognizer];
}


- (void)observeDragging:(MAGMediaEditDidDrag)drag {
    self.dragHandler = drag;
}


- (void)observeShowingTrash:(MAGMediaEditDidShowTrash)didShow {
    self.didShowTrash = didShow;
}



- (void)checkForPaintedItems {
    
    if ([self.mediaEditor hasPaintedLayers]) {
        [self.viewController showUndoButton];
    } else {
        [self.viewController hideUndoButton];
    }
}


- (void)addTextToEditor {
    
    UITextView *textView = [self.viewController editorTextView];
    NSString *text = textView.text;
    
    if (text.length) {
        [self.mediaEditor addTextObject:textView];
    }
}


- (void)completeAction {
    
    /*if (self.textView.hidden == NO) {
        [self addTextToEditor];
    }*/
    
    if (self.mediaEditor.state == MAGMediaEditorStateText || self.mediaEditor.state == MAGMediaEditorStateStickers) {
        [self addTextToEditor];
    }
    
    [self.viewController hideTopButtons];
    [self.viewController hideColorsPanel];
    [self.viewController hideTextView];
    self.mediaEditor.state = MAGMediaEditorStateDefault;
    
    if (self.completed) {
        self.completed();
        self.completed = nil;
    }
}


- (void)cancelAction {
    [self.mediaEditor cancelAction];
    
    [self.viewController hideTopButtons];
    [self.viewController hideColorsPanel];
    [self.viewController hideTextView];
    
    self.mediaEditor.state = MAGMediaEditorStateDefault;
    
    if (self.cancelled) {
        self.cancelled();
        self.cancelled = nil;
    }
}


- (void)undoAction {
    BOOL done = [self.mediaEditor undoAction];
    
    if (done) {
        //performed if no one painted layer
        [self checkForPaintedItems];
    }
}


#pragma mark - MAGMediaEditorDelegate

- (CGRect)trashFrameForMediaEditor:(MAGMediaEditor *)editor {
    return [self.viewController trashFrame];
}

- (void)mediaEditor:(MAGMediaEditor *)editor showTrash:(BOOL)showTrash {
    
    if (showTrash) {
        [self.viewController showTrash];
    } else {
        [self.viewController hideTrash];
    }
    
    if (self.didShowTrash) {
        self.didShowTrash(showTrash);
    }
}

- (void)mediaEditor:(MAGMediaEditor *)editor highlightTrash:(BOOL)highlightTrash {
    
    [self.viewController highlightTrash:highlightTrash];
}


@end
