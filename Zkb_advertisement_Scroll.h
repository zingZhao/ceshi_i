//
//  Zkb_advertisement_Scroll.h
//  me
//
//  Created by 赵奎博 on 16/1/14.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol zkb_adverDelegate <NSObject>

-(void)load_adver_viewUrl:(NSString *)urlLink;

@end

@interface Zkb_advertisement_Scroll : UIScrollView<UIScrollViewDelegate>
{
    UIPageControl * page;
    
    CGFloat wid;
    
    NSMutableArray * array_link;
}
@property (nonatomic,assign) id<zkb_adverDelegate> zkb_delegate;
-(void)Zkb_AdverScroll_hight:(CGFloat)hight width:(CGFloat)width Source:(NSArray *)array time_space:(NSInteger)time placeholderImageStr:(NSString *)placeImageStr link:(NSArray *)linkArray;
@end
