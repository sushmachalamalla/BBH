//
//  PaymentMethodEditViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 11/2/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentMethodEditViewController.h"

@implementation PaymentMethodEditViewController

@synthesize mode;
@synthesize isClean;

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSArray* btnList = [[NSArray alloc] initWithObjects:[self addBtn], nil];
    [[[self tabBarController] navigationItem] setRightBarButtonItems:btnList];
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self setEditController: [[PaymentMethodEditView alloc] init]];
    
    [self setAddBtn:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPaymentMethod)]];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[self editController] setMode:EntityModeEdit];
    [[self editController] setIsClean: NO];
    [[self editController] setRunEntity:[self runEntity]];
    [[self editController] setPmEntity:[[self content] objectAtIndex:[indexPath row]]];
    [[self navigationController] pushViewController:[self editController] animated:YES];
}

-(void)navStackPushedFrom:(UIViewController *)sourceVC {
    
    if([sourceVC isKindOfClass:[PaymentMethodEditView class]]) {
        
        PaymentMethodEditView* view = (PaymentMethodEditView*) sourceVC;
        if([view isClean]) {
            
            [super fetchData];
        }
    }
    
    NSLog(@">>> NAV STACK PUSH SUB CLASS: %@", sourceVC);
}

-(void)navStackPoppedTo:(UIViewController *)destVC {
    
    NSLog(@">>> NAV STACK POPTO SUB CLASS: %@", destVC);
}

-(void) makeUI {
    
    [super makeUI];
}

-(void) populate {
    
    [super populate];
}

-(void)saveInfo {
    //
}

-(void)confirmSave:(void (^)(ConfirmResponse))handler {
    
    [BBHUtil showConfirmSave:self handler:handler];
}

-(void) addPaymentMethod {
    
    [[self editController] setMode:EntityModeAdd];
    [[self editController] setIsClean:NO];
    [[self editController] setRunEntity:[self runEntity]];
    [[self navigationController] pushViewController:[self editController] animated:YES];
}

-(void)success:(NSDictionary *)data {
    //
}

-(void)failure:(NSDictionary *)detail withMessage:(NSString *)message {
    //
}

-(void)progress:(NSNumber *)percent {
    //
}

@end