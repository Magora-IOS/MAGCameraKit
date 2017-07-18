//
//  ITMediaAssetCell.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 13.12.16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;

@interface MAGMediaAssetCell : UICollectionViewCell

- (void)configure:(PHAsset *)asset;

@end
