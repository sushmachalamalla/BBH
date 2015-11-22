//
//  RunViewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 9/25/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTClient.h"
#import "UIViewController+BBHVIewController.h"

#ifndef BBH_Mobile_RunViewController_h
#define BBH_Mobile_RunViewController_h

@interface NavigationViewController : UINavigationController<UINavigationControllerDelegate>

@property NSMutableArray* navigationHandlers;

@end

#endif
