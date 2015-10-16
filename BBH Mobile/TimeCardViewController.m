//
//  TimeCardViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/8/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeCardViewController.h"
#import "RunDetailViewController.h"

@implementation TimeCardViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Time Card" image:nil tag:50];
        [self setTabBarItem:tabBarItem];
    }
    
    return self;
}

-(void)viewDidLoad {
    
    [self setContent:[NSMutableArray array]];
    
    RESTClient* client = [RESTClient instance];
    [client doGETWithURL:[NSString stringWithFormat:@"runs/%d/timeCards",[[self runEntity] runId]] absolute:NO data:[[RESTParams alloc] init] handler:self];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimeCardViewCell* cell = (TimeCardViewCell*)[tableView dequeueReusableCellWithIdentifier:@"tcDataCell" forIndexPath:indexPath];
    
    TimeCard* tc = [[self content] objectAtIndex:[indexPath row]];
    
    NSString* fullName = [[tc driver] fullName];
    NSString* status = [[tc timeCardStatus] timeCardStatusName];
    NSString* approvalBy = [BBHUtil isNull:[tc approvalBy]] ? @"N/A" : [[tc approvalBy] fullName];
    NSString* approvalDate = [BBHUtil isNull:[tc approvalDate]] ? @"N/A" : [[BBHUtil dateFormat] stringFromDate:[tc approvalDate]];
    
    [[cell nameLabel] setText:fullName];
    [[cell statusLabel] setText:status];
    [[cell approvedByLabel] setText:approvalBy];
    [[cell approvedDateLabel] setText:approvalDate];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self content] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView* header = (UITableViewHeaderFooterView*)view;
    [[header textLabel] setText:@"Time Card"];
    [[header textLabel] setTextColor:[BBHUtil headerTextColor]];
}

-(void)success:(NSDictionary *)data {
    
    NSLog(@"TC DATA: %@", data);
    
    NSArray* timeCards = [data valueForKey:@"TimeCards"];
    [timeCards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [[self content] addObject:[[TimeCard alloc] initWithDict:obj]];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[self tableView] reloadData];
    });
}

-(void)failure:(NSDictionary *)detail withMessage:(NSString *)message {
    //
}

-(void)progress:(NSNumber *)percent {
    //
}

@end