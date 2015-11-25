//
//  TimeCardEditView.m
//  BBH Mobile
//
//  Created by Mac-Mini on 11/24/15.
//  Copyright © 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeCardEditView.h"

@implementation TimeCardEditView

@synthesize isClean;
@synthesize isUIDone;
@synthesize mode;

-(instancetype)init {
    
    self = [super init];
    
    if(self) {
        
        [self setContent:[NSMutableArray array]];
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setExtendedLayoutIncludesOpaqueBars:NO];
    }
    
    return self;
}

-(void)loadView {
    
    NSLog(@"+++++++++++++++ loadView");
    
    [self setView:[UIView new]];
    [super loadView];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    [[self view] setOpaque:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([self isUIDone]) {
        [self populate];
    }
}

-(void)viewDidLoad {
    
    [[self navigationItem] setTitle:([self mode] == EntityModeAdd ? @"TimeCard Add" : @"TimeCard Edit")];
    
    UIBarButtonItem* saveBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveInfo)];
    
    NSMutableArray* btnList = [NSMutableArray arrayWithArray:[[self navigationItem] leftBarButtonItems]];
    
    [btnList addObject:saveBtn];
    
    [[self navigationItem] setLeftItemsSupplementBackButton:YES];
    [[self navigationItem] setLeftBarButtonItems:btnList];
    
    [self makeUI];
    [self populate];
    [[self view] setNeedsUpdateConstraints];
}

-(void) updateViewConstraints {
    
    NSLog(@">>>>>>>>>>>> UPDATE CONSTRAINTS");
    
    [[self contentView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo([self view]).with.insets(UIEdgeInsetsMake(0.0, 0.0, 0.0, 10.0));
    }];
    
    NSArray* array = [[NSArray alloc] initWithObjects:[self startDateLabel], [self startDatePicker], [self startTimeLabel], [self startTimePicker], [self endDateLabel], [self endDatePicker], [self endTimeLabel], [self endTimePicker], nil];
    
    [BBHUtil makeStackEdit:array superview:[self contentView] offset:CGPointMake(5.0, [BBHUtil statusBarHeight] + 5.0)];
    
    [[self expenseTableView] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self endTimePicker].mas_bottom).with.offset(5.0);
        make.left.equalTo([self contentView]);
        make.right.equalTo([self contentView]);
        make.height.equalTo([self view]).multipliedBy(0.30);
    }];
    
    [super updateViewConstraints];
}

-(void)makeUI {
    
    [self setContentView: [[UIView alloc] init]];
    
    [self setStartDateLabel:[BBHUtil makeLabelWithText:@"Start Date"]];
    [self setStartDatePicker:[[UIDatePicker alloc] init]];
    [[self startDatePicker] setDatePickerMode:UIDatePickerModeDate];
    
    [[self contentView] addSubview:[self startDateLabel]];
    [[self contentView] addSubview:[self startDatePicker]];
    
    [self setStartTimeLabel:[BBHUtil makeLabelWithText:@"Start Time"]];
    [self setStartTimePicker:[[UIDatePicker alloc] init]];
    [[self startTimePicker] setDatePickerMode:UIDatePickerModeTime];
    
    [[self contentView] addSubview:[self startTimeLabel]];
    [[self contentView] addSubview:[self startTimePicker]];
    
    [self setEndDateLabel:[BBHUtil makeLabelWithText:@"End Date"]];
    [self setEndDatePicker:[[UIDatePicker alloc] init]];
    [[self endDatePicker] setDatePickerMode:UIDatePickerModeDate];
    
    [[self contentView] addSubview:[self endDateLabel]];
    [[self contentView] addSubview:[self endDatePicker]];
    
    [self setEndTimeLabel:[BBHUtil makeLabelWithText:@"End Time"]];
    [self setEndTimePicker:[[UIDatePicker alloc] init]];
    [[self endTimePicker] setDatePickerMode:UIDatePickerModeTime];
    
    [[self contentView] addSubview:[self endTimeLabel]];
    [[self contentView] addSubview:[self endTimePicker]];
    
    [self setExpenseTableView:[[UITableView alloc] init]];
    if([[self expenseTableView] respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        [[self expenseTableView] setCellLayoutMarginsFollowReadableWidth:NO];
    }
    
    [[self contentView] addSubview:[self expenseTableView]];
    
    [[self view] addSubview:[self contentView]];
    [[self view] setNeedsUpdateConstraints];
    [self setIsUIDone:YES];
}

-(void)fetchData {
    
    RESTClient* client = [RESTClient instance];
    NSString* url = nil;
    
    if ([self mode] == EntityModeAdd) {
        
        url = [NSString stringWithFormat:@"runs/%d/paymentMethods", [[self runEntity] runId]];
        [self setTcEntity:[[TimeCard alloc] init]];
        
        [[self tcEntity] setStartDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        [[self tcEntity] setEndDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        
        [client doGETWithURL:url params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary* dict) {
            
            NSArray* rpmList = [dict valueForKey:@"RunPaymentMethods"];
            [rpmList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                RunPaymentMethod* rpm = [[RunPaymentMethod alloc] initWithDict:obj];
                //PaymentMethod* pm = [rpm paymentMethod];
                
                TimeCardDetail* tcd = [[TimeCardDetail alloc] init];
                TimeCard* tc = [[TimeCard alloc] init];
                
                [tcd setRunPaymentMethod:rpm];
                [tcd setTimeCard:tc];
                
                [[self content] addObject:tcd];
            }];
        }];
    }
    
    if ([self mode] == EntityModeEdit) {
        
        url = [NSString stringWithFormat:@"timeCards/%d/timeCardDetailsWithoutExpenses", [[self tcEntity] timeCardId]];
        
        [client doGETWithURL:url params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary* dict) {
            
            NSArray* rpmList = [dict valueForKey:@"RunPaymentMethods"];
            NSLog(@">>> TIMECARDDETAIL PM: %@", rpmList);
            [rpmList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                TimeCardDetail* tcd = [[TimeCardDetail alloc] initWithDict:obj];
                [tcd setIsExpense:NO];
                [[self content] addObject:tcd];
            }];
        }];
        
        url = [NSString stringWithFormat:@"timeCards/%d/timeCardDetailExpenses", [[self tcEntity] timeCardId]];
        
        [client doGETWithURL:url params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary* dict) {
            
            NSArray* rpmList = [dict valueForKey:@"RunPaymentMethods"];
            NSLog(@">>> TIMECARDDETAIL EXP: %@", rpmList);
            [rpmList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                TimeCardDetail* tcd = [[TimeCardDetail alloc] initWithDict:obj];
                [tcd setIsExpense:YES];
                [[self content] addObject:tcd];
            }];
        }];
    }
    
    [self populate];
}

-(void)populate {
    
    TimeCard* tc = [self tcEntity];
    
    [[self startDatePicker] setDate:[tc startDate] animated:YES];
    [[self startTimePicker] setDate:[tc startDate] animated:YES];
    
    [[self endDatePicker] setDate:[tc endDate] animated:YES];
    [[self endTimePicker] setDate:[tc endDate] animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimeCardExpenseCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tcExpenseCell"];
    if (!cell) {
        
        cell = [[TimeCardExpenseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tcExpenseCell"];
    }
    
    TimeCardDetail* tcd = [[self content] objectAtIndex:[indexPath row]];
    RunPaymentMethod* rpm = [tcd runPaymentMethod];
    
    [[cell nameLabel] setText:( [tcd isExpense] ? [tcd timeCardDetailDescription] : [[rpm paymentMethod] paymentMethodName])];
    
    double estAmt = [tcd isExpense] ? 0.0 : [[rpm estimatedRate] doubleValue] * [[rpm estimatedUnits] doubleValue];
    
    NSString* sEstAmt = [tcd isExpense] ? @"N/A" : [NSString stringWithFormat:@"%.2f", estAmt];
    
    [[cell estAmtLabel] setText:sEstAmt];
    
    double actAmt = [tcd isExpense] ? [[tcd totalAmount] doubleValue]: [[tcd timeCardUnits] doubleValue] * [[rpm estimatedRate] doubleValue];
    
    //NSString* sEstAmt = [tcd isExpense] ? @"N/A" : [NSString stringWithFormat:@"%.2f", estAmt];
    
    [[cell estAmtLabel] setText:sEstAmt];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self content] count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(void)confirmSave:(void (^)(ConfirmResponse))handler {
    //
}

-(void)saveInfo {
    //
}

@end