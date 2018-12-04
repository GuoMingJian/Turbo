//
//  TBActivityView.m
//  TBBusiness
//
//  Created by Apple on 2018/6/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBActivityView.h"

#define ViewCenterX view.frame.size.width
#define ViewCenterY view.frame.size.height

@interface TBActivityView ()
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation TBActivityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
        view.center = self.center;
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6f];
        view.layer.cornerRadius = 5.0f;
        view.clipsToBounds = YES;
        [self addSubview:view];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.activityView.center = CGPointMake(ViewCenterX*0.5, ViewCenterY*0.5 - 10 );
        self.activityView.hidesWhenStopped = YES;
        self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.activityView startAnimating];
        [view addSubview:self.activityView];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        
        lable.center = CGPointMake(ViewCenterX*0.5, CGRectGetMaxY(view.frame) - 20);
        
        lable.text = @"正在加载...";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:13.5f];
        lable.textColor = [UIColor whiteColor];
        [view addSubview:lable];
        
    }
    return self;
}

@end
