//
//  DelegateVC.h
//  RAC-Demo
//
//  Created by xt on 2019/1/9.
//  Copyright © 2019 TJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface DelegateVC : UIViewController

@property (nonatomic, strong) RACSubject *rac_delegate;

@end

NS_ASSUME_NONNULL_END
