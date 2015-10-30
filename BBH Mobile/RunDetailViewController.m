//
//  RunDetailViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/2/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunDetailViewController.h"

@implementation RunDetailViewController

- (void)viewDidLoad {
    
    [[self navigationItem] setTitle:@"Run Detail"];
    
    UIBarButtonItem* btn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editRun)];
    
    NSMutableArray* btnList = [NSMutableArray arrayWithArray:[[self navigationItem] leftBarButtonItems]];
    [btnList addObject:btn];
    
    NSLog(@">>> BAR BTN ITEMS: %lu", (unsigned long)[btnList count]);
    
    [[self navigationItem] setLeftItemsSupplementBackButton:YES];
    [[self navigationItem] setLeftBarButtonItems:btnList];
    NSLog(@">>> BAR BTN ITEMS: %lu", (unsigned long)[[[self navigationItem] leftBarButtonItems] count]);
 
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"RunDetail" bundle:[NSBundle mainBundle]];
    
    GeneralInfoViewController* generalVC = [sb instantiateViewControllerWithIdentifier:@"genInfoVC"];
    [generalVC setRunEntity:[self runEntity]];
    
    FreightViewController* freightVC = [sb instantiateViewControllerWithIdentifier:@"freightVC"];
    [freightVC setRunEntity:[self runEntity]];
    
    PaymentMethodViewController* paymentMethodVC = [sb instantiateViewControllerWithIdentifier:@"pmVC"];
    [paymentMethodVC setRunEntity:[self runEntity]];
    
    CriteriaViewController* criteriaVC = [sb instantiateViewControllerWithIdentifier:@"criteriaVC"];
    [criteriaVC setRunEntity:[self runEntity]];
    
    TimeCardViewController* tcVC = [sb instantiateViewControllerWithIdentifier:@"tcVC"];
    [tcVC setRunEntity:[self runEntity]];
    
    NSMutableArray* vcs = [NSMutableArray arrayWithObjects:generalVC, freightVC, paymentMethodVC, criteriaVC, tcVC, nil];
    
    if ([[[BBHSession curSession] loginType] isEqualToString:@"Client"]) {
        
        DriverViewController* driverVC = [sb instantiateViewControllerWithIdentifier:@"driverVC"];
        [driverVC setRunEntity:[self runEntity]];
        [vcs addObject:driverVC];
    }
    
    [self setViewControllers:vcs animated:YES];
}

-(void) editRun {
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"RunDetailEdit" bundle:[NSBundle mainBundle]];
    RunDetailEditViewController* editVC = [sb instantiateViewControllerWithIdentifier:@"runDetailEditVC"];
    
    [editVC setRunEntity:[self runEntity]];
    [[self navigationController] showViewController:editVC sender:self];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    /*[[viewController view] setFrame:CGRectMake([[viewController view] frame].origin.x, [[viewController view] frame].origin.y + [[self tabBar] frame].size.height, [[viewController view] frame].size.width, [[viewController view] frame].size.height)];*/
}

@end