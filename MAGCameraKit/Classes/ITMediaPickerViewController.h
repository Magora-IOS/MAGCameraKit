//
//  ITMediaPickerViewController.h
//  InTouch
//
//  Created by Evgeniy Stepanov on 06/12/16.
//  Copyright © 2016 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITMediaPickerPresenter.h"


@interface ITMediaPickerViewController : UIViewController

@property (strong, nonatomic) id<ITMediaPickerPresenterProtocol> presenter;

@end
