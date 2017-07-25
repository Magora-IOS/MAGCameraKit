//
//  MAGMediaPlayerView.m
//  Pods
//
//  Created by Stepanov Evgeniy on 21/07/2017.
//
//

#import "MAGMediaPlayerView.h"

@interface MAGMediaPlayerView ()
@property (strong, nonatomic) UIImageView *imageView;
@end


@implementation MAGMediaPlayerView

- (instancetype)init {
    if (self = [super init]) {
        self.imageView = [UIImageView new];
        [self addSubview:self.imageView];
        
        self.imageView.hidden = YES;
        self.imageView.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


- (void)showImage:(UIImage *)image {
    self.imageView.image = image;
    self.imageView.hidden = NO;
}

- (void)hideImage {
    self.imageView.hidden = YES;
    self.imageView.image = nil;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}


@end
