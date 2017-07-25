//
//  ITMediaEditor.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 01/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import "MAGMediaEditor.h"
#import "MAGPainter.h"
#import "MAGGesturesViewTransformer.h"


@interface MAGMediaEditor ()

@property (weak, nonatomic) MAGEditingAreaView *areaView;
//@property (weak, nonatomic) CALayer *objectLayer;
@property (weak, nonatomic) UIView *objectView;

@property (strong, nonatomic) MAGPainter *painter;
@property (strong, nonatomic) MAGGesturesViewTransformer *viewTransformer;

@property (assign, nonatomic) BOOL isAboveTrash;

@end


static const CGFloat maxAddedTextHeight = 10000;


@implementation MAGMediaEditor


- (instancetype)initWithArea:(MAGEditingAreaView *)view {
    if (self = [super init]) {
        self.areaView = view;
        self.painter = [[MAGPainter alloc] initWithCanvas:view];
        self.viewTransformer = [MAGGesturesViewTransformer new];
    }
    
    return self;
}


- (void)addEmojiObject:(NSString *)text {
    
    UIImage *image = [self imageFromText:text size:70];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.layer.position = CGPointMake(170, 200);
    //imageView.layer.anchorPoint = CGPointMake(0, 0);
    
    imageView.center = CGPointMake(self.areaView.bounds.size.width / 2, self.areaView.bounds.size.height / 4);
    [self.areaView addSubview:imageView];
    
    //[self.areaView.layer addSublayer:imageView.layer];
    //self.objectLayer = imageView.layer;
}


- (void)addTextObject_old:(UITextView *)textView {
    
    UIImage *image = [self imageFromTextView:textView size:70];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

    imageView.center = CGPointMake(self.areaView.bounds.size.width / 2, self.areaView.bounds.size.height / 4);
    [self.areaView addSubview:imageView];
    
    //self.objectLayer = imageView.layer;
}


- (void)addTextObject:(UITextView *)textView {
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = textView.attributedText;
    textLayer.alignmentMode = @"center";
    textLayer.truncationMode = @"none";
    textLayer.contentsScale = self.contentScale;
    textLayer.wrapped = YES;
    
    CGSize boundSize = textView.bounds.size;
    boundSize.height = maxAddedTextHeight;
    
    CGRect rect = [textView.text boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textView.typingAttributes context:nil];
    textLayer.frame = CGRectMake(0, 0, ceil(rect.size.width), ceil(rect.size.height));
    
    UIView *view = [[UIView alloc] initWithFrame:textLayer.frame];
    [view.layer addSublayer:textLayer];
    view.center = CGPointMake(self.areaView.bounds.size.width / 2, self.areaView.bounds.size.height / 4);
    
    [self.areaView addSubview:view];
    //self.objectLayer = textLayer;
}


- (void)beginPaintObject {
    
    //[self.areaView setpath]
}


- (void)removeEditedLayers {
    /*
    NSArray *layers = [self.areaView.layer sublayers].copy;
    for (CALayer *layer in layers) {
        [layer removeFromSuperlayer];
    }*/
    
    [self.painter cancelAll];
}


- (void)removeEditedViews {
    
    NSArray *views = [self.areaView subviews].copy;
    for (UIView *view in views) {
        [view removeFromSuperview];
    }
}


- (void)removeToTrash {
    
    [self.objectView removeFromSuperview];
    self.isAboveTrash = NO;
}


- (void)cancelAction {
    
    if (self.state == MAGMediaEditorStatePaint) {
        [self.painter cancelAll];
    }
}


- (BOOL)undoAction {
    
    if (self.state == MAGMediaEditorStatePaint) {
        [self.painter cancel];
        
        if ([self.painter hasShapeLayers]) {
            return NO;
        }
    }
    
    return YES;
}


- (BOOL)hasPaintedLayers {
    
    return [self.painter hasShapeLayers];
}


- (BOOL)hasAddedViews {
    
    return (self.areaView.subviews.count > 0);
}


- (void)selectObjectWithTouch:(UITouch *)touch {
    [self selectCurrentObject:[touch locationInView:self.areaView]];
}


- (void)selectCurrentObject:(CGPoint)point {
    
    if (self.state == MAGMediaEditorStateDefault) {
        
        NSMutableDictionary * distances = @{}.mutableCopy;
        NSArray *items = [self.areaView subviews].copy;
        
        for (UIView *item in items) {
            CGFloat dist = pow(point.x - item.layer.position.x, 2) + pow(point.y - item.layer.position.y, 2);
            
            NSUInteger index = [items indexOfObject:item];
            [distances setObject:@(dist) forKey:@(index)];
        }
        
        NSArray *keys = [distances keysSortedByValueUsingSelector:@selector(compare:)];
        
        if (keys.count) {
            NSNumber *nearestIndex = keys.firstObject;
            self.objectView = ((UIView *)[items objectAtIndex:nearestIndex.unsignedIntegerValue]);
        } else {
            self.objectView = nil;
        }
        
        self.viewTransformer.transformableView = self.objectView;
        
    } else {
        self.viewTransformer.transformableView = nil;
    }
    
}


- (void)choiceColor:(UIColor *)color {
    [self.painter changeColor:color];
}


- (void)configureContentSize:(CGSize)size {
    
    CGFloat contentScale = size.width / self.areaView.bounds.size.width;
    contentScale *= [[UIScreen mainScreen] scale];
    self.areaView.layer.contentsScale = contentScale;
    self.contentScale = contentScale;
}


- (UIImage *)imageFromText:(NSString *)text size:(CGFloat)size {
    
    UIFont *font = [UIFont systemFontOfSize:size];
    CGSize imageSize  = [text sizeWithAttributes:@{ NSFontAttributeName : font }];
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // optional: add a shadow, to avoid clipping the shadow you should make the context size bigger
    //
    // CGContextRef ctx = UIGraphicsGetCurrentContext();
    // CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor grayColor] CGColor]);
    
    [text drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:@{ NSFontAttributeName : font }];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)imageFromTextView:(UITextView *)textView size:(CGFloat)size {
    
    NSDictionary *attributes = textView.typingAttributes;
    NSString *text = textView.text;
    CGSize imageSize  = [text sizeWithAttributes:attributes];
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    [text drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


- (CGSize)fullHDAspectSize:(CGSize)size {
    
    CGFloat xScale = 1920 / MAX(size.width, size.height);
    CGFloat yScale = 1080 / MIN(size.width, size.height);
    
    CGFloat scale = MIN(xScale, yScale);
    if (scale < 1) {
        size = CGSizeMake(round(size.width * scale), round(size.height * scale));
    }
    
    return size;
}


- (UIImage *)renderOverlayImage:(CGSize)size {
    UIImage *image = nil;
    
    if ([self hasAddedViews] || [self hasPaintedLayers]) {
        size = [self fullHDAspectSize:size];
        
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if (size.width > 0) {
            //[self.areaView drawRect:CGRectMake(0, 0, size.width, size.height)];
            CGFloat aspect = self.areaView.bounds.size.height / self.areaView.bounds.size.width;
            CGFloat sourceAspect = size.height / size.width;
            
            CGContextTranslateCTM(context, 0, 0.5 * (size.height - aspect * size.width));
            CGContextScaleCTM(context, 1, aspect / sourceAspect);
            
            [self.areaView drawViewHierarchyInRect:CGRectMake(0, 0, size.width, size.height) afterScreenUpdates:NO];
            //[self.areaView.layer renderInContext:context];
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}


- (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}


#pragma mark - Gesture Actions

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    
    if (self.state == MAGMediaEditorStateDefault && self.objectView) {
        [self.viewTransformer handlePanGesture:recognizer];
        
        switch (recognizer.state) {
            case UIGestureRecognizerStateBegan:
                if ([self.delegate respondsToSelector:@selector(mediaEditor:showTrash:)]) {
                    [self.delegate mediaEditor:self showTrash:YES];
                }
                break;
                
            case UIGestureRecognizerStateChanged:
                [self checkAboveTrash:[recognizer locationInView:recognizer.view]];
                break;
                
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateFailed:
                [self checkForTrash:[recognizer locationInView:recognizer.view]];
                
                if ([self.delegate respondsToSelector:@selector(mediaEditor:showTrash:)]) {
                    [self.delegate mediaEditor:self showTrash:NO];
                }
                break;
                
            default:
                break;
        }
        
    } else if (self.state == MAGMediaEditorStatePaint) {
        
        switch (recognizer.state) {
            case UIGestureRecognizerStateBegan:
                [self.painter beginMove:[recognizer locationInView:recognizer.view]];
                break;
                
            case UIGestureRecognizerStateChanged:
                [self.painter move:[recognizer translationInView:recognizer.view]];
                break;
                
            case UIGestureRecognizerStateFailed:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded:
                [self.painter endMove:[recognizer locationInView:recognizer.view]];
                break;
                
            default:
                break;
        }
    }
}


- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
    
    if (self.state == MAGMediaEditorStateDefault) {
        [self.viewTransformer handlePinchAndRotateGesture:recognizer];
        
    } else if (self.state == MAGMediaEditorStatePaint) {
        //
    }
}


- (void)handleRotateGesture:(UIRotationGestureRecognizer *)recognizer {
    
    if (self.state == MAGMediaEditorStateDefault) {
        [self.viewTransformer handlePinchAndRotateGesture:recognizer];
        
    } else if (self.state == MAGMediaEditorStatePaint) {
        
    }
}


- (void)requestTrashFrame {
    
    if ([self.delegate respondsToSelector:@selector(trashFrameForMediaEditor:)]) {
        CGRect trashFrame = [self.delegate trashFrameForMediaEditor:self];
        self.trashFrame = trashFrame;
    }
}


- (void)checkForTrash:(CGPoint)point {
    [self requestTrashFrame];
    
    if (CGRectContainsPoint(self.trashFrame, point)) {
        [self removeToTrash];
    }
}


- (void)checkAboveTrash:(CGPoint)point {
    [self requestTrashFrame];
    
    if (CGRectContainsPoint(self.trashFrame, point)) {
        if (self.isAboveTrash == NO) {
            if ([self.delegate respondsToSelector:@selector(mediaEditor:highlightTrash:)]) {
                [self.delegate mediaEditor:self highlightTrash:YES];
            }
            
            self.isAboveTrash = YES;
        }
        
    } else {
        if (self.isAboveTrash == YES) {
            if ([self.delegate respondsToSelector:@selector(mediaEditor:highlightTrash:)]) {
                [self.delegate mediaEditor:self highlightTrash:NO];
            }
            
            self.isAboveTrash = NO;
        }
    }

}




@end
