//
//  ViewController.m
//  BBH Mobile
//
//  Created by Mac-Mini on 9/9/15.
//  Copyright (c) 2015 Mac-Mini. All rights reserved.
//

#import "LoginViewController.h"
#include "Entities.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self toggleWait:NO];
}

- (void)updateViewConstraints {
    
    UIFont* txtFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    //UIFont* stsFont = [UIFont systemFontOfSize:[UIFont systemFontSize]*0.9];
    UIFont* hdrFont = [UIFont systemFontOfSize:[UIFont systemFontSize]*1.2];
    
    [[self headerLabel] setFont:hdrFont];
    [[self statusLabel] setFont:txtFont];
    [[self userTF] setFont:txtFont];
    [[self passwordTF] setFont:txtFont];
    
    [[self headerLabel] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self view].mas_top).with.offset([[self view] frame].size.height/4.0);
        make.centerX.equalTo([self view].mas_centerX);
        
        CGSize size = [[[self headerLabel] text] sizeWithAttributes:@{NSFontAttributeName:[[self headerLabel] font]}];
        
        //NSLog(@">> Width: %.2f", [[self view] frame].size.width - size.width);
        make.width.mas_equalTo(size.width + 100.0);
        make.height.mas_equalTo(size.height + 10);
    }];
    
    [[self statusLabel] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self headerLabel].mas_bottom).with.offset(10.0);
        make.centerX.equalTo([self view].mas_centerX);
        
        //NSLog(@">> Width: %.2f", [[self view] frame].size.width - size.width);
        //make.width.mas_equalTo(size.width + 100.0);
    }];
    
    [[self userTF] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self statusLabel].mas_bottom).with.offset(10.0);
        make.width.equalTo([self headerLabel].mas_width).multipliedBy(0.80);
        make.centerX.equalTo([self view].mas_centerX);
    }];
    
    [[self passwordTF] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self userTF].mas_bottom).with.offset(10.0);
        make.width.equalTo([self headerLabel].mas_width).multipliedBy(0.80);
        make.centerX.equalTo([self view].mas_centerX);
    }];
    
    [[self loginBtn] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo([self passwordTF].mas_bottom).with.offset(20.0);
        make.centerX.equalTo([self view].mas_centerX);
    }];
    
    [[self loadingIndicator] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo([self loginBtn].mas_centerY);
        make.left.equalTo([self loginBtn].mas_right).with.offset(10.0);
    }];
    
    [super updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[self userTF] setText:@""];
    [[self passwordTF] setText:@""];
}

- (void) toggleWait: (BOOL) show {
    
    if(show) {
        
        [[self loadingIndicator] startAnimating];
        [[self loadingIndicator] setHidden:NO];
        [[self loginBtn] setEnabled:NO];
        
    } else {
        
        [[self statusLabel] setText: @""];
        [[self loadingIndicator] stopAnimating];
        [[self loadingIndicator] setHidden:YES];
        [[self loginBtn] setEnabled:YES];
    }
}

-(void)unwindToLoginScreen:(UIStoryboardSegue *)sender {
 
    NSLog(@">> LOGOUT");
}

- (IBAction)loginTapped:(id)sender {
    
    NSLog(@"Tapped !");
    
    if([[[[self userTF] text] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] length] == 0 || [[[[self passwordTF] text] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] length] == 0) {
        
        [[self statusLabel] setText:@"Username and password are required"];
        return;
    }
    
    RESTClient* client = [RESTClient instance];
    RESTParams* params = [[RESTParams alloc] init];
    
    [self toggleWait:true];
    [client setCredentialsWithUser:[[self userTF] text] password:[[self passwordTF] text]];
    [client doPOSTWithURL:@"login" params:params complete:^(RESTResponse response, NSDictionary *data) {
        
        if(response == RESTResponseSuccess) {
            
            NSLog(@"on success");
            
            [self toggleWait:NO];
            [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
                NSLog(@"%@ -> %@", key, obj);
            }];
            
            NSDictionary* headers = [data valueForKey:@"headers"];
            NSString* accessToken = [headers valueForKey:@"token"];
            
            SysUser* user = [[SysUser alloc] initWithDict:data];
            [[BBHSession curSession] setCurUser:user];
            
            [[RESTClient instance] setAccessToken:accessToken];
            
            UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Navigation" bundle:[NSBundle mainBundle]];
            NavigationViewController* runVC = [sb instantiateInitialViewController];
            
            //[self setModalPresentationStyle:UIModalPresentationCurrentContext];
            
            [self presentViewController:runVC animated:YES completion:^{
                [runVC loadView];
            }];
            
            NSLog(@" >> Seague performed ");
            
        } else if(response == RESTResponseError) {
            
            NSLog(@"on error");
            
            [self toggleWait:NO];
            [[self statusLabel] setText: [data valueForKey:@"message"]];
            [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
                NSLog(@"%@ -> %@", key, obj);
            }];
        }
    }];
}

- (void)success:(NSDictionary *)data {
    
    
}

- (void)failure:(NSDictionary *)detail withMessage:(NSString *)message {
    
    
}

- (void)progress:(NSNumber *)percent {
    
    NSLog(@"on progress ....");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
