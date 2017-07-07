//
//  ITCameraFlowCoordinator.h
//  InTouch
//
//  Created by YuriyPoluektov on 23.03.17.
//  Copyright © 2017 magora-system. All rights reserved.
//

#import "ITBaseCoordinator.h"

@interface ITCameraFlowCoordinator : ITBaseCoordinator

- (instancetype)initWithRouter:(ITNavigationRouter *)router event:(ITEvent *)event;

@end
