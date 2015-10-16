//
//  PickerDelegate.h
//  BBH Mobile
//
//  Created by Mac-Mini on 10/14/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entities.h"

#ifndef BBH_Mobile_PickerDelegate_h
#define BBH_Mobile_PickerDelegate_h

@interface PickerDelegate : NSObject<UIPickerViewDelegate, UIPickerViewDataSource>

@property NSMutableArray* content;
@property id selected;
@property (copy) void(^onSelect)(void);

@end

#endif
