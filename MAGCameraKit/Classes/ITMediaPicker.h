//
//  ITMediaPicker.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 01/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITMediaPickerItem.h"

typedef void(^PickedMediaItem)(ITMediaPickerItem *item);

@interface ITMediaPicker : NSObject

- (instancetype)initWithVC:(UIViewController *)vc;
- (void)pickMedia:(PickedMediaItem)completion;

@end
