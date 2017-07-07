//
//  ITMediaEditorViewController.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 01/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import "ITMediaEditorViewController.h"
#import "ITMediaEditor.h"
#import "ITColorsPanelViewController.h"
#import "ITLayerAnimator.h"
#import "UITextView+ShowappStyles.h"

@interface ITMediaEditorViewController () <UITextViewDelegate, ITMediaEditorDelegate>

@property (strong, nonatomic) ITMediaEditor *mediaEditor;

@property (weak, nonatomic) IBOutlet ITEditingAreaView *areaView;
@property (weak, nonatomic) IBOutlet UIView *topButtonsView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *trashButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;

@property (strong, nonatomic) ITColorsPanelViewController *colorsVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorsPanelBottom;

@property (copy, nonatomic) ITMediaEditCompletion editCompletion;
@property (copy, nonatomic) ITMediaEditDidDrag dragHandler;
@property (copy, nonatomic) ITMediaEditDidShowTrash didShowTrash;

@end


static const NSUInteger maxInputTextLength = 500;


@implementation ITMediaEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mediaEditor = [[ITMediaEditor alloc] initWithArea:self.areaView];
    self.mediaEditor.state = ITMediaEditorStateDefault;
    
    self.mediaEditor.delegate = self;
    
    [self hideTextView];
    [self hideTopButtons];
    [self hideColorsPanel];
    [self hideTrash];
    
    //self.mediaEditor.trashFrame = self.trashButton.frame;
    [self.cancelButton setImage:nil forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLocalizedString(@"alert.cancel", @"Cancel") forState:UIControlStateNormal];
    [self.textView setDefaultTextStyle:[ITTextStyle textStyleDarkTitle1]];
    
    @weakify(self);
    self.colorsVC.didSelectColor = ^(UIColor *color) {
        @strongify(self);
        [self.mediaEditor choiceColor:color];
        self.textView.textColor = color;
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/*
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //
}*/


#pragma mark - Public


- (void)goTextEdit:(ITMediaEditCompletion)completion {
    self.editCompletion = completion;
    
    self.mediaEditor.state = ITMediaEditorStateText;
    [self showTopButtons];
    [self showColorsPanel];
    [self hideUndoButton];
    [self showTextView];
}


- (void)goPaintEdit:(ITMediaEditCompletion)completion {
    self.editCompletion = completion;
    
    self.mediaEditor.state = ITMediaEditorStatePaint;
    [self showTopButtons];
    [self showColorsPanel];
    [self checkForPaintedItems];
    //[self removeEditedLayers];
    [self.mediaEditor beginPaintObject];
    
}


- (void)goEmojiEdit:(ITMediaEditCompletion)completion {
    self.editCompletion = completion;
    
    self.mediaEditor.state = ITMediaEditorStateStickers;
    [self showTopButtons];
    [self showColorsPanel];
    [self hideUndoButton];
    [self showTextView];
    
    //[self showEmojiCollection];
}


- (void)trackDragging:(ITMediaEditDidDrag)drag {
    self.dragHandler = drag;
}


- (void)trackShowingTrash:(ITMediaEditDidShowTrash)didShow {
    self.didShowTrash = didShow;
}


- (void)setupContentSize:(CGSize)size {
    
    CGFloat contentScale = size.width / self.areaView.bounds.size.width;
    contentScale *= [[UIScreen mainScreen] scale];
    self.areaView.layer.contentsScale = contentScale;
    self.mediaEditor.contentScale = contentScale;
}


- (UIImage *)overlayImage:(CGSize)size {
    UIImage *image = [self.mediaEditor renderOverlayImage:size];
    
    return image;
}


- (void)removeEditedLayers {
    [self.mediaEditor removeEditedLayers];
}


- (void)removeEditedViews {
    [self.mediaEditor removeEditedViews];
}


#pragma mark - Private

- (void)showEmojiCollection {
    
    [self.mediaEditor addEmojiObject:@"jjj☺️🔥"];
}


- (void)showTextView {
    
    self.textView.hidden = NO;
    self.textView.text = nil;
    
    [self.textView becomeFirstResponder];
}


- (void)hideTextView {
    
    self.textView.hidden = YES;
    [self.textView resignFirstResponder];
}


- (void)showTopButtons {
    self.topButtonsView.hidden = NO;
}


- (void)hideTopButtons {
    self.topButtonsView.hidden = YES;
}


- (void)showColorsPanel {
    
    CGFloat bottom = 0;
    self.colorsPanelBottom.constant = bottom;
    self.colorsVC.view.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self.colorsVC selectDefaultColor];
    }];
}


- (void)hideColorsPanel {
    
    CGFloat bottom = - self.colorsVC.view.bounds.size.height;
    self.colorsPanelBottom.constant = bottom;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        self.colorsVC.view.hidden = YES;
    }];
}


- (void)showTrash {
    self.trashButton.hidden = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CALayer *layer = self.trashButton.layer;
        ITLayerAnimator *animator = [ITLayerAnimator new];
        [animator animateSpringRotationX:layer from:3.14/2];
    });
}


- (void)hideTrash {
    self.trashButton.hidden = YES;
    
    CALayer *layer = self.trashButton.layer;
    ITLayerAnimator *animator = [ITLayerAnimator new];
    [animator animateSpringRotationX:layer to:3.14/2];
}


- (void)showUndoButton {
    self.undoButton.hidden = NO;
}


- (void)hideUndoButton {
    self.undoButton.hidden = YES;
}


- (void)checkForPaintedItems {
    
    if ([self.mediaEditor hasPaintedLayers]) {
        [self showUndoButton];
    } else {
        [self hideUndoButton];
    }
}


- (void)addTextToEditor {
    
    NSString *text = self.textView.text;
    
    if (text.length) {
        [self.mediaEditor addTextObject:self.textView];
    }
}


- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary* info = notification.userInfo;
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSUInteger animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.colorsPanelBottom.constant = 0;
    [self.view layoutIfNeeded];
    
    self.colorsPanelBottom.constant = keyboardSize.height;
    
    [UIView animateWithDuration:duration delay:0 options:animationCurve animations:^{
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        //
    }];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    self.colorsPanelBottom.constant = 0;
    
    NSDictionary* info = notification.userInfo;
    //CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSUInteger animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.colorsVC.view.hidden = YES;
    
    [UIView animateWithDuration:duration delay:0 options:animationCurve animations:^{
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        //
    }];
}


#pragma mark - Actions


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = touches.anyObject;
    [self.mediaEditor selectCurrentObject:[touch locationInView:self.areaView]];
    //NSLog(@"touchesBegan: %@", touches);
}


- (IBAction)doneAction:(id)sender {
    
    if (self.textView.hidden == NO) {
        [self addTextToEditor];
    }
    
    [self hideTopButtons];
    [self hideColorsPanel];
    [self hideTextView];
    self.mediaEditor.state = ITMediaEditorStateDefault;
    
    if (self.editCompletion) {
        self.editCompletion();
        self.editCompletion = nil;
    }
}


- (IBAction)undoAction:(id)sender {
    
    BOOL done = [self.mediaEditor undoAction];
    
    if (done) {
        //performed if no one painted layer
        [self checkForPaintedItems];
    }
}


- (IBAction)cancelAction:(id)sender {
    
    [self.mediaEditor cancelAction];
    
    [self hideTopButtons];
    [self hideColorsPanel];
    [self hideTextView];
    
    self.mediaEditor.state = ITMediaEditorStateDefault;
    
    if (self.editCompletion) {
        self.editCompletion();
        self.editCompletion = nil;
    }
}

/* //old impl.
- (IBAction)cancelAction:(id)sender {
    
    BOOL done = [self.mediaEditor cancelAction];
    
    if (done) {
        [self hideTopButtons];
        [self hideColorsPanel];
        [self hideTextView];
        
        self.mediaEditor.state = ITMediaEditorStateDefault;
        
        if (self.editCompletion) {
            self.editCompletion();
            self.editCompletion = nil;
        }
    }
}*/


- (IBAction)pinchGestureAction:(UIPinchGestureRecognizer *)gesture {
    NSLog(@"Pinch: %f, %f", gesture.scale, gesture.velocity);
    
    [self.mediaEditor handlePinchGesture:gesture];
}


- (IBAction)rotationGestureAction:(UIRotationGestureRecognizer *)gesture {
    NSLog(@"Rotate: %f, %f", gesture.rotation, gesture.velocity);
    
    [self.mediaEditor handleRotateGesture:gesture];
}


- (IBAction)panGestureAction:(UIPanGestureRecognizer *)gesture {
    //NSLog(@"Rotate: %f, %f", gesture.rotation, gesture.velocity);
    
    [self.mediaEditor handlePanGesture:gesture];
    [self checkForPaintedItems];
    
    if (self.dragHandler) {
        self.dragHandler(gesture, self.mediaEditor.state);
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}



#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    self.textView.hidden = YES;
    
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *originText = textView.text;
    NSString *newText = [originText stringByReplacingCharactersInRange:range withString:text];
    
    NSLog(@"Added text length: %li", (unsigned long)newText.length);
    if (newText.length > originText.length && newText.length >= maxInputTextLength) {
        return NO;
    }
    
    return YES;
}


#pragma mark - ITMediaEditorDelegate

- (CGRect)trashFrameForMediaEditor:(ITMediaEditor *)editor {
    return self.trashButton.frame;
}

- (void)mediaEditor:(ITMediaEditor *)editor showTrash:(BOOL)showTrash {
    
    if (showTrash) {
        [self showTrash];
    } else {
        [self hideTrash];
    }
    
    if (self.didShowTrash) {
        self.didShowTrash(showTrash);
    }
}

- (void)mediaEditor:(ITMediaEditor *)editor highlightTrash:(BOOL)highlightTrash {
    
    CALayer *layer = self.trashButton.layer;
    ITLayerAnimator *animator = [ITLayerAnimator new];
    
    if (highlightTrash) {
        [animator animateSpringScale:layer from:1 to:1.25];
    } else {
        [animator animateSpringScale:layer from:1.25 to:1];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"colors"]) {
        self.colorsVC = [segue destinationViewController];
    }
}


@end
