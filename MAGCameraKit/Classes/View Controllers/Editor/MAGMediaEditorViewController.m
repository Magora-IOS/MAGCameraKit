//
//  ITMediaEditorViewController.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 01/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import "MAGMediaEditorViewController.h"
#import "MAGColorsPanelViewController.h"
#import "MAGLayerAnimator.h"
#import "MAGCameraKitCommon.h"


@interface MAGMediaEditorViewController () <UITextViewDelegate, MAGMediaEditorDelegate>


@property (weak, nonatomic) IBOutlet MAGEditingAreaView *areaView;
@property (weak, nonatomic) IBOutlet UIView *topButtonsView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *trashButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;

@property (strong, nonatomic) MAGColorsPanelViewController *colorsVC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorsPanelBottom;

//@property (copy, nonatomic) MAGMediaEditCompletion editCompletion;
//@property (copy, nonatomic) MAGMediaEditDidDrag dragHandler;
//@property (copy, nonatomic) MAGMediaEditDidShowTrash didShowTrash;

@end


static const NSUInteger maxInputTextLength = 500;


@implementation MAGMediaEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
    self.mediaEditor = [[MAGMediaEditor alloc] initWithArea:self.areaView];
    self.mediaEditor.state = MAGMediaEditorStateDefault;
    
    self.mediaEditor.delegate = self;
    */
    [self.presenter configureWithAreaView:self.areaView];
    
    [self hideTextView];
    [self hideTopButtons];
    [self hideColorsPanel];
    [self hideTrash];
    
    ////self.mediaEditor.trashFrame = self.trashButton.frame;
    //[self.cancelButton setImage:nil forState:UIControlStateNormal];
    //[self.cancelButton setTitle:NSLocalizedString(@"alert.cancel", @"Cancel") forState:UIControlStateNormal];
    //[self.textView setDefaultTextStyle:[ITTextStyle textStyleDarkTitle1]];
    
    @weakify(self);
    self.colorsVC.didSelectColor = ^(UIColor *color) {
        @strongify(self);
        [self.presenter choiceColor:color];
        self.textView.textColor = color;
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Public



#pragma mark - Private
/*
- (void)showEmojiCollection {
    
    [self.mediaEditor addEmojiObject:@"jjj☺️🔥"];
}*/


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
        MAGLayerAnimator *animator = [MAGLayerAnimator new];
        [animator animateSpringRotationX:layer from:3.14/2];
    });
}


- (void)hideTrash {
    self.trashButton.hidden = YES;
    
    CALayer *layer = self.trashButton.layer;
    MAGLayerAnimator *animator = [MAGLayerAnimator new];
    [animator animateSpringRotationX:layer to:3.14/2];
}


- (void)showUndoButton {
    self.undoButton.hidden = NO;
}


- (void)hideUndoButton {
    self.undoButton.hidden = YES;
}

/*
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
*/

- (UITextView *)editorTextView {
    return self.textView;
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
    
    [self.presenter touchesBeganAction:touches];
    /*
    UITouch *touch = touches.anyObject;
    [self.mediaEditor selectCurrentObject:[touch locationInView:self.areaView]];
    */
    //NSLog(@"touchesBegan: %@", touches);
}


- (IBAction)doneAction:(id)sender {
    [self.presenter completeAction];
    /*
    if (self.textView.hidden == NO) {
        [self addTextToEditor];
    }
    
    [self hideTopButtons];
    [self hideColorsPanel];
    [self hideTextView];
    self.mediaEditor.state = MAGMediaEditorStateDefault;
    
    if (self.editCompletion) {
        self.editCompletion();
        self.editCompletion = nil;
    }*/
}


- (IBAction)undoAction:(id)sender {
    [self.presenter undoAction];
    /*
    BOOL done = [self.mediaEditor undoAction];
    
    if (done) {
        //performed if no one painted layer
        [self checkForPaintedItems];
    }
    */
}


- (IBAction)cancelAction:(id)sender {
    [self.presenter cancelAction];
    /*
    [self.mediaEditor cancelAction];
    
    [self hideTopButtons];
    [self hideColorsPanel];
    [self hideTextView];
    
    self.mediaEditor.state = MAGMediaEditorStateDefault;
    
    if (self.editCompletion) {
        self.editCompletion();
        self.editCompletion = nil;
    }*/
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
    
    //[self.mediaEditor handlePinchGesture:gesture];
    [self.presenter pinchGestureAction:gesture];
}


- (IBAction)rotationGestureAction:(UIRotationGestureRecognizer *)gesture {
    NSLog(@"Rotate: %f, %f", gesture.rotation, gesture.velocity);
    
    //[self.mediaEditor handleRotateGesture:gesture];
    [self.presenter rotationGestureAction:gesture];
}


- (IBAction)panGestureAction:(UIPanGestureRecognizer *)gesture {
    //NSLog(@"Rotate: %f, %f", gesture.rotation, gesture.velocity);
    
    [self.presenter panGestureAction:gesture];
    /*
    [self.mediaEditor handlePanGesture:gesture];
    [self checkForPaintedItems];
    
    if (self.dragHandler) {
        self.dragHandler(gesture, self.mediaEditor.state);
    }*/
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}



- (CGRect)trashFrame {
    return self.trashButton.frame;
}


- (void)highlightTrash:(BOOL)highlight {
    
    CALayer *layer = self.trashButton.layer;
    MAGLayerAnimator *animator = [MAGLayerAnimator new];
    
    if (highlight) {
        [animator animateSpringScale:layer from:1 to:1.25];
    } else {
        [animator animateSpringScale:layer from:1.25 to:1];
    }
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"colors"]) {
        self.colorsVC = [segue destinationViewController];
    }
}


@end
