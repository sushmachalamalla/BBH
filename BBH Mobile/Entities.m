//
//  Entities.m
//  BBH Mobile
//
//  Created by Mac-Mini on 9/29/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entities.h"
#import <objc/runtime.h>

@implementation BBHEntity

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(NSDictionary *)exportToDict {
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    unsigned int count = 0;
    
    objc_property_t* property = class_copyPropertyList(objc_getClass([NSStringFromClass([self class]) cStringUsingEncoding:NSUTF8StringEncoding]), &count);
    
    const char* pName = NULL;
    NSString* key = nil;
    id value = nil;
    
    for (int i=0; i<count; i++) {
        
        pName = property_getName(property[i]);
        key = [NSString stringWithCString:pName encoding:NSUTF8StringEncoding];
        
        value = [self valueForKey:key];
        key = [NSString stringWithFormat:@"%@%@", [[key substringToIndex:1] uppercaseString],[key substringFromIndex:1]];
        
        //NSLog(@"Property: %s: %@", pName, value);
        
        if([value isKindOfClass:[BBHEntity class]]) {
            
            [dict setValue:[((BBHEntity*)value) exportToDict] forKey:key];
            
        } else if([value isKindOfClass:[NSDate class]]) {
            
            [dict setValue:(value ? [[BBHUtil dateScan] stringFromDate:value] : [NSNull null]) forKey:key];
            
        } else if([value isKindOfClass:[NSDictionary class]]) {
            
            if([key isEqualToString:@"Links"]) {
                
                NSDictionary* dict = (NSDictionary*) value;
                NSMutableArray* array = [NSMutableArray array];
                
                [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    
                    Link* link = (Link*)obj;
                    [array addObject:[link exportToDict]];
                }];
                
                [dict setValue:array forKey:key];
            }
            
        } else {
            
            [dict setValue:(value ? value : [NSNull null]) forKey:key];
        }
    }
    
    return dict;
}

@end

@implementation Paginate

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
        return nil;
    }
    
    self = [super init];
    
    if(self) {
        
        _deliveryScheduleTypeId = [[dict valueForKey:@"DeliveryScheduleTypeId"] intValue];
        _deliveryScheduleTypeName = [dict valueForKey:@"DeliveryScheduleTypeName"];
    }
    
    return self;
}

-(NSString *)description {
    
    return [self deliveryScheduleTypeName];
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

-(NSString *)description {
    
    return [self locationTypeName];
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

-(NSString *)description {
    
    return [self loadingTypeName];
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

-(NSString *)description {
    
    return [self runFrequencyName];
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
        _isDeleted = [BBHUtil isNull:isDeleted] ? NO : [isDeleted boolValue];
        
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
        _isDeleted = [BBHUtil isNull:isDeleted] ? NO : [isDeleted boolValue];
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
        _isDeleted = [BBHUtil isNull:isDeleted] ? NO : [isDeleted boolValue];
        
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
        _isDeleted = [BBHUtil isNull:isDeleted] ? NO : [isDeleted boolValue];
        
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
        _isDeleted = [BBHUtil isNull:isDeleted] ? NO : [isDeleted boolValue];
        
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
        _isDeleted = [BBHUtil isNull:isDeleted] ? NO : [isDeleted boolValue];
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
        _isHonked = [BBHUtil isNull:isHonked] ? NO : [isHonked boolValue];
        
        id isRunAccepted = [dict valueForKey:@"IsRunAccepted"];
        _isRunAccepted = [BBHUtil isNull:isRunAccepted] ? NO : [isRunAccepted boolValue];
        
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
        _isConfirmed = [BBHUtil isNull:isConfirmed] ? NO : [isConfirmed boolValue];
        
        id isCancelledByDriver = [dict valueForKey:@"IsCancelledByDriver"];
        _isCancelledByDriver = [BBHUtil isNull:isCancelledByDriver] ? NO : [isCancelledByDriver boolValue];
        
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
        _criminalBackgroundCheckRequired = [BBHUtil isNull:criminalBackgroundCheckRequired] ? NO : [criminalBackgroundCheckRequired boolValue];
        
        id deliveryScheduleType = [dict valueForKey:@"DeliveryScheduleType"];
        _deliveryScheduleType = [BBHUtil isNull:deliveryScheduleType] ? nil : [[DeliveryScheduleType alloc] initWithDict:deliveryScheduleType];
        
        id detentionFee = [dict valueForKey:@"DetentionFee"];
        _detentionFee = [BBHUtil isNull:detentionFee] ? nil : detentionFee;
        
        id driverAssist = [dict valueForKey:@"DriverAssist"];
        _driverAssist = [BBHUtil isNull:driverAssist] ? NO : [driverAssist boolValue];
        
        _driverClass = [[DriverClass alloc] initWithDict:[dict valueForKey:@"DriverClass"]];
        _driverType = [[DriverType alloc] initWithDict:[dict valueForKey:@"DriverType"]];
        
        id dropOffContactName = [dict valueForKey:@"DropOffContactName"];
        _dropOffContactName = [BBHUtil isNull:dropOffContactName] ? nil : dropOffContactName;
        
        id dropOffContactPhone = [dict valueForKey:@"DropOffContactPhone"];
        _dropOffContactPhone = [BBHUtil isNull:dropOffContactPhone] ? nil : dropOffContactPhone;
        
        _dropOffAddress = [[Address alloc] initWithDict:[dict valueForKey:@"DropOffAddress"]];
        
        id dropOffLocationType = [dict valueForKey:@"DropOffLocationType"];
        _dropOffLocationType = [BBHUtil isNull:dropOffLocationType] ? nil : [[LocationType alloc] initWithDict:dropOffLocationType];
        
        id equipmentType = [dict valueForKey:@"EquipmentType"];
        _equipmentType = [BBHUtil isNull:equipmentType] ? nil : equipmentType;
        
        id facilityWithDock = [dict valueForKey:@"FacilityWithDock"];
        _facilityWithDock = [BBHUtil isNull:facilityWithDock] ? NO : [facilityWithDock boolValue];
        
        id freightDetails = [dict valueForKey:@"FreightDetails"];
        _freightDetails = [BBHUtil isNull:freightDetails] ? nil : freightDetails;
        
        id fuelAdvanceAmount = [dict valueForKey:@"FuelAdvanceAmount"];
        _fuelAdvanceAmount = [BBHUtil isNull:fuelAdvanceAmount] ? nil : fuelAdvanceAmount;
        
        id hiringCriteria = [dict valueForKey:@"HiringCriteria"];
        _hiringCriteria = [BBHUtil isNull:hiringCriteria] ? nil : hiringCriteria;
        
        if(!_estimatedCost) {
            id estimatedCost = [dict valueForKey:@"EstimatedCost"];
            _estimatedCost = [BBHUtil isNull:estimatedCost] ? nil : estimatedCost;
        }
        
        id isRecurring = [dict valueForKey:@"IsRecurring"];
        _isRecurring = [BBHUtil isNull:isRecurring] ? NO : [isRecurring boolValue];
        
        id isTeamRun = [dict valueForKey:@"IsTeamRun"];
        _isTeamRun = [BBHUtil isNull:isTeamRun] ? NO : [isTeamRun boolValue];
        
        id isTrailerProvided = [dict valueForKey:@"IsTrailerProvided"];
        _isTrailerProvided = [BBHUtil isNull:isTrailerProvided] ? NO : [isTrailerProvided boolValue];
        
        NSArray* linkList = [dict valueForKey:@"Links"];
        _links = [NSMutableDictionary dictionary];
        
        [linkList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            Link* link = [[Link alloc] initWithDict:[linkList objectAtIndex:idx]];
            [_links setValue:link forKey:[link rel]];
        }];
        
        id loadDescription = [dict valueForKey:@"LoadDescription"];
        _loadDescription = [BBHUtil isNull:loadDescription] ? nil : loadDescription;
        
        id loadingType = [dict valueForKey:@"LoadingType"];
        _loadingType = [BBHUtil isNull:loadingType] ? nil : [[LoadingType alloc] initWithDict:loadingType];
        
        id lumperFee = [dict valueForKey:@"LumperFee"];
        _lumperFee = [BBHUtil isNull:lumperFee] ? nil : lumperFee;
        
        id modifiedDate = [dict valueForKey:@"ModifiedDate"];
        _modifiedDate = [BBHUtil isNull:modifiedDate] ? nil : [[BBHUtil dateScan] dateFromString:modifiedDate];
        
        id needBillOfLoading = [dict valueForKey:@"NeedBillOfLlading"];
        _needBillOfLoading = [BBHUtil isNull:needBillOfLoading] ? NO : [needBillOfLoading boolValue];
        
        id ooNeedScaleTickets = [dict valueForKey:@"OONeedScaleTickets"];
        _ooNeedScaleTickets = [BBHUtil isNull:ooNeedScaleTickets] ? NO : [ooNeedScaleTickets boolValue];
        
        id offerFuelAdvance = [dict valueForKey:@"OfferFuelAdvance"];
        _offerFuelAdvance = [BBHUtil isNull:offerFuelAdvance] ? NO : [offerFuelAdvance boolValue];
        
        id payDetentionFee = [dict valueForKey:@"PayDetentionFee"];
        _payDetentionFee = [BBHUtil isNull:payDetentionFee] ? NO : [payDetentionFee boolValue];
        
        id payLumperFee = [dict valueForKey:@"PayLumperFee"];
        _payLumperFee = [BBHUtil isNull:payLumperFee] ? NO : [payLumperFee boolValue];
        
        _pickupAddress = [[Address alloc] initWithDict:[dict valueForKey:@"PickUpAddress"]];
        
        id pickupContactName = [dict valueForKey:@"PickUpContactName"];
        _pickupContactName = [BBHUtil isNull:pickupContactName] ? nil : pickupContactName;
        
        id pickupContactPhone = [dict valueForKey:@"PickUpContactPhone"];
        _pickupContactPhone = [BBHUtil isNull:pickupContactPhone] ? nil : pickupContactPhone;
        
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
        
        id runTitle = [dict valueForKey:@"RunTitle"];
        _runTitle = [BBHUtil isNull:runTitle] ? nil : runTitle;
        
        id sealOnTrailer = [dict valueForKey:@"SealOnTrailer"];
        _sealOnTrailer = [BBHUtil isNull:sealOnTrailer] ? NO : [sealOnTrailer boolValue];
        
        id specialInstructions = [dict valueForKey:@"SpecialInstructions"];
        _specialInstructions = [BBHUtil isNull: specialInstructions] ? nil : specialInstructions;
        
        id tonuForOO = [dict valueForKey:@"TONUForOO"];
        _tonuForOO = [BBHUtil isNull:tonuForOO] ? NO : [tonuForOO boolValue];
        
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

-(NSString *)description {
    
    return [self driverClassName];
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

-(NSString *)description {
    
    return [self driverTypeName];
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
        
        id address1 = [dict objectForKey:@"Address1"];
        _address1 = [BBHUtil isNull:address1] ? nil : address1;
        
        id address2 = [dict objectForKey:@"Address2"];
        _address2 = [BBHUtil isNull:address2] ? nil : address2;
        
        _addressId = [[dict objectForKey:@"AddressId"] intValue];
        
        _addressType = [[AddressType alloc] initWithDict:[dict objectForKey:@"AddressType"]];
        
        id city = [dict objectForKey:@"City"];
        _city = [BBHUtil isNull:city] ? nil : city;
        
        _country = [[Country alloc] initWithDict:[dict objectForKey:@"Country"]];
        
        id isCurrent = [dict objectForKey:@"IsCurrent"];
        _isCurrent = (isCurrent == (id)[NSNull null]) ? NO : [isCurrent boolValue];
        
        NSDateFormatter* fmt = [BBHUtil dateScan];
        
        id modifiedDate = [dict objectForKey:@"ModifiedDate"];
        _modifiedDate = (modifiedDate == (id)[NSNull null]) ? nil : [fmt dateFromString:modifiedDate];
        
        id stateCode = [dict objectForKey:@"StateCode"];
        _stateCode = [BBHUtil isNull:stateCode] ? nil : stateCode;
        
        id zipCode = [dict objectForKey:@"ZipCode"];
        _zipCode = [BBHUtil isNull:zipCode] ? nil : zipCode;
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
        _isDeleted = [BBHUtil isNull:isDeleted] ? NO : [isDeleted boolValue];
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