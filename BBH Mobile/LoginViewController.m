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
    [client doPOSTWithURL:@"login" data:params complete:^(RESTResponse response, NSDictionary *data) {
        
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
        }
    }];
}

- (void)success:(NSDictionary *)data {
    
    
}

- (void)failure:(NSDictionary *)detail withMessage:(NSString *)message {
    
    NSLog(@"on error");
    
    [self toggleWait:NO];
    [[self statusLabel] setText: message];
    [detail enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        NSLog(@"%@ -> %@", key, obj);
    }];
}

- (void)progress:(NSNumber *)percent {
    
    NSLog(@"on progress ....");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
