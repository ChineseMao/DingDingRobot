//
//  ViewController.m
//  robot
//
//  Created by 毛韶谦 on 2017/3/16.
//  Copyright © 2017年 毛韶谦. All rights reserved.
//https://oapi.dingtalk.com/robot/send?access_token=0a2e90e0eac361c90c56d257ee0b5e6c66a2e585ba05972c87006b072fe79436

#import "ViewController.h"
#import "complexViewController.h"
#import "markdownViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *switchAllPeople;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic, strong) NSMutableDictionary *infoDic;

@end

@implementation ViewController

- (NSMutableDictionary *)infoDic {
    
    if (!_infoDic) {
        _infoDic = [[NSMutableDictionary alloc] init];
    }
    return _infoDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)sendMessage:(id)sender {
    
    
#if 0
    // 1.设置请求路径
    NSURL *URL=[NSURL URLWithString:kAccessToken];//不需要传递参数
    
    //    2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //设置请求体
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] init];
    [contentDic setObject:[NSString stringWithFormat:@"%@",self.contentTextView.text] forKey:@"content"];
    
    [self.infoDic setObject:@"text" forKey:@"msgtype"];
    [self.infoDic setObject:contentDic forKey:@"text"];
    if (self.switchAllPeople.on) {
        [self.infoDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"true",@"isAtAll", nil] forKey:@"at"];
    }else {
        [self.infoDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"false",@"isAtAll", nil] forKey:@"at"];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.infoDic options:NSJSONWritingPrettyPrinted error:&error];
    //把拼接后的字符串转换为data，设置请求体
    request.HTTPBody=jsonData;
    
    //第三步，连接服务器
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        NSLog(@"error = %@  \n 返回信息 = %@",error,str1);
#endif
    
    
#if 1
    
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] init];
    [contentDic setObject:[NSString stringWithFormat:@"%@",self.contentTextView.text] forKey:@"content"];
    [self.infoDic setObject:@"text" forKey:@"msgtype"];
    [self.infoDic setObject:contentDic forKey:@"text"];
    if (self.switchAllPeople.on) {
        [self.infoDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"true",@"isAtAll", nil] forKey:@"at"];
    }else {
        [self.infoDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"false",@"isAtAll", nil] forKey:@"at"];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.infoDic options:NSJSONWritingPrettyPrinted error:&error];

    
    NSURL *url = [NSURL URLWithString:kAccessToken];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection connectionWithRequest:req delegate:self];
    
#endif
}

- (IBAction)tapGestureAction:(id)sender {
    
    [self.view endEditing:YES];
}

- (IBAction)senderAllPeople:(id)sender {
    
    UISwitch *switchSender = sender;

    if (switchSender.on) {
        [self.infoDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"true",@"isAtAll", nil] forKey:@"at"];
    }else {
        [self.infoDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"false",@"isAtAll", nil] forKey:@"at"];
    }
    
}

//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"将要开始返回数据");
}
//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"开始返回数据片段");
}

//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self showAlertView:YES];
}
//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error
{
    [self showAlertView:NO];
    NSLog(@"%@",[error localizedDescription]);
}

- (void)showAlertView:(BOOL)isSuccess {
    
    UIAlertView *alertView;
    if (isSuccess) {
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息发送成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }else {
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息发送失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView.message isEqualToString:@"信息发送成功"]) {
        [self.switchAllPeople setOn:NO animated:YES];
        [self.contentTextView setText:@""];
    }else {
        
    }
}

- (IBAction)chooseAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择" message:@"选择一个需要模式控制器" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *linkAction = [UIAlertAction actionWithTitle:@"link模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        complexViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"complexViewController"];
         [self.navigationController pushViewController:vc animated:YES];
    }];//在代码块中可以填写具体这个按钮执行的操作
    UIAlertAction *markdownAction = [UIAlertAction actionWithTitle:@"markdown模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        markdownViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"markdownViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [alertController addAction:linkAction];
    [alertController addAction:markdownAction];//代码块前的括号是代码块返回的数据类型
    [self presentViewController: alertController animated:YES completion:nil];
}

- (void)clickPush {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
