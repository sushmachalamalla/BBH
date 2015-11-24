//
//  CriteriaEditViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 11/22/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CriteriaEditViewController.h"

@implementation CriteriaEditViewController

@synthesize isClean;
@synthesize isUIDone;
@synthesize mode;

-(instancetype)init {
    
    self = [super init];
    
    if(self) {
        
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Criteria" image:nil tag:30];
        [self setTabBarItem:tabBarItem];
    }
    
    return self;
}

-(void)loadView {
    
    [super loadView];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSIndexPath* idx = nil;
    if ([self endorsementTableView]) {
        
        idx = [[self endorsementTableView] indexPathForSelectedRow];
        NSLog(@">> INDEX (end): %@", idx);
        
        if(idx) {
            [[self endorsementTableView] deselectRowAtIndexPath:idx animated:YES];
        }
    }
    
    if ([self equipmentTableView]) {
        
        idx = [[self equipmentTableView] indexPathForSelectedRow];
        NSLog(@">> INDEX (eqp): %@", idx);
        
        if(idx) {
            [[self equipmentTableView] deselectRowAtIndexPath:idx animated:YES];
        }
    }
    
    if ([self skillTableView]) {
        
        idx = [[self skillTableView] indexPathForSelectedRow];
        NSLog(@">> INDEX (skill): %@", idx);
        
        if(idx) {
            [[self skillTableView] deselectRowAtIndexPath:idx animated:YES];
        }
    }
    
    NSArray* btnList = [[NSArray alloc] initWithObjects:[self addBtn], nil];
    [[[self tabBarController] navigationItem] setRightBarButtonItems:btnList];
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self setEditController: [[CriteriaEditView alloc] init]];
    
    [self setAddBtn:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCriteria)]];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

-(void) showCriteriaEditOptions:(UIViewController *)vc handler: (void (^)(CriteriaTable)) handler {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Select A Criterion" message:@"Please select a criterion to add" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* endorsementAction = [UIAlertAction actionWithTitle:@"Endorsement" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        handler(CriteriaTableEndorsement);
    }];
    
    UIAlertAction* skillAction = [UIAlertAction actionWithTitle:@"Skill" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        handler(CriteriaTableSkill);
    }];
    
    UIAlertAction* equipmentAction = [UIAlertAction actionWithTitle:@"Equipment" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        handler(CriteriaTableEquipment);
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        handler(CriteriaTableNone);
    }];
    
    [alert addAction:endorsementAction];
    [alert addAction:skillAction];
    [alert addAction:equipmentAction];
    [alert addAction:cancelAction];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[self editController] setMode:EntityModeEdit];
    [[self editController] setIsClean: NO];
    [[self editController] setRunEntity:[self runEntity]];
    [[self editController] setTableType:[tableView tag]];
    [[self editController] setSkillEntity:[[self contentForCriteriaTable:[tableView tag]] objectAtIndex:[indexPath row]]];
    
    [[self navigationController] pushViewController:[self editController] animated:YES];
}

-(void)navStackPushedFrom:(UIViewController *)sourceVC {
    
    if([sourceVC isKindOfClass:[CriteriaEditView class]]) {
        
        CriteriaEditView* view = (CriteriaEditView*) sourceVC;
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

-(void) addCriteria {
    
    [self showCriteriaEditOptions:self handler:^(CriteriaTable table) {
        
        if(table != CriteriaTableNone) {
            
            [[self editController] setMode:EntityModeAdd];
            [[self editController] setIsClean:NO];
            [[self editController] setRunEntity:[self runEntity]];
            [[self editController] setTableType:table];
            [[self navigationController] pushViewController:[self editController] animated:YES];
        }
    }];
}

@end