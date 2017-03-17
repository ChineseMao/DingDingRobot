//
//  markdownViewController.m
//  robot
//
//  Created by 毛韶谦 on 2017/3/17.
//  Copyright © 2017年 毛韶谦. All rights reserved.
//

#import "markdownViewController.h"

@interface markdownViewController ()

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) NSMutableDictionary *infoDic;

@end

@implementation markdownViewController

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

- (IBAction)sendMessageAction:(id)sender {
    
    if ([self isJustTure]) {
        return;
    }
    NSMutableDictionary *contentDic = [[NSMutableDictionary alloc] init];
    [contentDic setObject:self.contentTextView.text forKey:@"text"];
    [contentDic setObject:self.titleTextField.text forKey:@"title"];
    [self.infoDic setObject:@"markdown" forKey:@"msgtype"];
    [self.infoDic setObject:contentDic forKey:@"markdown"];
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
- (IBAction)tapGestureAction:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)explainButton:(id)sender {
    [self.view endEditing:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"说明" message:@"标题\n# 一级标题\n## 二级标题\n### 三级标题\n#### 四级标题\n##### 五级标题\n###### 六级标题\n\n引用\n> A man who stands for nothing will fall for anything.\n文字加粗、斜体\n**bold**\n*italic*\n链接\n[this is a link](http://name.com)\n图片\n![](http://name.com/pic.jpg)\n无序列表\n- item1\n- item2\n有序列表\n1. item1\n2. item2" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alertView show];
    
}

- (BOOL)isJustTure {
    
    UIAlertView *alertView;
    
    if (!self.titleTextField.text.length) {
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"标题不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }else if (!self.contentTextView.text.length) {
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
    }else {
        
    }
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
