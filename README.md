# DingDingRobot
工程完整实现text类型、link类型、markdown类型等信息的发送

```
NSError *error;
NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.infoDic options:NSJSONWritingPrettyPrinted error:&error];


NSURL *url = [NSURL URLWithString:kAccessToken];
NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
[req setHTTPMethod:@"POST"];
[req setHTTPBody:jsonData];
[req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
[NSURLConnection connectionWithRequest:req delegate:self];

```
