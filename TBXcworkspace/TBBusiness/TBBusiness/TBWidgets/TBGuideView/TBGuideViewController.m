//
//  TBGuideViewController.m
//  TBBusiness
//
//  Created by Apple on 2018/10/11.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBGuideViewController.h"

@interface TBGuideViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic) CGFloat imgViewW;
@property (nonatomic) CGFloat imgViewH;
@property (nonatomic, strong) UIColor *baseColor;
@end

@implementation TBGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.baseColor = [UIColor colorWithRed:58/255.0f green:152/255.0f blue:248/255.0f alpha:1.0f];
    
    [self createData];
    [self createScrollView];
    [self createPageControl];
    [self addImgView];
}

#pragma mark -
-(void)createData {
    self.imgArr = @[@"guide01",@"guide02",@"guide03"];
}

#pragma mark -
-(void)createScrollView {
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    CGFloat scrollViewW = self.view.frame.size.width;
    CGFloat scrollViewH = self.view.frame.size.height;
    self.imgViewW = scrollViewW;
    self.imgViewH = scrollViewH;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    if (@available(iOS 11, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.imgArr.count * scrollViewW, scrollViewH);
}

#pragma mark -
-(void)createPageControl {
    self.pageControl = [[UIPageControl alloc] init];
    [self.view addSubview:self.pageControl];
    NSInteger pageNum = self.imgArr.count;
    self.pageControl.numberOfPages = pageNum;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:219/255.0f green:219/255.0f blue:219/255.0f alpha:1.0f];
    self.pageControl.currentPageIndicatorTintColor = self.baseColor;
    self.pageControl.userInteractionEnabled = NO;
    
    // 设置区域
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:pageNum];
    CGFloat pageControlX = (self.imgViewW - pageControlSize.width) / 2;
    CGFloat pageControlY = self.imgViewH - pageControlSize.height - 10;
    CGFloat pageControlW = pageControlSize.width;
    CGFloat pageControlH = pageControlSize.height;
    [self.pageControl setFrame:CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH)];
}

#pragma mark -
-(void)addImgView {
    for (NSInteger i = 0; i < self.imgArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.imgViewW * i, 0, self.imgViewW, self.imgViewH)];
        imgView.image = [UIImage imageNamed:self.imgArr[i]];
        [self.scrollView addSubview:imgView];
        
        // 最后一个UIImageView加入按钮
        if (i == self.imgArr.count - 1) {
            CGFloat btnW = 140;
            CGFloat btnH = 40;
            CGFloat btnX = (self.imgViewW - btnW) / 2;
            CGFloat btnY = self.imgViewH - btnH - 50;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            [imgView addSubview:btn];
            imgView.userInteractionEnabled = YES;
            
            btn.layer.cornerRadius = btnH / 2;
            btn.clipsToBounds = YES;
            btn.layer.borderWidth = 1.0f;
            btn.layer.borderColor = self.baseColor.CGColor;
            [btn setTitleColor:self.baseColor forState:UIControlStateNormal];
            [btn setTitle:@"立即体验" forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark -
-(void)buttonClick:(UIButton *)btn {
    if (self.guideViewBlock) {
        self.guideViewBlock();
    }
}

#pragma mark - UIScrollViewDelegate 代理方法
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self setPageControlCurrentPage:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setPageControlCurrentPage:scrollView];
}

#pragma mark -
- (void)setPageControlCurrentPage:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    self.pageControl.currentPage = roundf(offsetX/self.imgViewW);
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
