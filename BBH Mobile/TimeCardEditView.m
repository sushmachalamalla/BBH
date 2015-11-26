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
    
    NSArray* btnList = [[NSArray alloc] initWithObjects:[self addBtn], nil];
    [[self navigationItem] setRightBarButtonItems:btnList];
    
    if ([self isUIDone]) {
        [self fetchData];
    }
}

-(void)viewDidLoad {
    
    [[self navigationItem] setTitle:([self mode] == EntityModeAdd ? @"TimeCard Add" : @"TimeCard Edit")];
    
    UIBarButtonItem* saveBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveInfo)];
    
    NSMutableArray* btnList = [NSMutableArray arrayWithArray:[[self navigationItem] leftBarButtonItems]];
    
    [btnList addObject:saveBtn];
    
    [self setAddBtn:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addExpense)]];
    
    [[self navigationItem] setLeftItemsSupplementBackButton:YES];
    [[self navigationItem] setLeftBarButtonItems:btnList];
    
    [self makeUI];
    //[self fetchData];
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
    [[self expenseTableView] setDelegate:self];
    [[self expenseTableView] setDataSource:self];
    
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
        
        url = [NSString stringWithFormat:@"runs/%d/runPaymentMethods", [[self runEntity] runId]];
        [self setTcEntity:[[TimeCard alloc] init]];
        
        [[self tcEntity] setStartDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        [[self tcEntity] setEndDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        
        [client doGETWithURL:url params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary* dict) {
            
            NSLog(@">>> TIMECARDDETAIL ADD: %@", dict);
            
            if(response == RESTResponseSuccess) {
                
                NSArray* rpmList = [dict valueForKey:@"RunPaymentMethods"];
                [rpmList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    RunPaymentMethod* rpm = [[RunPaymentMethod alloc] initWithDict:obj];
                    PaymentMethod* pm = [rpm paymentMethod];
                    
                    TimeCardDetail* tcd = [[TimeCardDetail alloc] init];
                    TimeCard* tc = [[TimeCard alloc] init];
                    
                    [tcd setPaymentMethod:pm];
                    [tcd setEstUnits:[rpm estimatedUnits]];
                    [tcd setTimeCardUnits:[NSNumber numberWithDouble:0.0]];
                    [tcd setTimeCard:tc];
                    
                    [[self content] addObject:tcd];
                }];
                
                [[self expenseTableView] reloadData];
                
            } else {
                
                NSLog(@">> An ERROR OCCURED FETCHING ADD RPM");
            }
        }];
    }
    
    if ([self mode] == EntityModeEdit) {
        
        url = [NSString stringWithFormat:@"timeCards/%d/timeCardDetailsWithoutExpenses", [[self tcEntity] timeCardId]];
        
        [client doGETWithURL:url params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary* dict) {
            
            NSLog(@">>> TIMECARDDETAIL PM: %@", dict);
            
            if(response == RESTResponseSuccess) {
                
                NSArray* rpmList = [dict valueForKey:@"TimeCardDetails"];
                [rpmList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    TimeCardDetail* tcd = [[TimeCardDetail alloc] initWithDict:obj];
                    [tcd setIsExpense:NO];
                    [[self content] addObject:tcd];
                }];
                
                [[self expenseTableView] reloadData];
                
            } else {
                
                NSLog(@">> An ERROR OCCURED FETCHING EDIT PM");
            }
        }];
        
        url = [NSString stringWithFormat:@"timeCards/%d/timeCardDetailExpenses", [[self tcEntity] timeCardId]];
        
        [client doGETWithURL:url params:[[RESTParams alloc] init] complete:^(RESTResponse response, NSDictionary* dict) {
            
            NSLog(@">>> TIMECARDDETAIL EXP: %@", dict);
            
            if(response == RESTResponseSuccess) {
                
                NSArray* rpmList = [dict valueForKey:@"TimeCardDetails"];
                [rpmList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    TimeCardDetail* tcd = [[TimeCardDetail alloc] initWithDict:obj];
                    [tcd setIsExpense:YES];
                    [[self content] addObject:tcd];
                }];
                
                [[self expenseTableView] reloadData];
                
            } else {
                
                NSLog(@">> An ERROR OCCURED FETCHING EDIT EXP");
            }
        }];
    }
    
    [self populate];
}

-(void)populate {
    
    TimeCard* tc = [self tcEntity];
    
    if ([tc startDate]) {
        
        [[self startDatePicker] setDate:[tc startDate] animated:YES];
        [[self startTimePicker] setDate:[tc startDate] animated:YES];
    }
    
    if ([tc endDate]) {
        
        [[self endDatePicker] setDate:[tc endDate] animated:YES];
        [[self endTimePicker] setDate:[tc endDate] animated:YES];
    }
    
    [[self view] setNeedsUpdateConstraints];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimeCardExpenseCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tcExpenseCell"];
    if (!cell) {
        
        cell = [[TimeCardExpenseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tcExpenseCell"];
    }
    
    TimeCardDetail* tcd = [[self content] objectAtIndex:[indexPath row]];
    PaymentMethod* pm = [tcd paymentMethod];
    
    [[cell nameLabel] setText:( [tcd isExpense] ? [tcd timeCardDetailDescription] : [pm paymentMethodName])];
    
    double estAmt = [tcd isExpense] ? 0.0 : [[tcd estUnits] doubleValue];
    
    NSString* sEstAmt = [tcd isExpense] ? @"N/A" : [NSString stringWithFormat:@"%.2f", estAmt];
    
    [[cell estAmtLabel] setText:sEstAmt];
    
    double actAmt = [tcd isExpense] ? [[tcd totalAmount] doubleValue]: [[tcd timeCardUnits] doubleValue];
    
    NSString* sActAmt = [NSString stringWithFormat:@"%.2f", actAmt];
    
    [[cell actualAmtLabel] setText:sActAmt];
    [cell setNeedsUpdateConstraints];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@">>>> COUNT: %d", [[self content] count]);
    return [[self content] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TimeCardExpenseCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tcExpenseCell"];
    
    if (!cell) {
        
        cell = [[TimeCardExpenseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tcExpenseCell"];
    }
    
    [[cell nameLabel] setText:@"Description"];
    [[cell estAmtLabel] setText:@"Estimate"];
    [[cell actualAmtLabel] setText:@"Actual"];
    
    [[cell nameLabel] setTextColor:[BBHUtil headerTextColor]];
    [[cell estAmtLabel] setTextColor:[BBHUtil headerTextColor]];
    [[cell actualAmtLabel] setTextColor:[BBHUtil headerTextColor]];
    
    [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [cell setNeedsUpdateConstraints];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self showExpenseEditPopup:self entity:[[self content] objectAtIndex:[indexPath row]] mode: EntityModeEdit handler:^(ConfirmResponse response, TimeCardDetail* tcd) {
        
        if(response == ConfirmResponseSave) {
            
            RESTClient* client = [RESTClient instance];
            NSString* url = [NSString stringWithFormat:@"runs/%d/timeCards", [[self runEntity] runId]];
            
            NSError* error = nil;
            NSDictionary* tcdJSON = [tcd exportToDict];
            NSArray* listJSON = [[NSArray alloc] initWithObjects:tcdJSON, nil];
            NSDictionary* dictJSON = [[NSDictionary alloc] initWithObjectsAndKeys:listJSON, @"TimeCardDetails", nil];
            
            NSData* data = [NSJSONSerialization dataWithJSONObject:dictJSON options:kNilOptions error:&error];
            
            if(data && !error) {
                
                NSLog(@"Saving TCD (EDIT): %@", dictJSON);
                [client doPUTWithURL:url data:data complete:^(RESTResponse response, NSDictionary* dict) {
                   
                    if(response == RESTResponseSuccess) {
                        
                        NSLog(@">> Saved TCD (Edit): %@", dict);
                        [[self expenseTableView] reloadData];
                        
                    } else {
                        
                        NSLog(@">> Error saving TCD (Edit): %@", dict);
                    }
                }];
            }
        }
    }];
}

-(void) showExpenseEditPopup:(UIViewController *)vc entity:(TimeCardDetail*) tcd mode:(EntityMode) entityMode handler: (void (^)(ConfirmResponse, TimeCardDetail*)) handler {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:(entityMode == EntityModeAdd ? @"Add Time Card Detail" : @"Edit Time Card Detail") message:@"Please enter Time Card details" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([tcd isExpense]) {
            
            [tcd setTimeCardDetailDescription:[[[alert textFields] objectAtIndex:0] text]];
            [tcd setTotalAmount: [BBHUtil readDecimal:[[[alert textFields] objectAtIndex:1] text]]];
            
        } else {
            
            [tcd setTimeCardUnits:[BBHUtil readDecimal:[[[alert textFields] objectAtIndex:1] text]]];
        }
        
        handler(ConfirmResponseSave, tcd);
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        handler(ConfirmResponseCancel, tcd);
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"Description";
        textField.text = [tcd isExpense] ? [tcd timeCardDetailDescription] : [[tcd paymentMethod] paymentMethodName];
        textField.enabled = (tcd && [tcd isExpense]);
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = ([tcd isExpense] ? @"Expense Amount" : @"Actual Units");
        
        NSNumber* amt = [tcd isExpense] ? ([tcd totalAmount] ? [tcd totalAmount] : [NSNumber numberWithDouble:0.0]) : ([tcd timeCardUnits] ? [tcd timeCardUnits] : [NSNumber numberWithDouble:0.0]);
        
        textField.text = [NSString stringWithFormat:@"%.2f", [amt doubleValue]];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            
            NSString* sAmt = [textField text];
            NSNumber* amt = [BBHUtil readDecimal:sAmt];
            saveAction.enabled = amt ? ([amt doubleValue] >= 0.0 ? YES : NO) : NO;
        }];
    }];
    
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    
    UIPopoverPresentationController* popover = alert.popoverPresentationController;
    if(popover) {
        popover.barButtonItem = [self addBtn];
    }
    
    [vc presentViewController:alert animated:YES completion:nil];
}

-(void) addExpense {
    
    TimeCardDetail* entity = [[TimeCardDetail alloc] init];
    [entity setTimeCard:[self tcEntity]];
    [entity setIsExpense:YES];
    [entity setTotalAmount:[NSNumber numberWithDouble:0.0]];
    
    [self showExpenseEditPopup:self entity:entity mode: EntityModeAdd handler:^(ConfirmResponse response, TimeCardDetail* tcd) {
        
        if(response == ConfirmResponseSave) {
            
            RESTClient* client = [RESTClient instance];
            NSString* url = [NSString stringWithFormat:@"runs/%d/timeCards", [[self runEntity] runId]];
            
            NSError* error = nil;
            NSDictionary* tcdJSON = [tcd exportToDict];
            NSArray* listJSON = [[NSArray alloc] initWithObjects:tcdJSON, nil];
            NSDictionary* dictJSON = [[NSDictionary alloc] initWithObjectsAndKeys:listJSON, @"TimeCardDetails", nil];
            
            NSData* data = [NSJSONSerialization dataWithJSONObject:dictJSON options:kNilOptions error:&error];
            
            if(data && !error) {
                
                NSLog(@"Saving TCD (ADD): %@", dictJSON);
                [client doPUTWithURL:url data:data complete:^(RESTResponse response, NSDictionary* dict) {
                    
                    if(response == RESTResponseSuccess) {
                        
                        NSLog(@">> Saved TCD (ADD): %@", dict);
                        [[self content] addObject:tcd];
                        [[self expenseTableView] reloadData];
                        
                    } else {
                        
                        NSLog(@">> Error saving TCD (Edit): %@", dict);
                    }
                }];
            }
        }
    }];
}

-(void)confirmSave:(void (^)(ConfirmResponse))handler {
    //
}

-(void)saveInfo {
    //
}

@end