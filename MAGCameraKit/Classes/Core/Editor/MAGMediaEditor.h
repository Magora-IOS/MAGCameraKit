//
//  ITMediaEditor.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 01/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAGEditingAreaView.h"

typedef enum : NSUInteger {
    MAGMediaEditorStateDefault,
    MAGMediaEditorStateText,
    MAGMediaEditorStateStickers,
    MAGMediaEditorStatePaint
} MAGMediaEditorState;


@class MAGMediaEditor;

@protocol MAGMediaEditorDelegate <NSObject>
@optional
- (CGRect)trashFrameForMediaEditor:(MAGMediaEditor *)editor;
- (void)mediaEditor:(MAGMediaEditor *)editor showTrash:(BOOL)showTrash;
- (void)mediaEditor:(MAGMediaEditor *)editor highlightTrash:(BOOL)highlightTrash;

@end


@interface MAGMediaEditor : NSObject

@property (copy, nonatomic) UIColor *selectedColor;
@property (assign, nonatomic) MAGMediaEditorState state;
@property (assign, nonatomic) CGFloat contentScale;
@property (assign, nonatomic) CGRect trashFrame;
@property (weak, nonatomic) id<MAGMediaEditorDelegate> delegate;

- (instancetype)initWithArea:(MAGEditingAreaView *)view;

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

- (void)selectObjectWithTouch:(UITouch *)touch;
- (void)selectCurrentObject:(CGPoint)point;
- (void)choiceColor:(UIColor *)color;
- (void)configureContentSize:(CGSize)size;

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer;
- (void)handleRotateGesture:(UIRotationGestureRecognizer *)recognizer;


@end
