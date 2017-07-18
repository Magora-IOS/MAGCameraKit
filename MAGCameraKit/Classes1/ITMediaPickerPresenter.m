//
//  ITMediaPickerPresenter.m
//  InTouch
//
//  Created by Evgeniy Stepanov on 06/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import "ITMediaPickerPresenter.h"
#import <SVProgressHUD/SVProgressHUD.h>
//#import "ITEventsDataProvider.h"
//#import "ITEventInteractor.h"
#import "UIImage+MAGCameraKit.h"


@interface ITMediaPickerPresenter ()

//@property (strong, nonatomic) ITEventInteractor *eventInteractor;

@end


@implementation ITMediaPickerPresenter

/*
- (void)uploadMedia:(ITMediaPickerItem *)item {
    
    if (item.type == ITMediaTypeImage) {
        [self uploadImage:item.image];
        [self.analyticsManager didEventPhotoAdded];
        
    } else if (item.type == ITMediaTypeVideo) {
        [self uploadVideo:item.sourceURL withPlaysholder:item.thumbnailImage];
        [self.analyticsManager didEventVideoAdded];
    }
}


- (void)uploadVideo:(NSURL *)mediaUrl withPlaysholder:(UIImage *)thumbnailImage {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    [ITEventsDataProviderInstance addVideo:mediaUrl
                                 thumbnail:thumbnailImage
                     toBroadcastingInEvent:self.event withCompletion:^(id object, ITError *error) {
                         if (error) {
                             [ITHud showAlertForError:error onViewController:self.viewController];
                         } else {
                             if (self.event.isCheckin.boolValue == NO) {
                                 [self.eventInteractor checkinInEventByUid:self.event.uid withCompletion:nil];
                             }
                             [SVProgressHUD dismiss];
                         }
                     }];
}


- (void)uploadImage:(UIImage *)image {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    UIImage *scaledImage = image;
    [ITEventsDataProviderInstance addImage:scaledImage toBroadcastingInEvent:self.event withCompletion:^(id object, ITError *error) {
        if (error) {
            [ITHud showAlertForError:error onViewController:self.viewController];
        } else {
            if (self.event.isCheckin.boolValue == NO) {
                [self.eventInteractor checkinInEventByUid:self.event.uid withCompletion:nil];
            }
        }
        [SVProgressHUD dismiss];
    }];
}
*/

@end
