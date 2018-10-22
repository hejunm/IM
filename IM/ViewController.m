//
//  ViewController.m
//  IM
//
//  Created by jmhe on 2018/10/16.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "ViewController.h"
#import "HESocketHandler.h"

@interface ViewController ()
@property(nonatomic,weak)HESocketHandler *socketHandler;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.socketHandler = [HESocketHandler shareInstance];
    [self.socketHandler setHost:@"192.168.0.100" port:6969];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)connect:(id)sender {
    [self.socketHandler connectWithTimeout:-1 error:nil];
}

- (IBAction)desConnect:(id)sender {
    [self.socketHandler disconnect];
}

- (IBAction)sender:(id)sender {
    NSString *str = self.contentTextField.text;
    NSData *data  = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger size = data.length;
    NSMutableDictionary *headDic = [NSMutableDictionary dictionary];
    [headDic setObject:@"txt" forKey:@"type"];
    [headDic setObject:[NSString stringWithFormat:@"%ld",size] forKey:@"size"];
    NSString *jsonStr = [self dictionaryToJson:headDic];
    NSData *lengthData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mData = [NSMutableData dataWithData:lengthData];
    //分界
    [mData appendData:[NSData dataWithBytes:"\x0D\x0A" length:2]];
    [mData appendData:data];
    [self.socketHandler writeData:mData];
}

//字典转为Json字符串
- (NSString *)dictionaryToJson:(NSDictionary *)dic{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
