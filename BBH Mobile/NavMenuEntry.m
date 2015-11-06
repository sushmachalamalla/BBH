//
//  NavMenuEntry.m
//  BBH Mobile
//
//  Created by Mac-Mini on 9/28/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "Entities.h"

@implementation NavMenuEntry

+(NSArray *)defaultEntriesForLogin: (NSString*) loginType {
    
    NSMutableArray* list = [NSMutableArray array];
    
    if([loginType isEqualToString:@"Driver"]) {
        
        [list addObject:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Home" actionURL:@"runsDashboard" actionEntity:@"Run"]];
        
        NavMenuEntry* myRuns = [[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"My Runs"];
        
        [myRuns addChildItem:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Posted" actionURL:@"runsPosted" actionEntity:@"Run"]];
        
        [myRuns addChildItem:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Applied" actionURL:@"runsApplied" actionEntity:@"Run"]];
        [myRuns addChildItem:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Pending" actionURL:@"runsPending" actionEntity:@"Run"]];
        [myRuns addChildItem:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Confirmed" actionURL:@"runsConfirmed" actionEntity:@"Run"]];
        [myRuns addChildItem:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"In Progress" actionURL:@"runsInProgress" actionEntity:@"Run"]];
        
        [list addObject:myRuns];
        
        [list addObject:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"My Honks" actionURL:@"myHonks" actionEntity:@"Honk"]];
        [list addObject:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Paid Invoice List" actionURL:@"invoicesPaid" actionEntity:@"Invoice"]];
        [list addObject:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Un-Paid Invoice List" actionURL:@"invoicesUnPaid" actionEntity:@"Invoice"]];
        
        [list addObject:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Change Password"]];
        [list addObject:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Logout"]];
        
    } else if([loginType isEqualToString:@"Client"]) {
        
        [list addObject:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Drivers" actionURL:@"viewDrivers" actionEntity:@"Driver"]];
        
        [list addObject:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"New Run"]];
        
        NavMenuEntry* myRuns = [[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"My Runs"];
        
        [myRuns addChildItem:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"UnPosted" actionURL:@"runsUnPosted" actionEntity:@"Run"]];
        [myRuns addChildItem:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Posted" actionURL:@"runsPosted" actionEntity:@"Run"]];
        
        [myRuns addChildItem:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Applied" actionURL:@"runsApplied" actionEntity:@"Run"]];
        [myRuns addChildItem:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Pending" actionURL:@"runsPending" actionEntity:@"Run"]];
        [myRuns addChildItem:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Confirmed" actionURL:@"runsConfirmed" actionEntity:@"Run"]];
        [myRuns addChildItem:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"In Progress" actionURL:@"runsInProgress" actionEntity:@"Run"]];
        
        [myRuns addChildItem:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Paid" actionURL:@"runsPaid" actionEntity:@"Run"]];
        
        [list addObject:myRuns];
        
        [list addObject:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Paid Invoice List" actionURL:@"invoicesPaid" actionEntity:@"Invoice"]];
        [list addObject:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Un-Paid Invoice List" actionURL:@"invoicesUnPaid" actionEntity:@"Invoice"]];
        
        [list addObject:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Change Password"]];
        [list addObject:[[NavMenuEntry alloc] initWithIcon:@"Arrow" label:@"Logout"]];
    }
    
    NSLog(@"Entry size: %lu", (unsigned long)[list count]);
    return list;
}

-(instancetype) initWithIcon:(NSString *)icon label:(NSString *)label actionURL:(NSString *)actionURL actionEntity:(NSString*) actionEntity {
    
    self = [super init];
    
    if(self) {
        
        _icon = icon;
        _label = label;
        _actionURL = actionURL;
        _actionEntity = actionEntity;
        _childItems = [NSMutableArray array];
        _child = NO;
        _leaf = YES;
        _expanded = NO;
    }
    
    return self;
}

-(instancetype)initWithIcon:(NSString *)icon label:(NSString *)label actionURL:(NSString *)actionURL {
    
    return [self initWithIcon:icon label:label actionURL:actionURL actionEntity:nil];
}

-(instancetype)initWithIcon:(NSString *)icon label:(NSString *)label {
    
    return [self initWithIcon:icon label:label actionURL:nil actionEntity:nil];
}

- (void) addChildItem:(NavMenuEntry *)childItem {
    
    [childItem setChild: YES];
    [self setLeaf:NO];
    [[self childItems] addObject: childItem];
}

@end