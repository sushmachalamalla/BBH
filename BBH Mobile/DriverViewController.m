//
//  DriverViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/9/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DriverViewController.h"

@implementation DriverViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"Drivers" image:nil tag:60];
        [self setTabBarItem:item];
    }
    
    return self;
}

-(void)reloadTableView:(NSString *)tableName {
    
    UITableView* tableView = nil;
    if([tableName isEqualToString:@"responded"]) {
        
        tableView = [self respondedTableView];
        
    } else if([tableName isEqualToString:@"accepted"]) {
        
        tableView = [self acceptedTableView];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [tableView reloadData];
    });
}

-(void)viewDidLoad {
    
    RespondedDriverDelegate* respDelegate = [[RespondedDriverDelegate alloc] initWithCB:^{
        
        [self reloadTableView:@"responded"];
        
    } entity:[self runEntity]];
    
    AcceptedDriverDelegate* accDelegate = [[AcceptedDriverDelegate alloc] initWithCB:^{
        
        [self reloadTableView:@"accepted"];
        
    } entity:[self runEntity]];
    
    [self setAcceptedDriverDelegate:accDelegate];
    [self setRespondedDriverDelegate:respDelegate];
    
    [[self respondedTableView] setDelegate:respDelegate];
    [[self respondedTableView] setDataSource:respDelegate];
    
    [[self acceptedTableView] setDelegate:accDelegate];
    [[self acceptedTableView] setDataSource:accDelegate];
    
    [accDelegate fetchData];
    [respDelegate fetchData];
}

@end

@implementation RespondedDriverDelegate

-(instancetype)initWithCB:(void (^)(void))cb entity:(Run *)runEntity {
    
    self = [super init];
    
    if(self) {
        
        [self setContent:[NSMutableArray array]];
        [self setCb:cb];
        [self setRunEntity:runEntity];
    }
    
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"respondedDataCell" forIndexPath:indexPath];
    
    RunRelease* runRelease = [[self content] objectAtIndex:[indexPath row]];
    
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:100];
    UILabel* acceptedDateLabel = (UILabel*)[cell viewWithTag:200];
    UIButton* acceptBtn = (UIButton*)[cell viewWithTag:300];
    
    [acceptBtn setHidden:[runRelease isRunAccepted]];
    [acceptBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:acceptBtn action:nil]];
    
    NSString* name = [[runRelease driver] fullName];
    NSString* acceptedDate = [BBHUtil isNull:[runRelease runAcceptedDate]] ? @"N/A" : [[BBHUtil dateFormat] stringFromDate:[runRelease runAcceptedDate]];
    
    [nameLabel setText:name];
    [acceptedDateLabel setText:acceptedDate];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 560.0, 32.0)];
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 535.0, 21.0)];
    
    [headerLabel setTextColor:[BBHUtil headerTextColor]];
    [headerLabel setText:@"Responded"];
    
    //[[tableView dequeueReusableCellWithIdentifier:@"endHeaderCell"] viewWithTag:100]
    
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [view addSubview:headerLabel];
    [view setOpaque:YES];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self content] count];
}

-(void)fetchData {
    
    RESTClient* client = [RESTClient instance];
    [client doGETWithURL:[NSString stringWithFormat:@"runs/%d/runReleasesResponded",[[self runEntity] runId]] absolute:NO data:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            NSLog(@"RunRelease: %@", data);
            
            NSArray* runReleases = [data valueForKey:@"RunReleases"];
            [runReleases enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [[self content] addObject:[[RunRelease alloc] initWithDict:obj]];
            }];
            
            [self cb]();
            
        } else if(response == RESTResponseError) {
            
            //
        }
    }];
}

-(void)success:(NSDictionary *)data {
    
    
}

-(void)failure:(NSDictionary *)detail withMessage:(NSString *)message {
    //
}

-(void)progress:(NSNumber *)percent {
    //
}

@end

@implementation AcceptedDriverDelegate

-(instancetype)initWithCB:(void (^)(void))cb entity:(Run *)runEntity {
    
    self = [super init];
    
    if(self) {
        
        [self setContent:[NSMutableArray array]];
        [self setCb:cb];
        [self setRunEntity:runEntity];
    }
    
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"acceptedDataCell" forIndexPath:indexPath];
    
    RunDriver* runDriver = [[self content] objectAtIndex:[indexPath row]];
    
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:100];
    UILabel* acceptedDateLabel = (UILabel*)[cell viewWithTag:200];
    UILabel* confirmDateLabel = (UILabel*)[cell viewWithTag:300];
    
    NSString* name = [[runDriver driver] fullName];
    NSString* acceptedDate = [BBHUtil isNull:[runDriver driverAcceptedDate]] ? @"N/A" : [[BBHUtil dateFormat] stringFromDate:[runDriver driverAcceptedDate]];
    NSString* confirmationDate = [BBHUtil isNull:[runDriver driverConfirmationReceivedDate]] ? @"N/A" : [[BBHUtil dateFormat] stringFromDate:[runDriver driverConfirmationReceivedDate]];
    
    [nameLabel setText: name];
    [acceptedDateLabel setText:acceptedDate];
    [confirmDateLabel setText:confirmationDate];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 560.0, 32.0)];
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 535.0, 21.0)];
    
    [headerLabel setTextColor:[BBHUtil headerTextColor]];
    [headerLabel setText:@"Accepted"];
    
    //[[tableView dequeueReusableCellWithIdentifier:@"endHeaderCell"] viewWithTag:100]
    
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [view addSubview:headerLabel];
    [view setOpaque:YES];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self content] count];
}

-(void)fetchData {
    
    RESTClient* client = [RESTClient instance];
    [client doGETWithURL:[NSString stringWithFormat:@"runs/%d/runDriversAccepted",[[self runEntity] runId]] absolute:NO data:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            NSLog(@"RunDriver: %@", data);
            
            NSArray* runDrivers = [data valueForKey:@"RunDrivers"];
            [runDrivers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                [[self content] addObject:[[RunDriver alloc] initWithDict:obj]];
            }];
            
            [self cb]();
        }
    }];
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