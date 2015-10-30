//
//  RunDetailEditViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/12/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "RunDetailEditViewController.h"

@implementation RunDetailEditViewController

-(void)viewDidLoad {
    
    [[self navigationItem] setTitle:@"Run Edit"];
    
    UIBarButtonItem* saveBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveRun)];
    
    //UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdit)];
    
    NSMutableArray* btnList = [NSMutableArray arrayWithArray:[[self navigationItem] leftBarButtonItems]];
    
    [btnList addObject:saveBtn];
    //[btnList addObject:cancelBtn];
    
    NSLog(@">>> BAR BTN ITEMS: %lu", (unsigned long)[btnList count]);
    
    [[self navigationItem] setLeftItemsSupplementBackButton:YES];
    [[self navigationItem] setLeftBarButtonItems:btnList];
    NSLog(@">>> BAR BTN ITEMS: %lu", (unsigned long)[[[self navigationItem] leftBarButtonItems] count]);
    
    [self setDelegate:self];
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"RunDetailEdit" bundle:[NSBundle mainBundle]];
    
    GeneralInfoEditViewController* generalEditVC = [sb instantiateViewControllerWithIdentifier:@"genInfoEditVC"];
    [generalEditVC setRunEntity:[self runEntity]];
    
    FreightEditViewController* freightEditVC = [sb instantiateViewControllerWithIdentifier:@"freightEditVC"];
    [freightEditVC setRunEntity:[self runEntity]];
    
    NSMutableArray* vcs = [NSMutableArray arrayWithObjects:generalEditVC, freightEditVC, nil];
    
    if ([[[BBHSession curSession] loginType] isEqualToString:@"Client"]) {
        
        //
    }
    
    [self setViewControllers:vcs animated:YES];
}

-(void) saveRun {
    //
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    id<EditView> vc = [tabBarController selectedViewController];
    NSLog(@">> TAB SELECTED: %@", vc);
    
    if(![BBHUtil isNull:vc]) {
        
        [vc confirmSave:^(ConfirmResponse response) {
            
            if(response == ConfirmResponseSave) {
                
                [vc saveInfo];
            }
            
            if(response == ConfirmResponseSave || response == ConfirmResponseDiscard) {
                
                [tabBarController setSelectedViewController:viewController];
            }
        }];
    }
    
    return NO;
}

@end