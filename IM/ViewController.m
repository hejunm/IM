//
//  ViewController.m
//  IM
//
//  Created by jmhe on 2018/10/16.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "ViewController.h"
#import "HEIMSDK.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[HEIMSDK sharedInstance] setup];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)connect:(id)sender {
    
}

- (IBAction)desConnect:(id)sender {
    
}

- (IBAction)sender:(id)sender {
    
}

//字典转为Json字符串
- (NSString *)dictionaryToJson:(NSDictionary *)dic{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
