//
//  InvoiceViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/10/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvoiceViewController.h"

@implementation InvoiceViewController

-(void)viewDidLoad {
    
    [[self navigationItem] setTitle:[self isPaid] ? @"Paid Invoice List" : @"Unpaid Invoice List"];
    
    [self setPageNumber:0];
    [self setPageSize:5];
    [self setPageCount:-1];
    
    [self setContent:[NSMutableArray array]];
}

- (NSString *)nextFetchURL {
    
    return [NSString stringWithFormat:@"%@?pageNumber=%d&pageSize=%d", [self actionHREF], [self pageNumber]+1, [self pageSize]];
}

- (void) fetchData: (int) pageNumber {
    
    RESTClient* client = [RESTClient instance];
    RESTParams* params = [[RESTParams alloc] init];
    
    //[self toggleWait:YES];
    [client doGETWithURL:[self nextFetchURL] params:params complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
                NSLog(@"%@ -> %@", key, obj);
            }];
            
            int pageCount = [[data objectForKey:@"PageCount"] intValue];
            int pageSize = [[data objectForKey:@"PageSize"] intValue];
            int pageNumber = [[data objectForKey:@"PageNumber"] intValue];
            
            NSArray* items = [data objectForKey:@"Invoices"];
            NSArray* links = [data objectForKey:@"Links"];
            
            NSLog(@"count: %d", pageCount);
            NSLog(@"size: %d", pageSize);
            NSLog(@"number: %d", pageNumber);
            
            NSLog(@"items: %ld", (unsigned long)[items count]);
            NSLog(@"links: %ld", (unsigned long)[links count]);
            
            [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                Invoice* invoice = [[Invoice alloc] initWithDict:obj];
                [[self content] addObject:invoice];
            }];
            
            [self setPageCount:pageCount];
            [self setPageNumber:pageNumber];
            [self setPageSize:pageSize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self tableView] reloadData];
            });
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( [[self content] count] == 0 || [[self content] count] == [indexPath row]) {
        
        if([[self content] count] == 0 && [self pageCount] != -1) {
            
            return [tableView dequeueReusableCellWithIdentifier:@"invoiceBlankCell" forIndexPath:indexPath];
        }
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"invoiceLoadCell" forIndexPath:indexPath];
        
        UIActivityIndicatorView* indicator = (UIActivityIndicatorView*) [[cell contentView] viewWithTag:100];
        [indicator setHidden:NO];
        [indicator startAnimating];
        
        [self fetchData:0];
        
        return cell;
        
    } else {
        
        Invoice* invoice = [[self content] objectAtIndex:[indexPath row]];
        Run* run = [invoice run];
        Driver* driver = [invoice driver];
        Client* client = [invoice client];
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"invoiceDataCell" forIndexPath:indexPath];
        
        UILabel* invoiceNoLabel = (UILabel*)[cell viewWithTag:100];
        UILabel* runTitleLabel = (UILabel*)[cell viewWithTag:200];
        UILabel* runNoLabel = (UILabel*)[cell viewWithTag:300];
        UILabel* companyLabel = (UILabel*)[cell viewWithTag:400];
        UILabel* driverLabel = (UILabel*)[cell viewWithTag:500];
        UILabel* estCostLabel = (UILabel*)[cell viewWithTag:600];
        UILabel* actualCostLabel = (UILabel*)[cell viewWithTag:700];
        
        NSString* invoiceNo = [BBHUtil isNull:[invoice invoiceNumber]] ? @"N/A" : [invoice invoiceNumber];
        NSString* runTitle = [BBHUtil isNull:run] ? @"N/A" : [run runTitle];
        NSString* runNo = [BBHUtil isNull:run] ? @"N/A" : [run runNumber];
        NSString* company = [BBHUtil isNull:client] ? @"N/A" : [client clientName];
        NSString* driverName = [BBHUtil isNull:driver] ? @"N/A" : [driver fullName];
        NSString* estCost = [BBHUtil isNull:[invoice estimatedCost]] ? @"N/A" : [NSString stringWithFormat:@"%.2f", [[invoice estimatedCost] doubleValue]];
        NSString* actualCost = [BBHUtil isNull:[invoice actualCost]] ? @"N/A" : [NSString stringWithFormat:@"%.2f", [[invoice actualCost] doubleValue]];
        
        [invoiceNoLabel setText:invoiceNo];
        [runTitleLabel setText:runTitle];
        [runNoLabel setText:runNo];
        [companyLabel setText:company];
        [driverLabel setText:driverName];
        [estCostLabel setText:estCost];
        [actualCostLabel setText:actualCost];
        
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([[self content] count] == 0) {
        return 1;
    }
    
    if([self pageNumber] == [self pageCount]) {
        return [[self content] count];
    } else {
        return [[self content] count] + 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    CGFloat statusBarHeight = 0.0;//[BBHUtil statusBarSize].height;
    
    CGFloat x = 5.0;
    CGFloat y = statusBarHeight + 4.0;
    
    UITableViewHeaderFooterView* header = (UITableViewHeaderFooterView*)view;
    
    UILabel* titleLabel = (UILabel*)[[header contentView] viewWithTag:100];
    
    if(!titleLabel) {
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 150.0, 15.0)];
        
        [titleLabel setText:[[self navigationItem] title]];
        [titleLabel setTextColor:[UIColor grayColor]];
        [titleLabel setFont:[[titleLabel font] fontWithSize:[[titleLabel font] pointSize]*0.90]];
        
        [titleLabel setTag:100];
        [[header contentView] addSubview: titleLabel];
    }
    
    y += [titleLabel frame].size.height + 2.0;
    
    UILabel* subtitleLabel = (UILabel*)[[header contentView] viewWithTag:101];
    
    if(!subtitleLabel) {
        
        subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 200.0, 15.0)];
        
        [subtitleLabel setTextColor:[UIColor grayColor]];
        [subtitleLabel setFont:[[subtitleLabel font] fontWithSize:[[subtitleLabel font] pointSize]*0.80]];
        
        [subtitleLabel setTag:101];
        [[header contentView] addSubview:subtitleLabel];
    }
    
    [subtitleLabel setText:[self loadInProgress] ? @"Fetching records" : [NSString stringWithFormat:@"Showing %lu of %lu page(s)", (unsigned long)[self pageNumber], (unsigned long)[self pageCount]]];
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