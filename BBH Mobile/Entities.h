//
//  SysUser.h
//  BBH Mobile
//
//  Created by Mac-Mini on 9/25/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "Foundation/Foundation.h"
#import "UIKit/uikit.h"

#ifndef BBH_Mobile_SysUser_h
#define BBH_Mobile_SysUser_h

/* Role Type */
@interface RoleType : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int roleTypeId;
@property NSString* roleTypeName;

@end

/* Role */
@interface Role : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int roleId;
@property NSString* roleName;
@property RoleType* roleType;

@end

/* Sys User */
@interface SysUser: NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

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
@interface Client: NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int clientId;
@property NSString* clientName;
@property NSString* email;

@end

/* Driver Class */
@interface DriverClass: NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int driverClassId;
@property NSString* driverClassName;

@end

/* Driver Type */
@interface DriverType : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int driverTypeId;
@property NSString* driverTypeName;

@end

/* Address Type */

@interface AddressType: NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int addressTypeId;
@property NSString* addressTypeName;

@end

/* Country */
@interface Country : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int countryId;
@property NSString* countryName;

@end

/* Address */
@interface Address : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

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
@interface Link : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property NSString* href;
@property NSString* method;
@property NSString* rel;

@end

/* Run Status */
@interface RunStatus : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int runStatusId;
@property NSString* runStatusName;

@end

/* Delivery Schedule Type */
@interface DeliveryScheduleType : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int deliveryScheduleTypeId;
@property NSString* deliveryScheduleTypeName;

@end

/* Location Type */
@interface LocationType : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int locationTypeId;
@property NSString* locationTypeName;

@end

/* Equipment Type */
@interface EquipmentType : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int equipmentTypeId;
@property NSString* equipmentTypeName;

@end

/* Loading Type */
@interface LoadingType : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int loadingTypeId;
@property NSString* loadingTypeName;

@end

/* Run Frequency */
@interface RunFrequency : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int runFrequencyId;
@property NSString* runFrequencyName;

@end

/* Payment Method */
@interface PaymentMethod : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int paymentMethodId;
@property NSString* paymentMethodName;

@end

/* Experience Type */
@interface ExperienceType : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int experienceTypeId;
@property NSString* experienceTypeName;
@property BOOL isDeleted;

@end


/* Equipment Skill */
@interface EquipmentSkill: NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int equipmentSkillId;
@property NSString* equipmentSkillName;
@property ExperienceType* experienceType;
@property BOOL isDeleted;

@end

/* Experience Slot */
@interface ExperienceSlot : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int experienceSlotId;
@property NSString* experienceSlotName;
@property BOOL isDeleted;
@property int sequence;

@end

/* RunEquipmentSkill */
@interface RunEquipmentSkill : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int runEquipmentSkillId;
@property EquipmentSkill* equipmentSkill;
@property ExperienceSlot* experienceSlot;
@property BOOL isDeleted;
@property NSDate* modifiedDate;

@end

/* Run Payment Method */
@interface RunPaymentMethod : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int runPaymentMethodId;
@property PaymentMethod* paymentMethod;
@property NSNumber* estimatedRate;
@property NSNumber* estimatedUnits;
@property BOOL isDeleted;
@property NSDate* modifiedDate;

@end

/* Time Card Status */
@interface TimeCardStatus : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int timeCardStatusId;
@property NSString* timeCardStatusName;
@property BOOL isDeleted;

@end

/* Driver */
@interface Driver : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int driverId;
@property NSString* email;
@property NSString* firstName;
@property NSString* lastName;

-(NSString*) fullName;

@end

/* Time Card */
@interface TimeCard: NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int timeCardId;
@property NSNumber* invoiceId;
@property NSDate* timeCardDate;
@property TimeCardStatus* timeCardStatus;
@property Driver* driver;
@property NSNumber* actualCost;
@property SysUser* approvalBy;
@property NSString* approvalComment;
@property NSDate* approvalDate;

@end

/* Run Release */
@interface RunRelease : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

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
@interface RunDriver : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int runDriverId;
@property Driver* driver;
@property BOOL isConfirmed;
@property BOOL isCancelledByDriver;
@property NSDate* driverAcceptedDate;
@property NSDate* driverConfirmationReceivedDate;
@property NSDate* cancellationReceivedDate;

@end

/* Run */
@interface Run : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

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

@property EquipmentType* equipmentType;
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
@interface InvoiceStatus : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

@property int invoiceStatusId;
@property NSString* invoiceStatusName;
@property BOOL isDeleted;

@end

/* Invoice */
@interface Invoice : NSObject

- (instancetype) initWithDict: (NSDictionary*)dict;

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

@interface BBHUtil : NSObject

+(NSDateFormatter*) dateScan;
+(NSDateFormatter*) dateFormat;
+(CGSize) statusBarSize;
+(CGFloat) statusBarHeight;
+(BOOL) isNull: (id) obj;
+(UIColor*) headerTextColor;

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
