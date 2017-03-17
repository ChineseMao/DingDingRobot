//
//  complexViewController.m
//  robot
//
//  Created by 毛韶谦 on 2017/3/17.
//  Copyright © 2017年 毛韶谦. All rights reserved.
//

#import "complexViewController.h"

@interface complexViewController ()<UIAlertViewDelegate,NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;
@property (strong, nonatomic) IBOutlet UITextField *imageTextField;
@property (strong, nonatomic) NSMutableDictionary *infoDic;

@end

@implementation complexViewController

- (NSMutableDictionary *)infoDic {
    
    if (!_infoDic) {
        _infoDic = [[NSMutableDictionary alloc] init];
    }
    return _infoDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)sendButtonAction:(id)sender {
    
    if ([self isJustTure]) {
        return;
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] init];
    [contentDic setObject:self.contentTextView.text forKey:@"text"];
    [contentDic setObject:self.titleTextField.text forKey:@"title"];
    [contentDic setObject:self.imageTextField.text forKey:@"picUrl"];
    [contentDic setObject:self.urlTextField.text forKey:@"messageUrl"];
    
    [self.infoDic setObject:@"link" forKey:@"msgtype"];
    [self.infoDic setObject:contentDic forKey:@"link"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.infoDic options:NSJSONWritingPrettyPrinted error:&error];
    
    
    NSURL *url = [NSURL URLWithString:kAccessToken];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection connectionWithRequest:req delegate:self];
    

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

- (BOOL)isJustTure {
    
    UIAlertView *alertView;
    
    if (!self.titleTextField.text.length) {
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"标题不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }else if (!self.contentTextView.text.length) {
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }else if (!self.urlTextField.text.length) {
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网址不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }else if (!self.imageTextField.text.length) {
        return NO;
    }else {
        return NO;
    }
    [alertView show];
    return YES;
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
        [self.contentTextView setText:@""];
        [self.titleTextField setText:@""];
        [self.urlTextField setText:@""];
        [self.imageTextField setText:@""];
    }else {
        
    }
}


- (IBAction)tapGestureAction:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
