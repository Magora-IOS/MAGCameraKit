//
//  ITMediaPickerPresenter.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 06/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "MAGMediaPickerPresenter.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIImage+MAGCameraKit.h"


@interface MAGMediaPickerPresenter ()


@end


@implementation MAGMediaPickerPresenter


- (void)completeActionWithItem:(MAGMediaPickerItem *)item {
    
    if (self.completion) {
        self.completion(item);
    }
}

- (void)cancelAction {
    if (self.cancellation) {
        self.cancellation();
    }
}


@end
