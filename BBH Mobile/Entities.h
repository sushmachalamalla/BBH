//
//  SysUser.h
//  BBH Mobile
//
//  Created by Mac-Mini on 9/25/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "Foundation/Foundation.h"
#import "UIKit/uikit.h"
#import "BBHUtil.h"

#ifndef BBH_Mobile_SysUser_h
#define BBH_Mobile_SysUser_h

/* Base Entity Protocol */
@protocol BBHEntityProtocol <NSObject>

- (instancetype) init;
- (instancetype) initWithDict: (NSDictionary*)dict;
- (NSDictionary*) exportToDict;

@end

@interface BBHNone : NSObject

+(instancetype) instance;

@end

@interface BBHEntity : NSObject<BBHEntityProtocol>

@end

/* Role Type */
@interface RoleType : BBHEntity

@property int roleTypeId;
@property NSString* roleTypeName;

@end

/* Role */
@interface Role : BBHEntity

@property int roleId;
@property NSString* roleName;
@property RoleType* roleType;

@end

/* Sys User */
@interface SysUser: BBHEntity

@property int userId;
@property NSString* userName;
@property NSString* firstName;
@property NSString* lastName;
@property NSString* emailId;

@property int clientId;
@property int driverId;

@property Role* role;

-(NSString*) fullName;

@end

/* Client */
@interface Client: BBHEntity

@property int clientId;
@property NSString* clientName;
@property NSString* email;

@end

/* Driver Class */
@interface DriverClass: BBHEntity

@property int driverClassId;
@property NSString* driverClassName;

@end

/* Driver Type */
@interface DriverType : BBHEntity

@property int driverTypeId;
@property NSString* driverTypeName;

@end

/* Address Type */

@interface AddressType: BBHEntity

@property int addressTypeId;
@property NSString* addressTypeName;

@end

/* Country */
@interface Country : BBHEntity

@property int countryId;
@property NSString* countryName;

@end

/* Address */
@interface Address : BBHEntity

@property NSString* address1;
@property NSString* address2;
@property int addressId;
@property AddressType* addressType;
@property NSString* city;
@property Country* country;
@property BOOL isCurrent;
@property NSDate* modifiedDate;
@property NSString* stateCode;
@property NSString* zipCode;

- (NSString*) displayString;

@end

/* Link */
@interface Link : BBHEntity

@property NSString* href;
@property NSString* method;
@property NSString* rel;

@end

/* Run Status */
@interface RunStatus : BBHEntity

@property int runStatusId;
@property NSString* runStatusName;

@end

/* Delivery Schedule Type */
@interface DeliveryScheduleType : BBHEntity

@property int deliveryScheduleTypeId;
@property NSString* deliveryScheduleTypeName;

@end

/* Location Type */
@interface LocationType : BBHEntity

@property int locationTypeId;
@property NSString* locationTypeName;

@end

/* Equipment Type */
@interface EquipmentType : BBHEntity

@property int equipmentTypeId;
@property NSString* equipmentTypeName;

@end

/* Loading Type */
@interface LoadingType : BBHEntity

@property int loadingTypeId;
@property NSString* loadingTypeName;

@end

/* Run Frequency */
@interface RunFrequency : BBHEntity

@property int runFrequencyId;
@property NSString* runFrequencyName;

@end

/* Payment Method */
@interface PaymentMethod : BBHEntity

@property int paymentMethodId;
@property NSString* paymentMethodName;
@property BOOL isDeleted;

@end

/* Experience Type */
@interface ExperienceType : BBHEntity

@property int experienceTypeId;
@property NSString* experienceTypeName;
@property BOOL isDeleted;

@end


/* Equipment Skill */
@interface EquipmentSkill: BBHEntity

@property int equipmentSkillId;
@property NSString* equipmentSkillName;
@property ExperienceType* experienceType;
@property BOOL isDeleted;

@end

/* Experience Slot */
@interface ExperienceSlot : BBHEntity

@property int experienceSlotId;
@property NSString* experienceSlotName;
@property BOOL isDeleted;
@property int sequence;

@end

/* RunEquipmentSkill */
@interface RunEquipmentSkill : BBHEntity

@property int runEquipmentSkillId;
@property EquipmentSkill* equipmentSkill;
@property ExperienceSlot* experienceSlot;
@property BOOL isDeleted;
@property NSDate* modifiedDate;

@end

/* Run Payment Method */
@interface RunPaymentMethod : BBHEntity

@property int runPaymentMethodId;
@property PaymentMethod* paymentMethod;
@property NSNumber* estimatedRate;
@property NSNumber* estimatedUnits;
@property BOOL isDeleted;
@property NSDate* modifiedDate;

@end

/* Time Card Status */
@interface TimeCardStatus : BBHEntity

@property int timeCardStatusId;
@property NSString* timeCardStatusName;
@property BOOL isDeleted;

@end

/* Driver */
@interface Driver : BBHEntity

@property int driverId;
@property NSString* email;
@property NSString* firstName;
@property NSString* lastName;

-(NSString*) fullName;

@end

/* Time Card */
@interface TimeCard: BBHEntity

@property int timeCardId;
@property NSNumber* invoiceId;
@property NSDate* timeCardDate;
@property NSDate* startDate;
@property NSDate* endDate;
@property TimeCardStatus* timeCardStatus;
@property Driver* driver;
@property NSNumber* actualCost;
@property SysUser* approvalBy;
@property NSString* approvalComment;
@property NSDate* approvalDate;

@end

/* Time Card */
@interface TimeCardDetail : BBHEntity

@property int timeCardDetailId;
@property TimeCard* timeCard;
@property RunPaymentMethod* runPaymentMethod;
@property NSNumber* timeCardUnits;
@property NSNumber* totalAmount;
@property NSString* timeCardDetailDescription;
@property BOOL isExpense;

@end

/* Run Release */
@interface RunRelease : BBHEntity

@property int runReleaseId;
@property Driver* driver;
@property BOOL isHonked;
@property BOOL isRunAccepted;
@property NSNumber* honkedByUserId;
@property NSDate* releasedDate;
@property NSDate* honkedDate;
@property NSDate* runAcceptedDate;

@end

/* Run Driver */
@interface RunDriver : BBHEntity

@property int runDriverId;
@property Driver* driver;
@property BOOL isConfirmed;
@property BOOL isCancelledByDriver;
@property NSDate* driverAcceptedDate;
@property NSDate* driverConfirmationReceivedDate;
@property NSDate* cancellationReceivedDate;

@end

/* Run */
@interface Run : BBHEntity

@property int runId;
@property NSString* runNumber;
@property NSString* runTitle;

@property Client* client;

@property DriverClass* driverClass;
@property DriverType* driverType;

@property Address* dropOffAddress;
@property NSString* dropOffContactName;
@property NSString* dropOffContactPhone;
@property LocationType* dropOffLocationType;

@property Address* pickupAddress;
@property NSString* pickupContactName;
@property NSString* pickupContactPhone;
@property LocationType* pickupLocationType;

@property NSString* equipmentType;
@property BOOL facilityWithDock;
@property NSString* freightDetails;
@property NSNumber* fuelAdvanceAmount;

@property NSString* hiringCriteria;
@property BOOL isTeamRun;
@property BOOL isTrailerProvided;

@property NSNumber* estimatedCost;
@property BOOL isRecurring;

@property NSString* loadDescription;
@property LoadingType* loadingType;
@property NSNumber* lumperFee;

@property BOOL needBillOfLoading;
@property BOOL ooNeedScaleTickets;
@property BOOL offerFuelAdvance;
@property BOOL payDetentionFee;
@property BOOL payLumperFee;

@property NSDate* runStartDate;
@property NSDate* runEndDate;
@property RunStatus* runStatus;

@property BOOL criminalBackgroundCheckRequired;
@property DeliveryScheduleType* deliveryScheduleType;
@property NSNumber* detentionFee;
@property BOOL driverAssist;

@property NSDate* releasedDate;
@property NSNumber* runDays;
@property NSDate* runDuration;
@property RunFrequency* runFrequency;
@property int runOccurrence;
@property int runStops;
@property BOOL sealOnTrailer;
@property NSString* specialInstructions;
@property BOOL tonuForOO;
@property NSNumber* tonuPenaltyAmount;
@property NSNumber* totalFreightWeight;

@property NSDate* createdDate;
@property NSDate* modifiedDate;

@property NSDictionary* links;

@end

/* Invoice Status */
@interface InvoiceStatus : BBHEntity

@property int invoiceStatusId;
@property NSString* invoiceStatusName;
@property BOOL isDeleted;

@end

/* Invoice */
@interface Invoice : BBHEntity

@property int invoiceId;
@property NSString* invoiceNumber;
@property NSNumber* invoiceAmount;
@property NSNumber* estimatedCost;
@property NSNumber* actualCost;
@property NSDate* invoiceDate;

@property InvoiceStatus* invoiceStatus;

@property NSNumber* approvalBy;
@property NSDate* approvalDate;

@property Client* client;
@property Driver* driver;

@property Run* run;

@end

/* Nav Menu Entry */
@interface NavMenuEntry: NSObject

@property NSString* icon;
@property NSString* label;
@property NSString* actionURL;
@property NSString* actionEntity;
@property NSMutableArray* childItems;
@property BOOL child;
@property BOOL expanded;
@property BOOL leaf;

+ (NSArray*) defaultEntriesForLogin: (NSString*) loginType;
- (instancetype) initWithIcon: (NSString*) icon label: (NSString*) label;
- (instancetype) initWithIcon: (NSString*) icon label: (NSString*) label actionURL: (NSString*) actionURL;
- (instancetype) initWithIcon: (NSString*) icon label: (NSString*) label actionURL: (NSString*) actionURL actionEntity: (NSString*) actionEntity;
- (void) addChildItem: (NavMenuEntry*) chidItem;

@end

@interface Paginate : NSObject

@property NSMutableArray* content;
@property int pageNumber;
@property int pageSize;
@property int pageCount;

@property NSString* nextFetchURL;
@property NSString* prevFetchURL;

@end

@interface BBHSession : NSObject

@property SysUser* curUser;
@property BOOL expired;

+(instancetype) curSession;
-(NSString*) loginType;
-(void) terminate;

@end

#endif
