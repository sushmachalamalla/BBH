//
//  MenuListViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 9/25/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "MenuViewController.h"
#import "Entities.h"

@implementation MenuViewController


- (void)viewDidLoad {
    
    //[self setContentOrig:[NavMenuEntry defaultEntriesForLogin:nil]];
    [self setContent:[NSMutableArray arrayWithArray:[NavMenuEntry defaultEntriesForLogin:[[BBHSession curSession] loginType]]]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self content] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"My BBH";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NavMenuEntry* entry = [[self content] objectAtIndex:[indexPath row]];
    UIViewController* vc = nil;
    
    NSLog(@"Did Hilite Row: %@", [entry actionEntity]);
    [self setLastAction:[entry label]];
    
    if([entry actionEntity] && [[entry actionEntity] isEqualToString:@"Run"]) {
        
        RunSummaryViewController* runVC = [[UIStoryboard storyboardWithName:@"RunSummary" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        
        [runVC setActionHREF:[entry actionURL]];
        vc = runVC;
        
    } else if([entry actionEntity] && [[entry actionEntity] isEqualToString:@"Invoice"]) {
        
        InvoiceViewController* invoiceVC = [[UIStoryboard storyboardWithName:@"Invoice" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        
        [invoiceVC setActionHREF:[entry actionURL]];
        [invoiceVC setIsPaid:[[entry label] isEqualToString:@"Paid Invoice List"]];
        vc = invoiceVC;
        
    } else if([[entry label] isEqualToString:@"Logout"]) {
        
        //RESTClient* client = [RESTClient instance];
        //[client doPOSTWithURL:@"logout" data:[[RESTParams alloc] init] handler:self];
        NSLog(@"--------- Logout clicked");
        [self success:nil];
    }
    
    if(vc) {
        
        [[self parentViewController] showViewController:vc sender:self];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([indexPath row] % 2 ==0) {
        
        //[cell setBackgroundColor:[UIColor colorWithWhite:0.70 alpha:0.1]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NavMenuCell" forIndexPath:indexPath];
    NavMenuEntry* entry = [[self content] objectAtIndex:[indexPath row]];
    
    [cell setIndentationWidth:[entry child] ? 20.0f : 0.0];
    [cell setIndentationLevel:[entry child] ? 1 : 0];
    
    //UIEdgeInsets insets = [cell separatorInset];
    //[cell setSeparatorInset:[entry child] ? UIEdgeInsetsMake(insets.top, insets.left + 20.0f, insets.bottom, insets.right) : insets];
    
    //[[cell imageView] setImage:[UIImage imageNamed:[entry icon]]];
    [[cell textLabel] setText:[entry label]];
    [[cell textLabel] setBackgroundColor:[UIColor colorWithWhite:1.0  alpha:0.0]];
    
    if(![entry leaf]) {
        
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    }
    
    if([entry child]) {
        
        [[cell textLabel] setBackgroundColor:[UIColor colorWithWhite:1.0  alpha:0.0]];
        [[cell textLabel] setTextColor:[UIColor grayColor]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Button Tapped: %ld", (unsigned long) [indexPath row]);
    NavMenuEntry* entry = [[self content] objectAtIndex:[indexPath row]];
    
    if (![entry child]) {
        
        NSMutableArray* paths = [NSMutableArray array];
        NSMutableIndexSet* indexSet = [NSMutableIndexSet indexSet];
        
        [[entry childItems] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            [indexSet addIndex:[indexPath row]+idx+1];
            [paths addObject:[NSIndexPath indexPathForRow:[indexPath row]+idx+1 inSection:[indexPath section]]];
        }];
        
        [tableView beginUpdates];
        
        if([entry expanded]) {
            
            [[self content] removeObjectsInArray:[entry childItems]];
            [tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
            
        } else {
            
            [[self content] insertObjects:[entry childItems] atIndexes:indexSet];
            [tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
        }
        
        [tableView endUpdates];
        [entry setExpanded:![entry expanded]];
    }
}

- (void)success:(NSDictionary *)data {
    
    if ([[self lastAction] isEqualToString:@"Logout"]) {
        
        NSLog(@">>>> LOGOUT");
        [[BBHSession curSession] terminate];
        [[self parentViewController] performSegueWithIdentifier:@"backToLogin" sender:[self parentViewController]];
    }
}

- (void)failure:(NSDictionary *)detail withMessage:(NSString *)message {
    //
}

- (void)progress:(NSNumber *)percent {
    //
}

@end