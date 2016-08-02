//
//  TestViewController.m
//  CKProject
//
//  Created by furui on 15/12/15.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()
@property UILabel *label;

@end

@implementation TestViewController
@synthesize label;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    label=[[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    [label setBackgroundColor:[UIColor greenColor]];
    [label setTextColor:[UIColor blackColor]];
    [self.view addSubview:label];
    [self testHttpPost:@"123" success:^(NSString *result){
            NSLog(@"服务器返回：%@",result);

                } failure:^(NSError *error){
                    NSLog(@"%@", error);
        }];

}
-(void)testHttpPost:(NSString *) key success:(void (^)(NSString *result)) success failure:(void (^)(NSError *error)) failture{
    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=---011000010111000001101001",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"2ab8bc41-b5ae-d88e-12ff-1f26cb8e5395" };
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": @"18502374253"},
                             @{ @"name": @"password", @"value": @"123456"}];
    NSString *boundary = @"---011000010111000001101001";
    
    NSError *error;
    NSMutableString *body = [NSMutableString string];
    for (NSDictionary *param in parameters) {
        [body appendFormat:@"--%@\r\n", boundary];
        if (param[@"fileName"]) {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
            [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
            [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
            if (error) {
                NSLog(@"%@", error);
            }
        } else {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
            [body appendFormat:@"%@", param[@"value"]];
        }
    }
    [body appendFormat:@"\r\n--%@--\r\n", boundary];
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://211.149.198.8:9090/api/login"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        failture(error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:&error];

                                                        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                                                        success(result);

                                                    }
                                                }];
    [dataTask resume];
}

@end