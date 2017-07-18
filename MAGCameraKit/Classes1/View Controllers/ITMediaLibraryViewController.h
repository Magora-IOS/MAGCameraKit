//
//  ITMediaLibraryViewController.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 13.12.16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITMediaPickerItem.h"
#import "ITRecordSession.h"
#import "MAGMediaPickerStringsProtocol.h"


typedef void(^SelectedMediaItem)(ITRecordSession *session);

@interface ITMediaLibraryViewController : UIViewController

@property (strong, nonatomic) id<MAGMediaPickerStringsProtocol> strings;
@property(copy, nonatomic) SelectedMediaItem selectedMediaItem;
@property(assign, nonatomic) CGFloat maxVideoDuration;

- (void)loadAssets;
- (void)loadAssetsIfNeed;

@end
