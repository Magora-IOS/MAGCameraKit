//
//  ITColorsPanelViewController.h
//  InTouch
//
//  Created by Stepanov Evgeniy on 12/03/2017.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ITDidSelectColor)(UIColor *color);


@interface ITColorsPanelViewController : UIViewController

@property (copy, nonatomic) ITDidSelectColor didSelectColor;

- (void)selectDefaultColor;

@end
