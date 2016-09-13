//
//  UnityLH.h
//  UnityLH
//  工具类
//  Created by apple on 13-5-30.
//  Copyright (c) 2013年 UnityLH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnityLHClass : NSObject

+ (UnityLHClass*)shareUnityClassObject;

//初始化系统控件

+(void)showPointOut:(NSString*)str;
@end

