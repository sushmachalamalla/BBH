//
//  UIViewController+BBHVIewController.h
//  BBH Mobile
//
//  Created by Mac-Mini on 11/21/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef UIViewController_BBHVIewController_h
#define UIViewController_BBHVIewController_h

@interface UIViewController (BBHViewController)

-(void) navStackPushedFrom: (UIViewController*)sourceVC;
-(void) navStackPoppedTo: (UIViewController*)destVC;

@end

#endif /* UIViewController_BBHVIewController_h */
