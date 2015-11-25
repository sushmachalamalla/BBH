//
//  TimeCardEditViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 11/24/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeCardEditViewController.h"

@implementation TimeCardEditViewController

@synthesize isUIDone;
@synthesize isClean;
@synthesize mode;

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSArray* btnList = [[NSArray alloc] initWithObjects:[self addBtn], nil];
    [[[self tabBarController] navigationItem] setRightBarButtonItems:btnList];
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self setEditController: [[TimeCardEditView alloc] init]];
    
    [self setAddBtn:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTimeCard)]];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[self editController] setMode:EntityModeEdit];
    [[self editController] setIsClean: NO];
    [[self editController] setRunEntity:[self runEntity]];
    [[self editController] setTcEntity:[[self content] objectAtIndex:[indexPath row]]];
    [[self navigationController] pushViewController:[self editController] animated:YES];
}

-(void) addTimeCard {
    
    [[self editController] setMode:EntityModeAdd];
    [[self editController] setIsClean: NO];
    [[self editController] setRunEntity:[self runEntity]];
    [[self editController] setTcEntity:nil];
    [[self navigationController] pushViewController:[self editController] animated:YES];
}

-(void)confirmSave:(void (^)(ConfirmResponse))handler {
    
    //
}

-(void)saveInfo {
    
    //
}

@end