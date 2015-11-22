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

@synthesize isUIDone;

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        UITabBarItem* tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Payment Methods" image:nil tag:30];
        [self setTabBarItem:tabBarItem];
    }
    
    return self;
}

-(void)viewDidLoad {
    
    [self makeUI];
    [self fetchData];
}

-(void)fetchData {
    
    if(![self content]) {
        [self setContent:[NSMutableArray array]];
    }

    [[self content] removeAllObjects];
    
    RESTClient* client = [RESTClient instance];
    [client doGETWithURL:[NSString stringWithFormat:@"runs/%d/runPaymentMethods",[[self runEntity] runId]] absolute:NO params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            NSLog(@"%@", data);
            NSArray* runPaymentList = [data valueForKey:@"RunPaymentMethods"];
            
            [runPaymentList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                RunPaymentMethod* pm = [[RunPaymentMethod alloc] initWithDict:obj];
                [[self content] addObject:pm];
            }];
            
            [self populate];
        }
    }];
}

-(void)updateViewConstraints {
    
    //NSLog(@"+++++++++++++ UPDATE CONSTRAINTS ++++++++++++++");
    
    [[self pmTableView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self view].mas_top).with.offset(20.0);
        make.left.equalTo([self view].mas_left);
        make.right.equalTo([self view].mas_right);
        make.bottom.equalTo([self view].mas_bottom);
    }];
    
    [super updateViewConstraints];
}

-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    //[[self pmTableView] setSeparatorInset:UIEdgeInsetsZero];
    //[[self pmTableView] setLayoutMargins:UIEdgeInsetsZero];
}

-(void) makeUI {
    
    [self setPmTableView:[[UITableView alloc] init]];
    [[self pmTableView] setDataSource:self];
    [[self pmTableView] setDelegate:self];
    
    if([[self pmTableView] respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        
        [[self pmTableView] setCellLayoutMarginsFollowReadableWidth:NO];
    }
    
    [[self view] addSubview:[self pmTableView]];
    [[self view] setNeedsUpdateConstraints];
}

-(void) populate {
    
    dispatch_async(dispatch_get_main_queue(),^{
        
        //[[self pmTableView] setNeedsUpdateConstraints];
        [[self pmTableView] reloadData];
    });
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PaymentMethodCell* cell = (PaymentMethodCell*) [tableView dequeueReusableCellWithIdentifier:@"pmDataCell"];
    
    if(!cell) {
        
        cell = [[PaymentMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pmDataCell"];
    }
    
    UILabel* pmLabel = [cell pmLabel];
    UILabel* unitLabel = [cell unitLabel];
    UILabel* rateLabel = [cell rateLabel];
    
    RunPaymentMethod* pm = [[self content] objectAtIndex:[indexPath row]];
    [pmLabel setText:[[pm paymentMethod] paymentMethodName]];
    [unitLabel setText:[NSString stringWithFormat:@"%.2f", [[pm estimatedUnits] doubleValue]]];
    [rateLabel setText:[NSString stringWithFormat:@"%.2f", [[pm estimatedRate] doubleValue]]];
    
    [cell setNeedsUpdateConstraints];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    PaymentMethodCell* cell = (PaymentMethodCell*) [tableView dequeueReusableCellWithIdentifier:@"pmDataCell"];
    
    if(!cell) {
        
        cell = [[PaymentMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pmDataCell"];
    }
    
    UILabel* pmLabel = [cell pmLabel];
    UILabel* unitLabel = [cell unitLabel];
    UILabel* rateLabel = [cell rateLabel];
    
    [pmLabel setText:@"Payment Method"];
    [unitLabel setText:@"Est Units"];
    [rateLabel setText:@"Est Rate"];
    
    [pmLabel setTextColor:[BBHUtil headerTextColor]];
    [unitLabel setTextColor:[BBHUtil headerTextColor]];
    [rateLabel setTextColor:[BBHUtil headerTextColor]];
    
    [unitLabel setTextAlignment:NSTextAlignmentRight];
    [rateLabel setTextAlignment:NSTextAlignmentRight];
    
    [[cell contentView] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [[cell contentView] setOpaque:YES];
    [cell setNeedsUpdateConstraints];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self content] count];
}

-(void)navStackPushedFrom:(UIViewController *)sourceVC {
    
    NSLog(@">>> NAV STACK PUSH SUB CLASS - 1: %@", sourceVC);
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