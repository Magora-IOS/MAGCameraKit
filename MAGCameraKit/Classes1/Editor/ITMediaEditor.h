//
//  ITMediaEditor.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 01/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITEditingAreaView.h"

typedef enum : NSUInteger {
    ITMediaEditorStateDefault,
    ITMediaEditorStateText,
    ITMediaEditorStateStickers,
    ITMediaEditorStatePaint
} ITMediaEditorState;


@class ITMediaEditor;

@protocol ITMediaEditorDelegate <NSObject>
@optional
- (CGRect)trashFrameForMediaEditor:(ITMediaEditor *)editor;
- (void)mediaEditor:(ITMediaEditor *)editor showTrash:(BOOL)showTrash;
- (void)mediaEditor:(ITMediaEditor *)editor highlightTrash:(BOOL)highlightTrash;

@end


@interface ITMediaEditor : NSObject

@property (copy, nonatomic) UIColor *selectedColor;
@property (assign, nonatomic) ITMediaEditorState state;
@property (assign, nonatomic) CGFloat contentScale;
@property (assign, nonatomic) CGRect trashFrame;
@property (weak, nonatomic) id<ITMediaEditorDelegate> delegate;

- (instancetype)initWithArea:(ITEditingAreaView *)view;

- (void)addEmojiObject:(NSString *)text;
- (void)addTextObject:(UITextView *)textView;
- (void)beginPaintObject;

- (UIImage *)renderOverlayImage:(CGSize)size;
- (void)removeEditedLayers;
- (void)removeEditedViews;
- (void)removeToTrash;
- (void)cancelAction;
- (BOOL)undoAction;
- (BOOL)hasPaintedLayers;
- (BOOL)hasAddedViews;

- (void)selectCurrentObject:(CGPoint)point;
- (void)choiceColor:(UIColor *)color;

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer;
- (void)handleRotateGesture:(UIRotationGestureRecognizer *)recognizer;


@end
