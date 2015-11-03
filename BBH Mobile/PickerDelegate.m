//
//  PickerDelegate.m
//  BBH Mobile
//
//  Created by Mac-Mini on 10/14/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PickerDelegate.h"

@implementation PickerDelegate

-(instancetype)init {
    
    self = [super init];
    
    if(self) {
        
        [self setContent:[NSMutableArray array]];
        
        /*NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setValue:[NSNumber numberWithInt:2] forKey:@"DriverTypeId"];
        [dict setValue:@"FooBlah" forKey:@"DriverTypeName"];
        
        [[self content] addObject:[[DriverType alloc] initWithDict:dict]];
        
        dict = [NSMutableDictionary dictionary];
        [dict setValue:[NSNumber numberWithInt:3] forKey:@"DriverTypeId"];
        [dict setValue:@"FooBar" forKey:@"DriverTypeName"];
        
        [[self content] addObject:[[DriverType alloc] initWithDict:dict]];*/
    }
    
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [[self content] count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    id type = [[self content] objectAtIndex:row];
    return [type description];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //NSLog(@">> PICKER SELECT; %@", [[self content] objectAtIndex:[pickerView selectedRowInComponent:0]]);
    if([self onSelect]) {
        
        [self onSelect]();
    }
}

/*-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 21.0;
}*/

@end