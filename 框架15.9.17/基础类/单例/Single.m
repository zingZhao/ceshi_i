//
//  Single.m
//  Eleven_frame
//
//  Created by 吕君 on 15/4/2.
//  Copyright (c) 2015年 eleven. All rights reserved.
//

#import "Single.h"

static Single* _instance;

@implementation Single

+(Single *)sharedInstance{
    if (_instance==nil) {
        _instance=[[Single alloc]init];
//        _instance.image_arr = [NSMutableArray array];
//        _instance.dic = [[NSMutableDictionary alloc]init];
    }
    return _instance;
}
@end
