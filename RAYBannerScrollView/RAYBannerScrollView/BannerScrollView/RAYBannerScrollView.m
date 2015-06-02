//
//  RAYBannerScrollView.m
//  RAYBannerScrollView
//
//  Created by richerpay on 15/6/2.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "RAYBannerScrollView.h"

@interface RAYBannerScrollView() <UIScrollViewDelegate>{
    
}

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *slideArray;

@end

@implementation RAYBannerScrollView

#pragma mark - life cycle
- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
    }
    return self;
}


#pragma mark - UIScrollViewDelegate  性能优化！！！！！！！！！！！！！！！！！！！！！！！！
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pagewidth/([self.slideArray count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    self.pageControl.currentPage = page;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {      // called when scroll view grinds to a halt
    
    int currentPage = floor((self.scrollView.contentOffset.x - self.scrollView.frame.size.width / ([self.slideArray count]+2)) / self.scrollView.frame.size.width) + 1;
    if (currentPage==0) {
        //go last but 1 page
        [self.scrollView scrollRectToVisible:CGRectMake(320 * [self.slideArray count],0,320,128) animated:NO];
    } else if (currentPage==([self.slideArray count]+1)) { //如果是最后+1,也就是要开始循环的第一个
        [self.scrollView scrollRectToVisible:CGRectMake(320,0,320,128) animated:NO];
    }
    
    
}

#pragma mark - event response
- (void)onTapped:(UITapGestureRecognizer*)gesture {
    CGPoint touchPoint = [gesture locationInView:self.scrollView];
    NSLog(@"pt:%f %f",touchPoint.x,touchPoint.y);
    int currentPage = floor((self.scrollView.contentOffset.x - self.scrollView.frame.size.width / ([self.slideArray count]+2)) / self.scrollView.frame.size.width) + 1;
    NSLog(@"current =%i",currentPage);
    
}
#pragma mark - private methods
- (void) initImageWithArray:(NSArray *)array {
    
    self.slideArray = array;
    NSInteger slidecount = [self.slideArray count];
    _pageControl.numberOfPages = slidecount;
    _pageControl.currentPage = 0;
    // 取数组最后一张图片 放在第0页
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.slideArray objectAtIndex:(slidecount-1)]]];
    imageView.frame = CGRectMake(0, 0, 320, 256); // 添加最后1页在首页 循环
    [self.scrollView addSubview:imageView];
    
    // 取数组第一张图片 放在最后1页
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.slideArray objectAtIndex:0]]];
    imageView.frame = CGRectMake((320 * ([self.slideArray count] + 1)) , 0, 320, 256); // 添加第1页在最后 循环
    [self.scrollView addSubview:imageView];
    
    for (int i = 0;i<slidecount;i++) {
        
        //loop this bit
        UIImageView *imageView = [[UIImageView alloc]
                                  initWithImage: [UIImage imageNamed:[self.slideArray objectAtIndex:i]]];//[self  cutCenterImage:[UIImage imageNamed:[self.slideArray objectAtIndex:i]] size:CGSizeMake(320, 128)]];
        imageView.frame = CGRectMake(320*i+320, 0, 320, 256);
        
        imageView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:imageView];
    }
    
    [self.scrollView setContentSize:CGSizeMake(320 * (slidecount + 2), 128)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    [self.scrollView scrollRectToVisible:CGRectMake(320,0,320,128) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
    [self updateScrollView];
}

- (void) updateScrollView
{
    NSTimer* myTimer; //= [myTimer invalidate];
    //        myTimer = nil;
    
    //time duration
    NSTimeInterval timeInterval = 3;
    //timer
    myTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                               target:self
                                             selector:@selector(handleMaxShowTimer:)
                                             userInfo: nil
                                              repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:myTimer forMode:NSRunLoopCommonModes]; //！！！！！！！！
}

- (void)handleMaxShowTimer:(NSTimer*)theTimer
{
    CGPoint pt = self.scrollView.contentOffset;
    NSInteger  count = [self.slideArray count];
    if(pt.x == 320 * count){
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        [self.scrollView scrollRectToVisible:CGRectMake(320,0,320,128) animated:YES];
    }else{
        [self.scrollView scrollRectToVisible:CGRectMake(pt.x+320,0,320,128) animated:YES];
    }
}


#pragma mark 根据size截取图片中间矩形区域的图片 这里的size是正方形
-(UIImage *)cutCenterImage:(UIImage *)image size:(CGSize)size{
    CGSize imageSize = image.size;
    CGRect rect;
    //根据图片的大小计算出图片中间矩形区域的位置与大小
    if (imageSize.width > imageSize.height) {
        float leftMargin = (imageSize.width - imageSize.height) * 0.5;
        rect = CGRectMake(leftMargin, 0, imageSize.height, imageSize.height);
    }else{
        float topMargin = (imageSize.height - imageSize.width) * 0.5;
        rect = CGRectMake(0, topMargin, imageSize.width, imageSize.width);
    }
    
    CGImageRef imageRef = image.CGImage;
    //截取中间区域矩形图片
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    
    UIImage *tmp = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);
    
    UIGraphicsBeginImageContext(size);
    CGRect rectDraw = CGRectMake(0, 0, size.width, size.height);
    [tmp drawInRect:rectDraw];
    // 从当前context中创建一个改变大小后的图片
    tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return tmp;
}

#pragma mark - getters and setters
- (UIScrollView  *) scrollView {
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = YES;
    }
    return _scrollView;
    
}

- (UIPageControl *) pageControl {
    
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl  alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width
                                                                       , 20)];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.enabled = NO;
        _pageControl.numberOfPages = 2;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor brownColor];
    }
    return _pageControl;
}

@end
