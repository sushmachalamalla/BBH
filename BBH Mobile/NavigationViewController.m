//
//  RunViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 9/25/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "NavigationViewController.h"


@implementation NavigationViewController

- (instancetype)init {
    
    self = [super init];
    
    if(self) {
        //[self setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
    
    return self;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    NSLog(@">> SEAGUE => %@", identifier);
    return YES;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSLog(@">> Will show view controller");
}

@end