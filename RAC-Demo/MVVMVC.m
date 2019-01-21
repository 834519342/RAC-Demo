//
//  MVVMVC.m
//  RAC-Demo
//
//  Created by xt on 2019/1/18.
//  Copyright © 2019 TJ. All rights reserved.
//

#import "MVVMVC.h"
#import "LoginViewModel.h"

@interface MVVMVC ()

@property (nonatomic, strong) UITextField *account;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UIButton *login;

@property (nonatomic, strong) LoginViewModel *loginVM;

@end

@implementation MVVMVC

- (LoginViewModel *)loginVM
{
    if (!_loginVM) {
        _loginVM = [[LoginViewModel alloc] init];
    }
    return _loginVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.account = [[UITextField alloc] initWithFrame:CGRectMake(30, 200, self.view.bounds.size.width - 60, 40)];
    self.account.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.account];
    
    RAC(self.loginVM, account) = self.account.rac_textSignal;
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(30, 260, self.view.bounds.size.width - 60, 40)];
    self.password.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.password];
    
    RAC(self.loginVM, password) = self.password.rac_textSignal;
    
    self.login = [UIButton buttonWithType:UIButtonTypeSystem];
    self.login.frame = CGRectMake(50, 320, self.view.bounds.size.width - 100, 40);
    [self.login setTitle:@"login" forState:UIControlStateNormal];
    self.login.enabled = NO;
    [self.view addSubview:self.login];
    
    //监听文本框输入状态,确定按钮是否可以点击
    RAC(self.login,enabled) = self.loginVM.btnEnableSignal;
    
    [self.loginVM.loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"登录成功,返回主页");
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [[self.login rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"登录开始");
        [self.loginVM.loginCommand execute:@{@"account":self.account.text, @"password":self.password.text}];
    }];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
