//
//  AFNetworkTool.m
//  AFNetText2.5
//
//  Created by wxxu on 15/1/27.
//  Copyright (c) 2015年 wxxu. All rights reserved.
//

#import "AFNetworkTool.h"
#import "DataHander.h"
#import "Eleven_Header.h"

@implementation AFNetworkTool

#define URL @""
//菊花
+ (void)showHUDGood:(BOOL)showHUD
{
    if (showHUD)
    {
        [[DataHander sharedDataHander] showDlg];
    }
}

#pragma mark 检测网路状态
+ (void)netWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //        NSLog(@"%d", status);
    }];
}

#pragma mark - JSON方式获取数据
+ (void)Eleven_GET_JSONDataWithUrl:(NSString *)urlStr
                            Params:(NSDictionary*)params
                           success:(void (^)(id json))success
                              fail:(void (^)())fail;
{
    //加 菊花加载动画
    [self showHUDGood:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"application/html",nil];//设置相应内容类型
    NSString* url = [NSString stringWithFormat:@"%@%@",URL,urlStr];
    NSLog(@"param == %@",params);
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            //去掉 菊花加载动画
            [[DataHander sharedDataHander] hideDlg];
            
            success(responseObject);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            //去掉 菊花加载动画
            [[DataHander sharedDataHander] hideDlg];
            fail();
        }
    }];
}

#pragma mark - xml方式获取数据
+ (void)Eleven_GET_XMLDataWithUrl:(NSString *)urlStr
                          success:(void (^)(id xml))success
                             fail:(void (^)())fail;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 返回的数据格式是XML
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20;
    NSString* url = [NSString stringWithFormat:@"%@%@",URL,urlStr];
    
    NSDictionary *dict = @{@"format": @"xml"};
    
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail();
        }
    }];
}

//检查网络连接
+(void)wifi
{
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable)
        {
            UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"无网络连接" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [al show];
        }
    }];
}

#pragma mark - JSON方式post提交数据
+ (void)Eleven_Post_JSONWithUrl:(NSString *)urlStr
                     parameters:(NSDictionary*)parameters
                        success:(void (^)(id responseObject))success
                           fail:(void (^)())fail
{
    
    
    //加 菊花加载动画
    [self showHUDGood:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20;
    NSString* url = [NSString stringWithFormat:@"%@%@",URL,urlStr];
    NSLog(@"url = %@",url);
    NSLog(@"parames = %@",parameters);
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            //去掉 菊花加载动画
            [[DataHander sharedDataHander] hideDlg];
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误 %@", error.localizedDescription);
        if (fail) {
            
            
            
            //去掉 菊花加载动画
            [[DataHander sharedDataHander] hideDlg];
            fail();
        }
    }];
    
}

#pragma mark - Session 下载下载文件
+ (void)Eleven_Session_DownloadWithUrl:(NSString *)urlStr
                               success:(void (^)(NSURL *fileURL))success
                                  fail:(void (^)())fail
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSString* url_file = [NSString stringWithFormat:@"%@%@",URL,urlStr];
    NSString *urlString = [url_file stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        //        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
        //        NSURL *fileURL1 = [NSURL URLWithString:path];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        
        //        NSLog(@"== %@ |||| %@", fileURL1, fileURL);
        if (success) {
            success(fileURL);
        }
        
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@ %@", filePath, error);
        if (fail) {
            fail();
        }
    }];
    
    [task resume];
}


#pragma mark - 文件上传 自己定义文件名
+ (void)Eleven_Post_UploadWithUrl:(NSString *)urlStr
                           Params:(NSDictionary*)params
                          fileUrl:(NSURL *)fileURL
                         fileName:(NSString *)fileName
                         fileType:(NSString *)fileTye
                          success:(void (^)(id responseObject))success
                             fail:(void (^)())fail
{
    // 本地上传给服务器时,没有确定的URL,不好用MD5的方式处理
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString* url = [NSString stringWithFormat:@"%@%@",URL,urlStr];
    //@"http://localhost/demo/upload.php"
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        // 要上传保存在服务器中的名称
        // 使用时间来作为文件名 2014-04-30 14:20:57.png
        // 让不同的用户信息,保存在不同目录中
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        // 设置日期格式
        //        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        //        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        
        //@"image/png"
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" fileName:fileName mimeType:fileTye error:NULL];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail();
        }
    }];
}

#pragma mark - POST上传图片
+ (void)Eleven_Post_UploadWithUrl:(NSString *)urlStr
                           Params:(NSDictionary*)params
                Idcard_front_Data:(NSData *)idcard_front_data
                          success:(void (^)(id responseObject))success
                             fail:(void (^)())fail
{
    //加 菊花加载动画
    [self showHUDGood:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString* url = [NSString stringWithFormat:@"%@%@",URL,urlStr];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString * str_time = [formatter stringFromDate:[NSDate date]];
        
        NSString * str_name = [NSString stringWithFormat:@"%@.jpg",str_time];
        
        //name 为服务器规定的图片字段 mimeType 为图片类型
        [formData appendPartWithFileData:idcard_front_data name:@"image" fileName:str_name mimeType:@"image/jpg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            //去掉 菊花加载动画
            [[DataHander sharedDataHander] hideDlg];
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误 %@", error.localizedDescription);
        if (fail) {
            //去掉 菊花加载动画
            [[DataHander sharedDataHander] hideDlg];
            fail();
        }
    }];
}

#pragma mark - POST上传文件
+ (void)Eleven_Post_UploadWithUrl:(NSString *)urlStr
                           Params:(NSDictionary*)params
                Idcard_front_Data:(NSData*)idcard_front_data
                 Idcard_back_Data:(NSData*)idcard_back_data
            Idcard_front_fileName:(NSString*)idcard_front_file_name
             Idcard_back_fileName:(NSString*)idcard_back_fileName
                          success:(void (^)(id responseObject))success
                             fail:(void (^)())fail
{
    //加 菊花加载动画
    [self showHUDGood:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString* url = [NSString stringWithFormat:@"%@%@",URL,urlStr];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //name 为服务器规定的图片字段 mimeType 为图片类型
        [formData appendPartWithFileData:idcard_front_data name:@"idcard_front" fileName:idcard_front_file_name mimeType:@"image/png"];
        [formData appendPartWithFileData:idcard_back_data name:@"idcard_back" fileName:idcard_back_fileName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            //去掉 菊花加载动画
            [[DataHander sharedDataHander] hideDlg];
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误 %@", error.localizedDescription);
        if (fail) {
            //去掉 菊花加载动画
            [[DataHander sharedDataHander] hideDlg];
            fail();
        }
    }];
}

/**
 *文件上传,文件名由服务器端决定 适合传多张图片
 *urlStr:    需要上传的服务器url
 *Idcard_front_Data:   需要上传的本地文件data
 *Idcard_front_fileName:  需要上传文件名以及扩展名
 */
+ (void)Eleven_Post_UploadWithUrl:(NSString*)urlStr
                           Params:(NSDictionary*)params
                         Data_arr:(NSArray*)data_arr
                          success:(void (^)(id responseObject))success
                             fail:(void (^)())fail
{
    
    [self showHUDGood:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString* url = [NSString stringWithFormat:@"%@%@",URL,urlStr];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < data_arr.count; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone systemTimeZone]];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString* dateString = [formatter stringFromDate:[NSDate date]];
            dateString = [NSString stringWithFormat:@"%@_%ld.png",dateString,data_arr.count + 1];
            
            NSData* data = [NSData data];
            data = [data_arr objectAtIndex:i];
            NSString  *path = NSHomeDirectory();
            NSLog(@"path:%@",path);
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:dateString];
            
            [data writeToFile:fullPathToFile atomically:NO];
            NSString* name = [NSString stringWithFormat:@"file_%d",i + 1];
            
            [formData appendPartWithFileData:data name:name fileName:dateString mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            //去掉 菊花加载动画
            [[DataHander sharedDataHander] hideDlg];
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误 %@", error.localizedDescription);
        if (fail) {
            //去掉 菊花加载动画
            [[DataHander sharedDataHander] hideDlg];
            fail();
        }
    }];
}

+ (void)hide
{
    [[DataHander sharedDataHander] hideDlg];
}


@end
