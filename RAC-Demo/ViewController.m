//
//  ViewController.m
//  RAC-Demo
//
//  Created by xt on 2019/1/8.
//  Copyright © 2019 TJ. All rights reserved.
//
/*
 subscriber 美[səb'skraɪbɚ] n. 订户；签署者；捐献者
 disposable 美[dɪ'spozəbl] adj. 可任意处理的；可自由使用的；用完即可丢弃的
 multicast ['mʌltikɑ:st, -kæst] n. 多路广播；多路传送
 connection 英[kəˈnekʃn] n. 连接；关系；连接件
 sequence 美['sikwəns] n. [数][计] 序列；顺序；续发事件
 Tuple 英[tjʊpəl; ˈtʌpəl] n. [计] 元组，重数
 selector 英[sɪ'lektə] n. 选择器；挑选者
 */

#import "ViewController.h"
#import "DelegateVC.h"
#import "MVVMVC.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UITextField *utf1;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;

@property (nonatomic, strong) DelegateVC *delegateVC;

@property (nonatomic, strong) RACDisposable *disposable;

@property (nonatomic, strong) id<RACSubscriber> subscriber;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self RAC_Signal];
//    [self RAC_Disposable];
//    [self RAC_Subject];
//    [self RAC_SignalForSelector];
//    [self RAC_SignalForControlEvents];
//    [self RAC_AddObserverForName];
//    [self RAC_TextSignal];
//    [self RAC_Delegate];
//    [self RAC_Signal_interval_onScheduler];
//    [self RAC_MulticastConnection];
//    [self RAC_Command];
//    [self RAC_bind];
//    [self RAC_Tuple];
//    [self RAC_Sequence];
//    [self RAC_liftSelector];
//    [self RAC_map];
//    [self RAC_flattenMap];
    [self MVVM];

}

/*
 * 1 创建信号
 * 2 订阅信号
 * 3 发送信息
 */
- (void)RAC_Signal
{
    //1.创建信号量
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"创建一个信号量:%@", subscriber);
        //3.发送信息
        [subscriber sendNext:@"发送信息"];
        return nil;
    }];
    //2.订阅信号量
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号量:%@", x);
    }];
}

/*
 * 取消订阅
 */
- (void)RAC_Disposable
{
    //1.创建信号量
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"创建一个信号量:%@", subscriber);
        //3.发送信息
        [subscriber sendNext:@"发送信息"];
        //添加强引用关系
        self.subscriber = subscriber;
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅");
        }];
    }];
    //2.订阅信号量
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号量:%@", x);
    }];
    
    //取消订阅
    [disposable dispose];
}

/**/
- (void)RAC_Subject
{
    //1.创建信号
    RACSubject *subject = [RACSubject subject];
    [subject sendNext:@"订阅之前发送的消息收不到"];
    //2.订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"1 - 订阅信号:%@", x);
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"2 - 订阅信号:%@", x);
    }];
    //3.发送数据
    [subject sendNext:@"发送数据"];
}

/**/
- (void)RAC_ReplaySubject
{
    //1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    //2.发送消息
    [replaySubject sendNext:@"订阅之前发送的消息可以收到"];
    //3.订阅信号
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅信号:%@", x);
    }];
}

/*
 * 监听方法
 */
- (void)RAC_SignalForSelector
{
    //订阅方法
    [[self.view rac_signalForSelector:@selector(method:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"监听方法:%@", x);
    }];
}

- (IBAction)method:(id)sender
{
    NSLog(@"%@", sender);
}

/*
 * 监听按钮
 */
- (void)RAC_SignalForControlEvents
{
    //订阅按钮触发事件
    
    [[self.btn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"监听按钮:%@", x);
        //跳转页面
        [self presentViewController:self.delegateVC animated:YES completion:nil];
    }];
}

/*
 * 监听通知
 */
- (void)RAC_AddObserverForName
{
    //订阅通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"notification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"监听通知:%@", x);
    }];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notification" object:@"通知内容"];
}

/*
 * 监听UITextField
 */
- (void)RAC_TextSignal
{
    //订阅
    [self.utf1.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"监听UITextField:%@", x);
        self.label1.text = x;
    }];
}

/*
 * 代理
 */
- (void)RAC_Delegate
{
    //订阅代理
    [self.delegateVC.rac_delegate subscribeNext:^(id  _Nullable x) {
        NSLog(@"代理回传内容:%@", x);
    }];
}

- (DelegateVC *)delegateVC
{
    if (!_delegateVC) {
        _delegateVC = [[DelegateVC alloc] init];
    }
    return _delegateVC;
}

/*
 * 定时器
 */
- (void)RAC_Signal_interval_onScheduler
{
    [[self.btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        x.enabled = false;
        __block int time = 10;
        //RAC:GCD
        self.disposable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
            time--;
            [self.btn2 setTitle:[NSString stringWithFormat:@"%d", time] forState:UIControlStateNormal];
            self.label1.text = [NSString stringWithFormat:@"%d", time];
            if (time == 0) {
                self.btn2.enabled = true;
                [self.disposable dispose];
            }
        }];
    }];
}

/*
 * 限制订阅次数
 */
- (void)RAC_MulticastConnection
{
    //创建信号量
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发起网络请求
        NSLog(@"发起网络请求");
        //网络请求结束
        [subscriber sendNext:@"返回网络请求数据"];
        
        return nil;
    }];
    
    //避免多次订阅
    RACMulticastConnection *connect = [signal publish];
    //订阅
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"1 - %@", x);
    }];
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"2 - %@", x);
    }];
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"3 - %@", x);
    }];
    [connect connect];
}

/*
 * RACCommand
 */
- (void)RAC_Command
{
    //初始化
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"%@", input);

        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

            [subscriber sendNext:@"发布消息"];
            //发送完成告诉外界
            [subscriber sendCompleted];

            return nil;
        }];
    }];
    
    //1.获取信号量再订阅
//    RACSignal *signal = [command execute:@"发送指令"];
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"接收数据 - %@", x);
//    }];
    
    //2.获取信号量,注意要在execute方法之前实现,否则无效
//    [command.executionSignals subscribeNext:^(id  _Nullable x) {
//        NSLog(@"信号源 - %@", x);
//        //订阅
//        [x subscribeNext:^(id  _Nullable x) {
//            NSLog(@"接收数据 - %@", x);
//        }];
//    }];
//    [command execute:@"发送指令"];
    
    //3.获取最新的信号量,对其进行订阅,switchToLatest下面有测试案例
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收数据 - %@", x);
    }];
//    [command execute:@"发送指令"];
    
    //判断当前block是否在执行,执行完之后会返回@(NO),skip表示跳过判断次数
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        NSLog(@"%@", x);
        if ([x boolValue]) {
            NSLog(@"还在执行");
        }else {
            NSLog(@"执行结束了");
        }
    }];
    [command execute:@"999999"];
    
//    [self switch_To_Latest];
}
/*
 * switchToLatest 获取最新的信号量
 */
- (void)switch_To_Latest
{
    //创建多个信号量
    RACSubject *subjectOfsignal = [RACSubject subject];
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    RACSubject *subject3 = [RACSubject subject];
    RACSubject *subject4 = [RACSubject subject];
    
    //订阅所有的信号量
    [subjectOfsignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"信号量:%@", x);
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"消息:%@", x);
        }];
    }];
    
    //订阅最新的信号量
    [subjectOfsignal.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"最新的信号量消息:%@", x);
    }];
    
    //发送消息
    [subjectOfsignal sendNext:subject1];
    [subjectOfsignal sendNext:subject2];
    [subjectOfsignal sendNext:subject3];
    [subjectOfsignal sendNext:subject4];
    [subject1 sendNext:@"1"];
    [subject2 sendNext:@"2"];
    [subject3 sendNext:@"3"];
    [subject4 sendNext:@"4"];
}

/*
 * bind
 */
- (void)RAC_bind
{
    RACSubject *subject = [RACSubject subject];
    
    RACSignal *signal = [subject bind:^RACSignalBindBlock _Nonnull{
        return ^RACSignal *(id _Nullable value, BOOL *stop){
            return [RACReturnSignal return:value];
        };
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"收到的数据 - %@", x);
    }];
    
//    [subject subscribeNext:^(id  _Nullable x) {
//        NSLog(@"收到的数据 - %@", x);
//    }];
    
    [subject sendNext:@"启动自毁程序"];
}

/*
 * RACTuple 元组
 */
- (void)RAC_Tuple
{
    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"大吉大利", @"今晚吃鸡", @66666, @99999] convertNullsToNils:YES];
    
    id value = tuple[0];
    id value2 = tuple.last;
    
    NSLog(@"%@,%@", value, value2);
}

/*
 * RACSequence 遍历
 */
- (void)RAC_Sequence
{
    //数组使用
    NSArray *array = @[@"大吉大利", @"今晚吃鸡", @66666, @99999];
    //基础版 遍历
//    RACSequence *sequence = array.rac_sequence;
//    RACSignal *signal = sequence.signal;
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    }];
    //高级版 遍历
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    //字典使用
    NSDictionary *dict = @{@"大吉大利":@"今晚吃鸡",
                           @"666666":@"9999999",
                           @"dddddd":@"aaaaaa"
                           };
    //低配版遍历
//    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"key = %@,value = %@", x[0], x[1]);
//    }];
    //高级版遍历
    [dict.rac_sequence.signal subscribeNext:^(RACTuple * _Nullable x) {
        RACTupleUnpack(NSString *key, id value) = x;
        NSLog(@"key - %@ value - %@", key, value);
    }];
}

/*
 * 等所有的请求完成了一起处理的场景
 * block在主线程,耗时操作放在异步线程,刷新UI操作放在主线程
 */
- (void)RAC_liftSelector
{
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:3];
            [subscriber sendNext:[NSString stringWithFormat:@"图片1:%@", [NSThread currentThread]]];
        });
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:1];
            [subscriber sendNext:[NSString stringWithFormat:@"图片2:%@", [NSThread currentThread]]];
        });
        return nil;
    }];
    
    RACSignal *signal3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:2];
            [subscriber sendNext:[NSString stringWithFormat:@"图片3:%@", [NSThread currentThread]]];
        });
        return nil;
    }];
    
    [self rac_liftSelector:@selector(updateUIWithPic:pic2:pic3:) withSignalsFromArray:@[signal1,signal2,signal3]];
}

- (void)updateUIWithPic:(id)pic1 pic2:(id)pic2 pic3:(id)pic3
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"开始加载UI:\n pic1 - %@,\n pic2 - %@,\n pic3 - %@", pic1, pic2, pic3);
    });
}

/*
 * map
 */
- (void)RAC_map
{
    RACSubject *subject = [RACSubject subject];
    
    [[subject map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"收到的信息:%@", value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [subject sendNext:@"消息"];
}

/*
 * flattenMap 处理信号中的信号
 */
- (void)RAC_flattenMap
{
    RACSubject *subjectOfSignal = [RACSubject subject];
    RACSubject *subject = [RACSubject subject];
    
    [[subjectOfSignal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [subjectOfSignal sendNext:subject];
    [subject sendNext:@"弄啥嘞"];
}

/*
 * RAC的MVVM模式
 */
- (void)MVVM
{
    [[self.btn3 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"跳转到MVVM页面");
        [self presentViewController:[MVVMVC new] animated:YES completion:nil];
    }];
}

@end
