//
//  RunViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 9/25/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "NavigationViewController.h"

@implementation NavigationViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        [self setDelegate:self];
        [self setNavigationHandlers:[NSMutableArray array]];
    }
    
    return self;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    NSLog(@">> SEAGUE => %@", identifier);
    return YES;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSLog(@">> Will show view controller -> %@", viewController);
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    NSLog(@">>>> NAV STACK PUSH");
    
    [toVC navStackPushedFrom: fromVC];
    
    if(operation == UINavigationControllerOperationPop) {
        
        //[fromVC navStackPoppedTo:toVC];
    }
    
    return nil;
}

@end