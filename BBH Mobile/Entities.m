//
//  Entities.m
//  BBH Mobile
//
//  Created by Mac-Mini on 9/29/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entities.h"

@implementation BBHUtil

static NSDateFormatter* dateScan;
static NSDateFormatter* dateFormat;
static SysUser* sysUser;
static UIColor* headerTextColor;

+ (NSDateFormatter *)dateScan {
    
    if(!dateScan) {
        
        dateScan = [[NSDateFormatter alloc] init];
        [dateScan setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    
    return dateScan;
}

+ (NSDateFormatter *)dateFormat {
    
    if(!dateFormat) {
        
        dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
    }
    
    return dateFormat;
}

+ (CGSize)statusBarSize {
    
    return [[UIApplication sharedApplication] statusBarFrame].size;
}

+ (CGFloat)statusBarHeight {
    
    return MIN([self statusBarSize].width, [self statusBarSize].height);
}

+ (BOOL) isNull: (id) obj {
    
    return !obj || (obj == (id) [NSNull null]);
}

+(UIColor *)headerTextColor {
    
    if(!headerTextColor) {
        
        headerTextColor = [UIColor colorWithRed:(59.0/255.0) green:(99.0/255.0) blue:(175.0/255.0) alpha:1.0];
    }
    
    return headerTextColor;
}

@end

@implementation BBHSession

static BBHSession* instance;

+ (instancetype)curSession {
    
    if(!instance || [instance expired]) {
        
        instance = [[BBHSession alloc] init];
    }
    
    return instance;
}

- (NSString *)loginType {
    
    return [[self curUser] driverId] == 0 ? @"Client" : @"Driver";
}

- (void)terminate {
    
    [self setExpired:YES];
}

@end

@implementation Paginate


@end

@implementation Link

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _href = [dict valueForKey:@"Href"];
        _method = [dict valueForKey:@"Method"];
        _rel = [dict valueForKey:@"Rel"];
    }
    
    return self;
}

@end

@implementation SysUser

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _userId = [[dict valueForKey:@"UserId"] intValue];
        
        id driverId = [dict valueForKey:@"DriverId"];
        _driverId = [BBHUtil isNull:driverId] ? 0 : [driverId intValue];
        
        id clientId = [dict valueForKey:@"ClientId"];
        _clientId = [BBHUtil isNull:clientId] ? 0 : [clientId intValue];
        
        _role = [[Role alloc] initWithDict:[dict valueForKey:@"Role"]];
        _userName = [dict valueForKey:@"UserName"];
        _emailId = [dict valueForKey:@"EmailId"];
        _firstName = [dict valueForKey:@"FirstName"];
        _lastName = [dict valueForKey:@"LastName"];
    }
    
    return self;
}

-(NSString *)fullName {
    
    return [NSString stringWithFormat:@"%@ %@", [self firstName], [self lastName]];
}

@end

@implementation Role

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _roleId = [[dict valueForKey:@"RoleId"] intValue];
        _roleName = [dict valueForKey:@"RoleName"];
        _roleType = [[RoleType alloc] initWithDict:[dict valueForKey:@"RoleType"]];
    }
    
    return self;
}

@end

@implementation RoleType

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _roleTypeId = [[dict valueForKey:@"RoleTypeId"] intValue];
        _roleTypeName = [dict valueForKey:@"RoleTypeName"];
    }
    
    return self;
}

@end

@implementation DeliveryScheduleType

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        //NSLog(@"Run[init] -> dict is NULL");
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _deliveryScheduleTypeId = [[dict valueForKey:@"DeliveryScheduleTypeId"] intValue];
        _deliveryScheduleTypeName = [dict valueForKey:@"DeliveryScheduleTypeName"];
    }
    
    return self;
}

@end

@implementation LocationType

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        //NSLog(@"Run[init] -> dict is NULL");
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _locationTypeId = [[dict valueForKey:@"LocationTypeId"] intValue];
        _locationTypeName = [dict valueForKey:@"LocationTypeName"];
    }
    
    return self;
}

@end

@implementation LoadingType

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        //NSLog(@"Run[init] -> dict is NULL");
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _loadingTypeId = [[dict valueForKey:@"LoadingTypeId"] intValue];
        _loadingTypeName = [dict valueForKey:@"LoadingTypeName"];
    }
    
    return self;
}

@end

@implementation RunFrequency

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        //NSLog(@"Run[init] -> dict is NULL");
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _runFrequencyId = [[dict valueForKey:@"RunFrequencyId"] intValue];
        _runFrequencyName = [dict valueForKey:@"RunFrequencyName"];
    }
    
    return self;
}

@end

@implementation PaymentMethod

- (instancetype) initWithDict: (NSDictionary*)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _paymentMethodId = [[dict valueForKey:@"PaymentMethodId"] intValue];
        _paymentMethodName = [dict valueForKey:@"PaymentMethodName"];
    }
    
    return self;
}

@end

@implementation RunPaymentMethod

- (instancetype) initWithDict: (NSDictionary*)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _runPaymentMethodId = [[dict valueForKey:@"RunPaymentMethodId"] intValue];
        
        id estimatedRate = [dict valueForKey:@"EstimatedRate"];
        _estimatedRate = [BBHUtil isNull:estimatedRate] ? nil : estimatedRate;
        
        id estimatedUnits = [dict valueForKey:@"EstimatedUnits"];
        _estimatedUnits = [BBHUtil isNull:estimatedUnits] ? nil : estimatedUnits;
        
        id isDeleted = [dict valueForKey:@"IsDeleted"];
        _isDeleted = [BBHUtil isNull:isDeleted] ? NO : (BOOL)isDeleted;
        
        id modifiedDate = [dict valueForKey:@"ModifiedDate"];
        _modifiedDate = [BBHUtil isNull:modifiedDate] ? nil : [[BBHUtil dateScan] dateFromString:modifiedDate];
        
        _paymentMethod = [[PaymentMethod alloc] initWithDict:[dict valueForKey:@"PaymentMethod"]];
    }
    
    return self;
}

@end

@implementation ExperienceType

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _experienceTypeId = [[dict valueForKey:@"ExperienceTypeId"] intValue];
        
        _experienceTypeName = [dict valueForKey:@"ExperienceTypeName"];
        
        id isDeleted = [dict valueForKey:@"IsDeleted"];
        _isDeleted = [BBHUtil isNull:isDeleted] ? NO : (BOOL)isDeleted;
    }
    
    return self;
}

@end


@implementation ExperienceSlot

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _experienceSlotId = [[dict valueForKey:@"ExperienceSlotId"] intValue];
        
        _experienceSlotName = [dict valueForKey:@"ExperienceSlotName"];
        
        id isDeleted = [dict valueForKey:@"IsDeleted"];
        _isDeleted = [BBHUtil isNull:isDeleted] ? NO : (BOOL)isDeleted;
        
        id sequence = [dict valueForKey:@"Sequence"];
        _sequence = [BBHUtil isNull:sequence] ? 0 : [sequence intValue];
    }
    
    return self;
}

@end

@implementation EquipmentSkill

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _equipmentSkillId = [[dict valueForKey:@"EquipmentSkillId"] intValue];
        
        _equipmentSkillName = [dict valueForKey:@"EquipmentSkillName"];
        
        id isDeleted = [dict valueForKey:@"IsDeleted"];
        _isDeleted = [BBHUtil isNull:isDeleted] ? NO : (BOOL)isDeleted;
        
        _experienceType = [[ExperienceType alloc] initWithDict:[dict valueForKey:@"ExperienceType"]];
    }
    
    return self;
}

@end

@implementation RunEquipmentSkill

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _runEquipmentSkillId = [[dict valueForKey:@"RunEquipmentSkillId"] intValue];
        
        _equipmentSkill = [[EquipmentSkill alloc] initWithDict:[dict valueForKey:@"EquipmentSkill"]];
        
        _experienceSlot = [[ExperienceSlot alloc] initWithDict:[dict valueForKey:@"ExperienceSlot"]];
        
        id isDeleted = [dict valueForKey:@"IsDeleted"];
        _isDeleted = [BBHUtil isNull:isDeleted] ? NO : (BOOL)isDeleted;
        
        id modifiedDate = [dict valueForKey:@"ModifiedDate"];
        _modifiedDate = [BBHUtil isNull:modifiedDate] ? nil : [[BBHUtil dateScan] dateFromString:modifiedDate];
    }
    
    return self;
}

@end

@implementation Driver

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _driverId = [[dict valueForKey:@"DriverId"] intValue];
        
        _firstName = [dict valueForKey:@"FirstName"];
        
        _lastName = [dict valueForKey:@"LastName"];
        
        _email = [dict valueForKey:@"Email"];
    }
    
    return self;
}

-(NSString *)fullName {
    
    return [NSString stringWithFormat:@"%@ %@", [self firstName], [self lastName]];
}

@end

@implementation TimeCardStatus

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _timeCardStatusId = [[dict valueForKey:@"TimeCardStatusId"] intValue];
        
        _timeCardStatusName = [dict valueForKey:@"TimeCardStatusName"];
        
        id isDeleted = [dict valueForKey:@"IsDeleted"];
        _isDeleted = [BBHUtil isNull:isDeleted] ? NO : (BOOL)isDeleted;
    }
    
    return self;
}

@end

@implementation TimeCard

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _timeCardId = [[dict valueForKey:@"TimeCardId"] intValue];
        
        id invoiceId = [dict valueForKey:@""];
        _invoiceId = [BBHUtil isNull:invoiceId] ? nil : invoiceId;
        
        id timeCardDate = [dict valueForKey:@"TimeCardDate"];
        _timeCardDate = [BBHUtil isNull:timeCardDate] ? nil : [[BBHUtil dateScan] dateFromString:timeCardDate];
        
        _timeCardStatus = [[TimeCardStatus alloc] initWithDict:[dict valueForKey:@"TimeCardStatus"]];
        
        id approvalComment = [dict valueForKey:@"ApprovalComment"];
        _approvalComment = [BBHUtil isNull:approvalComment] ? nil : approvalComment;
        
        id approvalDate = [dict valueForKey:@"ApprovalDate"];
        _approvalDate = [BBHUtil isNull:approvalDate] ? nil : [[BBHUtil dateScan] dateFromString:approvalDate];
        
        _driver = [[Driver alloc] initWithDict:[dict valueForKey:@"Driver"]];
        
        id actualCost = [dict valueForKey:@"ActualCost"];
        _actualCost = [BBHUtil isNull:actualCost] ? nil : actualCost;
        
        _approvalBy = [[SysUser alloc] initWithDict:[dict valueForKey:@"ApprovalBy"]];
    }
    
    return self;
}

@end

@implementation RunRelease

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _runReleaseId = [[dict valueForKey:@"RunReleaseId"] intValue];
        
        _driver = [[Driver alloc] initWithDict:[dict valueForKey:@"Driver"]];
        
        id isHonked = [dict valueForKey:@"IsHonked"];
        _isHonked = [BBHUtil isNull:isHonked] ? NO : (BOOL)isHonked;
        
        id isRunAccepted = [dict valueForKey:@"IsRunAccepted"];
        _isRunAccepted = [BBHUtil isNull:isRunAccepted] ? NO : (BOOL)isRunAccepted;
        
        id honkedByUserId = [dict valueForKey:@"HonkedByUserId"];
        _honkedByUserId = [BBHUtil isNull:honkedByUserId] ? nil : honkedByUserId;
        
        id releasedDate = [dict valueForKey:@"ReleaseDate"];
        _releasedDate = [BBHUtil isNull:releasedDate] ? nil : [[BBHUtil dateScan] dateFromString:releasedDate];
        
        id honkedDate = [dict valueForKey:@"HonkedDate"];
        _honkedDate = [BBHUtil isNull:honkedDate] ? nil : [[BBHUtil dateScan] dateFromString:honkedDate];
        
        id runAcceptedDate = [dict valueForKey:@"RunAcceptedDate"];
        _runAcceptedDate = [BBHUtil isNull:runAcceptedDate] ? nil : [[BBHUtil dateScan] dateFromString:runAcceptedDate];
    }
    
    return self;
}

@end

@implementation RunDriver

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _runDriverId = [[dict valueForKey:@"RunDriverId"] intValue];
        
        _driver = [[Driver alloc] initWithDict:[dict valueForKey:@"Driver"]];
        
        id isConfirmed = [dict valueForKey:@"IsConfirmed"];
        _isConfirmed = [BBHUtil isNull:isConfirmed] ? NO : (BOOL)isConfirmed;
        
        id isCancelledByDriver = [dict valueForKey:@"IsCancelledByDriver"];
        _isCancelledByDriver = [BBHUtil isNull:isCancelledByDriver] ? NO : (BOOL)isCancelledByDriver;
        
        id driverAcceptedDate = [dict valueForKey:@"DriverAcceptedDate"];
        _driverAcceptedDate = [BBHUtil isNull:driverAcceptedDate] ? nil : [[BBHUtil dateScan] dateFromString:driverAcceptedDate];
        
        id driverConfirmationReceivedDate = [dict valueForKey:@"DriverConfirmationReceivedDate"];
        _driverConfirmationReceivedDate = [BBHUtil isNull:driverConfirmationReceivedDate] ? nil : [[BBHUtil dateScan] dateFromString:driverConfirmationReceivedDate];
        
        id cancellationReceivedDate = [dict valueForKey:@"CancellationReceivedDate"];
        _cancellationReceivedDate = [BBHUtil isNull:cancellationReceivedDate] ? nil : [[BBHUtil dateScan] dateFromString:cancellationReceivedDate];
    }
    
    return self;
}

@end

@implementation Run

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        //NSLog(@"Run[init] -> dict is NULL");
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _client = [[Client alloc] initWithDict:[dict valueForKey:@"Client"]];
        
        id createdDate = [dict valueForKey:@"CreatedDate"];
        _createdDate = [BBHUtil isNull:createdDate] ? nil : [[BBHUtil dateScan] dateFromString:createdDate];
        
        id criminalBackgroundCheckRequired = [dict valueForKey:@"CriminalBackgroundCheckRequired"];
        _criminalBackgroundCheckRequired = [BBHUtil isNull:criminalBackgroundCheckRequired] ? NO : (BOOL)criminalBackgroundCheckRequired;
        
        id deliveryScheduleType = [dict valueForKey:@"DeliveryScheduleType"];
        _deliveryScheduleType = [BBHUtil isNull:deliveryScheduleType] ? nil : [[DeliveryScheduleType alloc] initWithDict:deliveryScheduleType];
        
        id detentionFee = [dict valueForKey:@"DetentionFee"];
        _detentionFee = [BBHUtil isNull:detentionFee] ? nil : detentionFee;
        
        id driverAssist = [dict valueForKey:@"DriverAssist"];
        _driverAssist = [BBHUtil isNull:driverAssist] ? NO : (BOOL)driverAssist;
        
        _driverClass = [[DriverClass alloc] initWithDict:[dict valueForKey:@"DriverClass"]];
        _driverType = [[DriverType alloc] initWithDict:[dict valueForKey:@"DriverType"]];
        
        _dropOffAddress = [[Address alloc] initWithDict:[dict valueForKey:@"DropOffAddress"]];
        _dropOffContactName = [dict valueForKey:@"DropOffContactName"];
        
        id dropOffLocationType = [dict valueForKey:@"DropOffLocationType"];
        _dropOffLocationType = [BBHUtil isNull:dropOffLocationType] ? nil : [[LocationType alloc] initWithDict:dropOffLocationType];
        
        _equipmentType = [dict valueForKey:@"EquipmentType"];
        
        id facilityWithDock = [dict valueForKey:@"FacilityWithDock"];
        _facilityWithDock = [BBHUtil isNull:facilityWithDock] ? NO : (BOOL)facilityWithDock;
        
        _freightDetails = [dict valueForKey:@"FreightDetails"];
        
        id fuelAdvanceAmount = [dict valueForKey:@"FuelAdvanceAmount"];
        _fuelAdvanceAmount = [BBHUtil isNull:fuelAdvanceAmount] ? nil : fuelAdvanceAmount;
        
        _hiringCriteria = [dict valueForKey:@"HiringCriteria"];
        
        if(!_estimatedCost) {
            id estimatedCost = [dict valueForKey:@"EstimatedCost"];
            _estimatedCost = [BBHUtil isNull:estimatedCost] ? nil : estimatedCost;
        }
        
        id isRecurring = [dict valueForKey:@"IsRecurring"];
        _isRecurring = [BBHUtil isNull:isRecurring] ? NO : (BOOL)isRecurring;
        
        id isTeamRun = [dict valueForKey:@"IsTeamRun"];
        _isTeamRun = [BBHUtil isNull:isTeamRun] ? NO : (BOOL)isTeamRun;
        
        id isTrailerProvided = [dict valueForKey:@"IsTrailerProvided"];
        _isTrailerProvided = [BBHUtil isNull:isTrailerProvided] ? NO : (BOOL)isTrailerProvided;
        
        NSArray* linkList = [dict valueForKey:@"Links"];
        _links = [NSMutableDictionary dictionary];
        
        [linkList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            Link* link = [[Link alloc] initWithDict:[linkList objectAtIndex:0]];
            [_links setValue:link forKey:[link rel]];
        }];
        
        _loadDescription = [dict valueForKey:@"LoadDescription"];
        
        id loadingType = [dict valueForKey:@"LoadingType"];
        _loadingType = [BBHUtil isNull:loadingType] ? nil : [[LoadingType alloc] initWithDict:loadingType];
        
        id lumperFee = [dict valueForKey:@"LumperFee"];
        _lumperFee = [BBHUtil isNull:lumperFee] ? nil : lumperFee;
        
        id modifiedDate = [dict valueForKey:@"ModifiedDate"];
        _modifiedDate = [BBHUtil isNull:modifiedDate] ? nil : [[BBHUtil dateScan] dateFromString:modifiedDate];
        
        id needBillOfLoading = [dict valueForKey:@"NeedBillOfLlading"];
        _needBillOfLoading = [BBHUtil isNull:needBillOfLoading] ? NO : (BOOL) needBillOfLoading;
        
        id ooNeedScaleTickets = [dict valueForKey:@"OONeedScaleTickets"];
        _ooNeedScaleTickets = [BBHUtil isNull:ooNeedScaleTickets] ? NO : (BOOL)ooNeedScaleTickets;
        
        id offerFuelAdvance = [dict valueForKey:@"OfferFuelAdvance"];
        _offerFuelAdvance = [BBHUtil isNull:offerFuelAdvance] ? NO : (BOOL)offerFuelAdvance;
        
        id payDetentionFee = [dict valueForKey:@"PayDetentionFee"];
        _payDetentionFee = [BBHUtil isNull:payDetentionFee] ? NO : (BOOL)payDetentionFee;
        
        id payLumperFee = [dict valueForKey:@"PayLumperFee"];
        _payLumperFee = [BBHUtil isNull:payLumperFee] ? NO : (BOOL)payLumperFee;
        
        _pickupAddress = [[Address alloc] initWithDict:[dict valueForKey:@"PickUpAddress"]];
        _pickupContactName = [dict valueForKey:@"PickUpContactName"];
        _pickupContactPhone = [dict valueForKey:@"PickUpContactPhone"];
        
        id pickupLocationType = [dict valueForKey:@"PickUpLocationType"];
        _pickupLocationType = [BBHUtil isNull:pickupLocationType] ? nil : [[LocationType alloc] initWithDict:pickupLocationType];
        
        id releasedDate = [dict valueForKey:@"ReleasedDate"];
        _releasedDate = [BBHUtil isNull:releasedDate] ? nil : [[BBHUtil dateScan] dateFromString:releasedDate];
        
        id runDays = [dict valueForKey:@"RunDays"];
        _runDays = [BBHUtil isNull:runDays] ? nil : runDays;
        
        id runDuration = [dict valueForKey:@"RunDuration"];
        _runDuration = [BBHUtil isNull:runDuration] ? nil : [[BBHUtil dateScan] dateFromString:runDuration];
        
        id runEndDate = [dict valueForKey:@"RunEnd"];
        _runEndDate = [BBHUtil isNull:runEndDate] ? nil : [[BBHUtil dateScan] dateFromString:runEndDate];
        
        id runFrequency = [dict valueForKey:@"RunFrequency"];
        _runFrequency = [BBHUtil isNull:runFrequency] ? nil : [[RunFrequency alloc] initWithDict:runFrequency];
        
        _runId = [((NSNumber*)[dict valueForKey:@"RunId"]) intValue];
        _runNumber = [dict valueForKey:@"RunNumber"];
        
        id runOccurrence = [dict valueForKey:@"RunOccurrence"];
        _runOccurrence = [BBHUtil isNull:runOccurrence] ? 0 : [runOccurrence intValue];
        
        id runStartDate = [dict valueForKey:@"RunStart"];
        _runStartDate = [BBHUtil isNull:runStartDate] ? nil : [[BBHUtil dateScan] dateFromString:runStartDate];
        
        _runStatus = [[RunStatus alloc] initWithDict:[dict valueForKey:@"RunStatus"]];
        
        id runStops = [dict valueForKey:@"RunStops"];
        _runStops = [BBHUtil isNull:runStops] ? 0 : [runStops intValue];
        
        _runTitle = [dict valueForKey:@"RunTitle"];
        
        id sealOnTrailer = [dict valueForKey:@"SealOnTrailer"];
        _sealOnTrailer = [BBHUtil isNull:sealOnTrailer] ? NO : (BOOL)sealOnTrailer;
        
        _specialInstructions = [dict valueForKey:@"SpecialInstructions"];
        
        id tonuForOO = [dict valueForKey:@"TONUForOO"];
        _tonuForOO = [BBHUtil isNull:tonuForOO] ? NO : (BOOL)tonuForOO;
        
        id tonuPenaltyAmount = [dict valueForKey:@"TONUPenaltyAmount"];
        _tonuPenaltyAmount = [BBHUtil isNull:tonuPenaltyAmount] ? nil : tonuPenaltyAmount;
        
        id totalFreightWeight = [dict valueForKey:@"TotalFreightWeight"];
        _totalFreightWeight = [BBHUtil isNull:totalFreightWeight] ? nil : totalFreightWeight;
    }
    
    return self;
}

@end

@implementation RunStatus

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        //NSLog(@"RunStatus[init] -> dict is NULL");
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _runStatusId = [[dict objectForKey:@"RunStatusId"] intValue];
        _runStatusName = [dict objectForKey:@"RunStatusName"];
    }
    
    return self;
}

@end

@implementation Client

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        //NSLog(@"Client[init] -> dict is NULL");
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _clientId = [[dict objectForKey:@"ClientId"] intValue];
        _clientName = [dict objectForKey:@"ClientName"];
        _email = [dict objectForKey:@"Email"];
    }
    
    return self;
}

@end

@implementation DriverClass

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        //NSLog(@"DriverClass[init] -> dict is NULL");
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _driverClassId = [[dict objectForKey:@"DriverClassId"] intValue];
        _driverClassName = [dict objectForKey:@"DriverClassName"];
    }
    
    return self;
}

@end

@implementation DriverType

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        //NSLog(@"DriverType[init] -> dict is NULL");
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _driverTypeId = [[dict objectForKey:@"DriverTypeId"] intValue];
        _driverTypeName = [dict objectForKey:@"DriverTypeName"];
    }
    
    return self;
}

@end

@implementation Country

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        //NSLog(@"Country[init] -> dict is NULL");
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _countryId = [[dict objectForKey:@"CountryId"] intValue];
        _countryName = [dict objectForKey:@"CountryName"];
    }
    
    return self;
}

@end

@implementation AddressType

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        //NSLog(@"AddressType[init] -> dict is NULL");
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _addressTypeId = [[dict objectForKey:@"AddressTypeId"] intValue];
        _addressTypeName = [dict objectForKey:@"AddressTypeName"];
    }
    
    return self;
}

@end

@implementation Address

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        //NSLog(@"Address[init] -> dict is NULL");
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _address1 = [dict objectForKey:@"Address1"];
        _address2 = [dict objectForKey:@"Address2"];
        _addressId = [[dict objectForKey:@"AddressId"] intValue];
        _addressType = [[AddressType alloc] initWithDict:[dict objectForKey:@"AddressType"]];
        _city = [dict objectForKey:@"City"];
        _country = [[Country alloc] initWithDict:[dict objectForKey:@"Country"]];
        
        id isCurrent = [dict objectForKey:@"IsCurrent"];
        _isCurrent = (isCurrent == (id)[NSNull null]) ? NO : (BOOL)isCurrent;
        
        NSDateFormatter* fmt = [BBHUtil dateScan];
        
        id modifiedDate = [dict objectForKey:@"ModifiedDate"];
        _modifiedDate = (modifiedDate == (id)[NSNull null]) ? nil : [fmt dateFromString:modifiedDate];
        
        _stateCode = [dict objectForKey:@"StateCode"];
        _zipCode = [dict objectForKey:@"ZipCode"];
    }
    
    return self;
}

- (NSString *)displayString {
    
    return [NSString stringWithFormat:@"%@, %@", [self city], [self zipCode]];
}

@end

@implementation InvoiceStatus

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _invoiceStatusId = [[dict valueForKey:@"InvoiceStatusId"] intValue];
        _invoiceStatusName = [dict valueForKey:@"InvoiceStatusName"];
        
        id isDeleted = [dict valueForKey:@"IsDeleted"];
        _isDeleted = [BBHUtil isNull:isDeleted] ? NO : (BOOL)isDeleted;
    }
    
    return self;
}

@end

@implementation Invoice

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if([BBHUtil isNull:dict]) {
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _invoiceId = [[dict valueForKey:@"InvoiceId"] intValue];
        
        id invoiceNumber = [dict valueForKey:@"InvoiceNumber"];
        _invoiceNumber = [BBHUtil isNull:invoiceNumber] ? nil : invoiceNumber;
        
        _invoiceStatus = [[InvoiceStatus alloc] initWithDict:[dict valueForKey:@"InvoiceStatus"]];
        
        id estimatedCost = [dict valueForKey:@"EstimatedCost"];
        _estimatedCost = [BBHUtil isNull:estimatedCost] ? nil : estimatedCost;
        
        id invoiceAmount = [dict valueForKey:@"InvoiceAmount"];
        _invoiceAmount = [BBHUtil isNull:invoiceAmount] ? nil : invoiceAmount;
        
        id invoiceDate = [dict valueForKey:@"InvoiceDate"];
        _invoiceDate = [BBHUtil isNull:invoiceDate] ? nil : [[BBHUtil dateScan] dateFromString:invoiceDate];
        
        id actualCost = [dict valueForKey:@"ActualCost"];
        _actualCost = [BBHUtil isNull:actualCost] ? nil : actualCost;
        
        id approvalBy = [dict valueForKey:@"ApprovalBy"];
        _approvalBy = [BBHUtil isNull:approvalBy] ? nil : approvalBy;
        
        id approvalDate = [dict valueForKey:@"ApprovalDate"];
        _approvalDate = [BBHUtil isNull:approvalDate] ? nil : [[BBHUtil dateScan] dateFromString:approvalDate];
        
        _client = [[Client alloc] initWithDict:[dict valueForKey:@"Client"]];
        
        _driver = [[Driver alloc] initWithDict:[dict valueForKey:@"Driver"]];
        
        _run = [[Run alloc] initWithDict:[dict valueForKey:@"Run"]];
    }
    
    return self;
}

@end