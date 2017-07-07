//
//  ITMediaItem.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 01/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ITMediaTypeUndefined = 0,
    ITMediaTypeImage,
    ITMediaTypeVideo,
} ITMediaType;


@interface ITMediaPickerItem : NSObject

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) ITMediaType type;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *thumbnailImage;
@property (strong, nonatomic) NSURL *sourceURL;

@end
