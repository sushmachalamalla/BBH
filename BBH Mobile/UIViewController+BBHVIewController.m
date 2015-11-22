//
//  UIViewController+BBHVIewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 11/21/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+BBHVIewController.h"

@implementation UIViewController (BBHViewController)

-(void)navStackPoppedTo:(UIViewController *)destVC {
    NSLog(@"NAVSTACK %@ -> %@", self, destVC);
}

-(void)navStackPushedFrom:(UIViewController *)sourceVC {
    NSLog(@"NAVSTACK %@ -> %@", sourceVC, self);
}

@end