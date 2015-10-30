//
//  PaymentMethodViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/6/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentMethodViewController.h"

@implementation PaymentMethodViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Payment Methods" image:nil tag:30];
        [self setTabBarItem:tabBarItem];
    }
    
    return self;
}

-(void)viewDidLoad {
    
    [self setContent:[NSMutableArray array]];
    
    [[self pmTableView] setDataSource:self];
    [[self pmTableView] setDelegate:self];
    
    RESTClient* client = [RESTClient instance];
    [client doGETWithURL:[NSString stringWithFormat:@"runs/%d/runPaymentMethods",[[self runEntity] runId]] absolute:NO data:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            NSLog(@"%@", data);
            NSArray* runPaymentList = [data valueForKey:@"RunPaymentMethods"];
            
            [runPaymentList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                RunPaymentMethod* pm = [[RunPaymentMethod alloc] initWithDict:obj];
                [[self content] addObject:pm];
            }];
            
            dispatch_async(dispatch_get_main_queue(),^{
                
                [[self pmTableView] reloadData];
            });
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"pmDataCell" forIndexPath:indexPath];
    
    UILabel* pmLabel = (UILabel*)[cell viewWithTag:100];
    UILabel* unitLabel = (UILabel*)[cell viewWithTag:101];
    UILabel* rateLabel = (UILabel*)[cell viewWithTag:102];
    
    if(!pmLabel) {
        
        NSLog(@">> NOT FOUND");
        
        pmLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 308.0, 21.0)];
        unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(320, 5, 113.0, 21.0)];
        rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(433, 5, 131.0, 21.0)];
        
        [pmLabel setTextAlignment:NSTextAlignmentLeft];
        [unitLabel setTextAlignment:NSTextAlignmentRight];
        [rateLabel setTextAlignment:NSTextAlignmentRight];
        
        [pmLabel setTextColor:[UIColor grayColor]];
        [unitLabel setTextColor:[UIColor grayColor]];
        [rateLabel setTextColor:[UIColor grayColor]];
        
        [pmLabel setTag:100];
        [unitLabel setTag:101];
        [rateLabel setTag:102];
        
        [[cell contentView] addSubview:pmLabel];
        [[cell contentView] addSubview:unitLabel];
        [[cell contentView] addSubview:rateLabel];
    }
    
    RunPaymentMethod* pm = [[self content] objectAtIndex:[indexPath row]];
    [pmLabel setText:[[pm paymentMethod] paymentMethodName]];
    [unitLabel setText:[NSString stringWithFormat:@"%.2f", [[pm estimatedUnits] doubleValue]]];
    [rateLabel setText:[NSString stringWithFormat:@"%.2f", [[pm estimatedRate] doubleValue]]];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 565.0, 32.0)];
    UILabel* pmLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 308.0, 21.0)];
    UILabel* unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(320, 5, 113.0, 21.0)];
    UILabel* rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(433, 5, 131.0, 21.0)];
    
    [pmLabel setTextColor:[BBHUtil headerTextColor]];
    [pmLabel setText:@"Payment Method"];
    
    [unitLabel setTextColor:[BBHUtil headerTextColor]];
    [unitLabel setText:@"Est Units"];
    
    [rateLabel setTextColor:[BBHUtil headerTextColor]];
    [rateLabel setText:@"Est Rate"];
    
    [unitLabel setTextAlignment:NSTextAlignmentRight];
    [rateLabel setTextAlignment:NSTextAlignmentRight];
    
    //[[tableView dequeueReusableCellWithIdentifier:@"endHeaderCell"] viewWithTag:100]
    
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [view addSubview:pmLabel];
    [view addSubview:unitLabel];
    [view addSubview:rateLabel];
    [view setOpaque:YES];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self content] count];
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