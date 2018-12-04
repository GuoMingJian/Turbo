//
//  TBScanView.m
//  TBBusiness
//
//  Created by Apple on 2018/10/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBScanView.h"

@interface TBScanView ()
@property (nonatomic, strong) UIImageView * cameraImageView;
@property (nonatomic, strong) UIImageView * lineImageView;

@end
@implementation TBScanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //二维码扫描相框
    self.cameraImageView = [[UIImageView alloc] initWithFrame:self.cameraImageViewRect];
    self.cameraImageView.image = [UIImage imageNamed:@"TBScanCode.bundle/scanArea"];
    [self addSubview:self.cameraImageView];
    
    //二维码扫描线条
    if(self.lineImageView == nil)
    {
        CGFloat lineW = self.cameraImageView.frame.size.width;
        self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, lineW, 2)];
        self.lineImageView.image = [UIImage imageNamed:@"TBScanCode.bundle/line"];
        [self.cameraImageView addSubview:self.lineImageView];
    }
    
    //设置定时器
    if(self.myTimer == nil)
    {
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(changeLineSite) userInfo:nil repeats:YES];
        [self.myTimer fire];
    }
}

#pragma mark - 更改扫描线的位置（上线移动）
- (void)changeLineSite
{
    CGRect rect = self.lineImageView.frame;
    CGFloat y = rect.origin.y;
    CGFloat cameraH = self.cameraImageView.frame.size.height;
    
    static BOOL down = YES;
    
    if (down) {
        y -= 1;
        if (y <= 0) {
            down = !down;
        }
    } else {
        y += 1;
        if (y == cameraH) {
            down = !down;
        }
    }
    
    rect.origin.y = y;
    self.lineImageView.frame = rect;
}

- (void)drawRect:(CGRect)rect
{
    CGRect screenRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    CGFloat originX = screenRect.origin.x + self.cameraImageView.frame.origin.x;
    CGFloat originY = screenRect.origin.y + self.cameraImageView.frame.origin.y;
    
    //设置清空区域(即扫描的有效区域)
    CGRect clearDrawRect = CGRectMake(originX, originY, self.scanAreaSize.width, self.scanAreaSize.height);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //设置视图区域为灰色
    [self addScreenFillRect:ctx rect:screenRect];
    //设置扫描的区域为透明色
    [self addCenterClearRect:ctx rect:clearDrawRect];
}

/**
 *  设置视图区域为灰色
 */
- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect
{
    CGContextSetRGBFillColor(ctx,
                             40 / 255.0,
                             40 / 255.0,
                             40 / 255.0,0.5);
    
    CGContextFillRect(ctx, rect);
}

/**
 *  设置扫描的区域为透明色
 */
- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect
{
    CGContextClearRect(ctx, rect);
}

-(void)dealloc {
    TBDeallocMark(...);
}
@end
