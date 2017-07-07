//
//  ITMediaAssetCell.m
//  InTouch
//
//  Created by Stepanov Evgeniy on 13.12.16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "ITMediaAssetCell.h"
#import <Photos/Photos.h>


@interface ITMediaAssetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end


@implementation ITMediaAssetCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
}


- (void)configure:(PHAsset *)asset {
    
    CGSize size = self.imageView.bounds.size; //CGSizeMake(100, 100);
    size.width *= 2;
    size.height *= 2;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        self.timeLabel.text = [self timeString:asset.duration];
        self.timeLabel.hidden = NO;
        
    } else if (asset.mediaType == PHAssetMediaTypeImage) {
        self.timeLabel.hidden = YES;
    }
    
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:size
                                              contentMode:PHImageContentModeAspectFill
                                                  options:options
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                self.imageView.image = result;
                                            }];
    
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        //
    }
}


- (NSString *)timeString:(NSTimeInterval)time {
    NSString *str = [NSString stringWithFormat:@"%im %is", ((int)time / 60), (int)((int)time % 60)];
    
    return str;
}



@end
