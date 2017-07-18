//
//  ITMediaItem.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 01/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef enum : NSUInteger {
    MAGMediaTypeUndefined = 0,
    MAGMediaTypeImage,
    MAGMediaTypeVideo,
} MAGMediaType;


@interface MAGMediaPickerItem : NSObject

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) MAGMediaType type;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *thumbnailImage;
@property (strong, nonatomic) NSURL *sourceURL;

@end
