//
//  DelegateVC.m
//  RAC-Demo
//
//  Created by xt on 2019/1/9.
//  Copyright © 2019 TJ. All rights reserved.
//

#import "DelegateVC.h"

@interface DelegateVC ()

@end

@implementation DelegateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //代替代理传值
        [self.rac_delegate sendNext:@{@"key1":@"代理回传的值",@"key2":@"另一个值"}];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (RACSubject *)rac_delegate
{
    if (!_rac_delegate) {
        _rac_delegate = [RACSubject subject];
    }
    return _rac_delegate;
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
