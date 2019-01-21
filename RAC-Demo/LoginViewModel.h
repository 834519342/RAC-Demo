//
//  LoginViewModel.h
//  RAC-Demo
//
//  Created by xt on 2019/1/21.
//  Copyright © 2019 TJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
#import "RACReturnSignal.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewModel : NSObject

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) RACSignal *btnEnableSignal;

@property (nonatomic, strong) RACCommand *loginCommand;

@end

NS_ASSUME_NONNULL_END
