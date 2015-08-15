//
//  LoginViewController.m
//  Pipio
//
//  Created by Aditya Keerthi on 2015-08-15.
//  Copyright (c) 2015 Aditya Keerthi. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "Masonry.h"
#import "HomeViewController.h"
#import "DataStore.h"

@interface LoginViewController ()
{
    UITextField *usernameField;
    UITextField *passwordField;
    
    UILabel *appName;
}
@end

@implementation LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xAED3F2);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    appName = [[UILabel alloc] init];
    appName.text = @"Pipio";
    appName.textColor = UIColorFromRGB(0xA68114);
    appName.textAlignment = NSTextAlignmentCenter;
    [appName setFont:[UIFont fontWithName:@"Arial-BoldMT" size:30]];
    
    [self.view addSubview:appName];
    
    usernameField = [[UITextField alloc] init];
    usernameField.placeholder = @"Username";
    usernameField.textColor = [UIColor blackColor];
    usernameField.backgroundColor = [UIColor whiteColor];
    usernameField.delegate = self;
    [usernameField setFont:[UIFont fontWithName:@"Arial" size:25]];
    usernameField.tag = 1;
    usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:usernameField];
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [usernameField setLeftViewMode:UITextFieldViewModeAlways];
    [usernameField setLeftView:spacerView];
    
    passwordField = [[UITextField alloc] init];
    passwordField.placeholder = @"Password";
    passwordField.textColor = [UIColor blackColor];
    passwordField.backgroundColor = [UIColor whiteColor];
    passwordField.delegate = self;
    [passwordField setFont:[UIFont fontWithName:@"Arial" size:25]];
    passwordField.tag = 2;
    passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordField.secureTextEntry = YES;
    [self.view addSubview:passwordField];
    
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [passwordField setLeftViewMode:UITextFieldViewModeAlways];
    [passwordField setLeftView:spacerView2];
}

- (void)viewDidLayoutSubviews{
    [usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view.mas_height).multipliedBy(0.1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_centerY);
    }];
    
    [passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view.mas_height).multipliedBy(0.1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_centerY);
    }];
    
    [appName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(150);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == passwordField && ![passwordField.text isEqualToString:@""] && ![usernameField.text isEqualToString:@""]) {
        [self.navigationController pushViewController:[[HomeViewController alloc] initWithUsername:[@"@" stringByAppendingString:usernameField.text]] animated:YES];
    }
    return YES;
}

@end
