//
//  ITMediaPickerViewController.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 06/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAGMediaPickerPresenter.h"
#import "MAGMediaPickerStringsProtocol.h"


@interface MAGMediaPickerViewController : UIViewController

@property (strong, nonatomic) id<MAGMediaPickerPresenterProtocol> presenter;
@property (strong, nonatomic) id<MAGMediaPickerStringsProtocol> strings;

@end
