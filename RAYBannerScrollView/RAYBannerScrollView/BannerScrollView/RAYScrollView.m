//
//  RAYScrollView.m
//  RAYBannerScrollView
//
//  Created by 党磊 on 15/9/20.
//  Copyright © 2015年 richerpay. All rights reserved.
//

#import "RAYScrollView.h"

@interface RAYScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableSet *visibleImageViews;  //保存可见的视图
@property (nonatomic, strong) NSMutableSet *reusedImageViews;   //保存可重用的
@property (nonatomic, strong) UIScrollView *scrollView;         //滚动视图
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *imageNames;              //所有的图片名

@end

@implementation RAYScrollView

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        self.pageControl.numberOfPages = self.imageNames.count;
        [self showImageViewAtIndex:0];   //显示imageview
   
//        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
//        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showImages];
    
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pagewidth/([self.imageNames count]+2))/pagewidth)+1;
//    page --;  // 默认从第二页开始
    self.pageControl.currentPage = page;
//    [self test];
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {      // called when scroll view grinds to a halt
//    
//    int currentPage = floor((self.scrollView.contentOffset.x - self.scrollView.frame.size.width / ([self.imageNames count]+2)) / self.scrollView.frame.size.width) + 1;
//    if (currentPage==0) {
//        //go last but 1 page
//        [self.scrollView scrollRectToVisible:CGRectMake(320 * [self.imageNames count],0,320,128) animated:NO];
//    }
//    else if (currentPage==([self.imageNames count]+1)) { //如果是最后+1,也就是要开始循环的第一个
//        [self.scrollView scrollRectToVisible:CGRectMake(320,0,320,128) animated:NO];
//    }
//}

//- (void)test {
//    NSMutableString *rs = [NSMutableString string];
//    NSInteger count = [self.scrollView.subviews count];
//    for (UIImageView *imageView in self.scrollView.subviews) {
//        [rs appendFormat:@"%p - ", imageView];
//    }
//    [rs appendFormat:@"%ld", (long)count];
//    NSLog(@"%@", rs);
//}

#pragma mark - Private Method

- (void)showImages {
    
    // 获取当前处于显示范围内的图片的索引
    CGRect visibleBounds = self.scrollView.bounds;
    CGFloat minX = CGRectGetMinX(visibleBounds);
    CGFloat maxX = CGRectGetMaxX(visibleBounds);
    CGFloat width = CGRectGetWidth(visibleBounds);
    
    NSInteger firstIndex = (NSInteger)floorf(minX / width);
    NSInteger lastIndex  = (NSInteger)floorf(maxX / width);
    
    // 处理越界的情况
    if (firstIndex < 0) {
        firstIndex = 0;
    }
    
    if (lastIndex >= [self.imageNames count]) {
        lastIndex = [self.imageNames count] - 1;
    }
    
    // 回收不再显示的ImageView
    NSInteger imageViewIndex = 0;
    for (UIImageView *imageView in self.visibleImageViews) {
        imageViewIndex = imageView.tag;
        // 不在显示范围内
        if (imageViewIndex < firstIndex || imageViewIndex > lastIndex) {
            [self.reusedImageViews addObject:imageView];
            [imageView removeFromSuperview];
        }
    }
    
    [self.visibleImageViews minusSet:self.reusedImageViews];
    
    // 是否需要显示新的视图
    for (NSInteger index = firstIndex; index <= lastIndex; index++) {
        BOOL isShow = NO;
        
        for (UIImageView *imageView in self.visibleImageViews) {
            if (imageView.tag == index) {
                isShow = YES;
            }
        }
        
        if (!isShow) {
            [self showImageViewAtIndex:index];
        }
    }
}

// 显示一个图片view
- (void)showImageViewAtIndex:(NSInteger)index {
    
    UIImageView *imageView = [self.reusedImageViews anyObject]; //随机返回一个元素，没有元素则返回nil
    
    if (imageView) {   // 如果保存可重用集合中有元素
        [self.reusedImageViews removeObject:imageView];
    }
    else {
        imageView = [[UIImageView alloc] init]; //无元素初始化一个
        imageView.contentMode = UIViewContentModeScaleAspectFit; //contents scaled to fit with fixed aspect. remainder is transparent
    }
    CGRect bounds = self.scrollView.bounds; //将scrollview的bounds 值取出
    CGRect imageViewFrame = bounds;         //
    imageViewFrame.origin.x = CGRectGetWidth(bounds) * index;
    imageView.tag = index;
    imageView.frame = imageViewFrame;
    imageView.image = [UIImage imageNamed:self.imageNames[index]];
    
    [self.visibleImageViews addObject:imageView];  //将视图1添加到visibleImageView进行保存
    [self.scrollView addSubview:imageView];        //将视图1添加到scrollview
}

#pragma mark - Getters and Setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = self.bounds;
        _scrollView.contentSize = CGSizeMake(self.imageNames.count * CGRectGetWidth(self.scrollView.frame), 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *) pageControl {
    
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl  alloc]initWithFrame:CGRectMake(self.bounds.size.width/2, self.bounds.size.height-20, self.bounds.size.width/
                                                                       2, 20)];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.enabled = NO;
//        _pageControl.numberOfPages = 2;//    _pageControl.numberOfPages = slidecount;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor brownColor];
    }
    return _pageControl;
}

- (NSArray *)imageNames {
    if (_imageNames == nil) {
        NSMutableArray *imageNames = [NSMutableArray arrayWithCapacity:50];
        
        for (int i = 0; i < 4; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%d.jpg", (i % 5)+1];
            [imageNames addObject:imageName];
        }
        
        _imageNames = imageNames;
    }
    return _imageNames;
}

- (NSMutableSet *)visibleImageViews {
    if (_visibleImageViews == nil) {
        _visibleImageViews = [[NSMutableSet alloc] init];
    }
    return _visibleImageViews;
}

- (NSMutableSet *)reusedImageViews {
    if (_reusedImageViews == nil) {
        _reusedImageViews = [[NSMutableSet alloc] init];
    }
    return _reusedImageViews;
}

@end
