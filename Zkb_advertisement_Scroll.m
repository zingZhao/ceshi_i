//
//  Zkb_advertisement_Scroll.m
//  me
//
//  Created by 赵奎博 on 16/1/14.
//  Copyright © 2016年 赵奎博. All rights reserved.
//

#import "Zkb_advertisement_Scroll.h"
#import "UIImageView+WebCache.h"
#import "Eleven_Header.h"
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width - 20

@implementation Zkb_advertisement_Scroll

-(void)Zkb_AdverScroll_hight:(CGFloat)hight width:(CGFloat)width Source:(NSArray *)array time_space:(NSInteger)time placeholderImageStr:(NSString *)placeImageStr link:(NSArray *)linkArray
{
    array_link = [[NSMutableArray alloc]initWithArray:linkArray];
    
    wid = width;
    
    self.contentSize = CGSizeMake(width * (array.count + 2), hight);
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.contentOffset = CGPointMake(width, 0);
    NSMutableArray * array_ima = [NSMutableArray arrayWithArray:array];
    
    //[array_ima addObject:array_ima[0]];
    if(array_ima.count > 1){
        [array_ima insertObject:array_ima[0] atIndex:1];
        [array_link insertObject:array_link[0] atIndex:1];
    }
    if(array_ima.count > 0){
        [array_ima addObject:array_ima[0]];
        [array_link addObject:array_link[0]];
    }
    
    for (int i=0; i< array_ima.count; i++)
    {
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(width * i, 0, width, hight)];
        image.userInteractionEnabled = YES;
        image.tag = i;
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",image_head,array_ima[i]]] placeholderImage:[UIImage imageNamed:placeImageStr]];
        [self addSubview:image];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [image addGestureRecognizer:tap];
    }
    
    page = [[UIPageControl alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH - 40, hight - 20, 50, 20)];
    page.numberOfPages = 3;
    page.currentPage = 0;
    page.pageIndicatorTintColor = [UIColor whiteColor];
    page.currentPageIndicatorTintColor = [UIColor orangeColor];
//    [page addTarget:self action:@selector(page:) forControlEvents:UIControlEventTouchUpInside];
    [self.superview addSubview:page];
    
    [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(chge) userInfo:nil repeats:YES];
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    [self.zkb_delegate load_adver_viewUrl:array_link[tap.view.tag]];
}

//-(void)page:(UIPageControl *)pager
//{
//    [self setContentOffset:CGPointMake(pager.currentPage * DEF_SCREEN_WIDTH, 0) animated:YES];
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"%f-----%f-------%f",self.contentOffset.x,DEF_SCREEN_WIDTH,wid);
    page.currentPage = scrollView.contentOffset.x / wid - 1;
    if(self.contentOffset.x / wid >= 4 )
    {
        [self setContentOffset:CGPointMake(wid, 0) animated:NO];
    }
    
    if(self.contentOffset.x <= 0)
    {
        [self setContentOffset:CGPointMake(wid * 3, 0) animated:NO];
    }
}

-(void)chge
{
    [self setContentOffset:CGPointMake(self.contentOffset.x + wid, 0) animated:YES];
}

@end
