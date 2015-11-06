//
//  RunViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 9/29/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunSummaryViewController.h"
#import "Entities.h"


@implementation RunSummaryViewController

-(void)loadView {
    
    [super loadView];
}

- (void)viewDidLoad {
    
    [[self navigationItem] setTitle:@"My Runs"];
    //[[self navigationItem] setPrompt:@"Run List"];
    
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
            
            NSArray* items = [data objectForKey:@"Items"];
            NSArray* links = [data objectForKey:@"Links"];
            
            NSLog(@"count: %d", pageCount);
            NSLog(@"size: %d", pageSize);
            NSLog(@"number: %d", pageNumber);
            
            NSLog(@"items: %ld", (unsigned long)[items count]);
            NSLog(@"links: %ld", (unsigned long)[links count]);
            
            [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                Run* run = [[Run alloc] initWithDict:obj];
                [[self content] addObject:run];
            }];
            
            [self setPageCount:pageCount];
            [self setPageNumber:pageNumber];
            [self setPageSize:pageSize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self tableView] reloadData];
            });
            
        } else if(response == RESTResponseError) {
            
            UITableViewHeaderFooterView* header = (UITableViewHeaderFooterView*)[[self tableView] headerViewForSection:0];
            [[header detailTextLabel] setText:[NSString stringWithFormat:@"An error ocurred: %@", [data objectForKey:@"message"]]];
        }
    }];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( [[self content] count] == 0 || [[self content] count] == [indexPath row]) {
        
        if([[self content] count] == 0 && [self pageCount] != -1) {
            
            return [tableView dequeueReusableCellWithIdentifier:@"runBlankCell" forIndexPath:indexPath];
        }
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"runLoadCell" forIndexPath:indexPath];
        
        UIActivityIndicatorView* indicator = (UIActivityIndicatorView*) [[cell contentView] viewWithTag:1];
        [indicator setHidden:NO];
        [indicator startAnimating];
        
        [self fetchData:0];
        
        return cell;
        
    } else {
        
        Run* run = [[self content] objectAtIndex:[indexPath row]];
        RunSummaryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"runViewCell" forIndexPath:indexPath];
        
        [[cell companyLabel] setText:[[run client] clientName]];
        [[cell runTitleLabel] setText:[run runTitle]];
        [[cell estPayLabel] setText:[NSString stringWithFormat:@"%.2f", [[run estimatedCost] doubleValue]]];
        [[cell driverTypeLabel] setText:[[run driverType] driverTypeName]];
        [[cell driverClassLabel] setText:[[run driverClass] driverClassName]];
        [[cell pickupLocationLabel] setText:[[run pickupAddress] displayString]];
        [[cell pickupDateLabel] setText:[[BBHUtil dateFormat] stringFromDate:[run runStartDate]]];
        [[cell dropLocationLabel] setText:[[run dropOffAddress] displayString]];
        [[cell dropDateLabel] setText:[[BBHUtil dateFormat] stringFromDate:[run runEndDate]]];
        
        [cell setNeedsUpdateConstraints];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([[self content] count] == 0) {
        return 1;
    }
    
    if([self pageNumber] == [self pageCount]) {
        return [[self content] count];
    } else {
        return [[self content] count] + 1;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
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
        
        [titleLabel setText:@"My Runs"];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@">> SOURCE VC");
    
    RunSummaryCell* cell = (RunSummaryCell*)sender;
    NSIndexPath* path = [[self tableView] indexPathForCell:cell];
    
    Run* entity = [[self content] objectAtIndex:[path row]];
    
    RunDetailViewController* vc = (RunDetailViewController*)[segue destinationViewController];
    [vc setRunEntity:entity];
}

-(void)success:(NSDictionary *)data {
    
    
}

-(void)failure:(NSDictionary *)detail withMessage:(NSString *)message {
    
    
}

-(void)progress:(NSNumber *)percent {
    //
}

@end