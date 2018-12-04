//
//  TBUpdateTipsView.m
//  TBBusiness
//
//  Created by Apple on 2018/9/5.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBUpdateTipsView.h"

@interface TBUpdateTipsView ()
@property (strong, nonatomic)  UIView *alertView;
@property (strong, nonatomic)  UIImageView *iconImgView;
@property (strong, nonatomic)  UIButton *closeBtn;
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UITextView *contentTextView;
@property (strong, nonatomic)  UIButton *updateBtn;
@end

@implementation TBUpdateTipsView

#pragma mark - 初始化
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    return self;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT);
        // 蒙板设置
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    return self;
}

#pragma mark - 布局
-(void)layoutSubviews {
    // 弹窗视图
    self.alertView = [[UIView alloc] init];
    [self addSubview:self.alertView];
    self.alertView.layer.cornerRadius = 10.0f;
    self.alertView.clipsToBounds = YES;
    self.alertView.backgroundColor = [UIColor whiteColor];
    
    // 头部icon
    UIImage *iconImg = [UIImage imageNamed:@"updateBackImg"];
    CGFloat iconImgViewW = iconImg.size.width;
    CGFloat iconImgViewH = iconImg.size.height;
    CGFloat iconImgViewX = 0.0;
    CGFloat iconImgViewY = 0.0;
    self.iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(iconImgViewX, iconImgViewY, iconImgViewW, iconImgViewH)];
    self.iconImgView.userInteractionEnabled = YES;
    [self.iconImgView setImage:iconImg];
    [self.alertView addSubview:self.iconImgView];

    // 关闭按钮
    CGFloat closeBtnW = 30;
    CGFloat closeBtnH = 30;
    CGFloat closeBtnX = iconImgViewW - closeBtnW - 5;
    CGFloat closeBtnY = 5;
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeBtn.backgroundColor = [UIColor clearColor];
    [self.closeBtn setFrame:CGRectMake(closeBtnX, closeBtnY, closeBtnW, closeBtnH)];
    [self.closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.iconImgView addSubview:self.closeBtn];
    if (self.isHideCloseBtn) {
        self.closeBtn.hidden = YES;
    } else {
        self.closeBtn.hidden = NO;
    }
    UIImage *closeBtnImg = [UIImage imageNamed:@"close"];
    CGFloat closeBtnImgViewW = closeBtnImg.size.width;
    CGFloat closeBtnImgViewH = closeBtnImg.size.height;
    CGFloat closeBtnImgViewX = (closeBtnW-closeBtnImgViewW) / 2;
    CGFloat closeBtnImgViewY = (closeBtnH-closeBtnImgViewH) / 2;
    UIImageView *closeBtnImgView = [[UIImageView alloc] initWithImage:closeBtnImg];
    closeBtnImgView.frame = CGRectMake(closeBtnImgViewX, closeBtnImgViewY, closeBtnImgViewW, closeBtnImgViewH);
    [self.closeBtn addSubview:closeBtnImgView];
    
    // 提示内容
    CGFloat textViewX = 15.0;
    CGFloat textViewY = CGRectGetMaxY(self.iconImgView.frame) + 5;
    CGFloat textViewW = iconImgViewW - textViewX*2;
    CGFloat textViewH = 120;
    self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(textViewX, textViewY, textViewW, textViewH)];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self.message dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.contentTextView.attributedText = attributedString;
    self.contentTextView.editable = NO;
    self.contentTextView.textColor = [UIColor colorWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:1.0f];
    CGSize constraintSize = CGSizeMake(textViewW, textViewH);
    CGSize size = [self.contentTextView sizeThatFits:constraintSize];
    if (size.height > textViewH) {
        size.height = textViewH;
        self.contentTextView.scrollEnabled = YES;
    } else {
        self.contentTextView.scrollEnabled = NO;
    }
    [self.contentTextView setFrame:CGRectMake(textViewX, textViewY, textViewW, size.height)];
    [self.alertView addSubview:self.contentTextView];
    
    // 更新按钮
    CGFloat updateBtnW = 180.0f;
    CGFloat updateBtnH = 40.0f;
    CGFloat updateBtnX = (iconImgViewW - updateBtnW)/2;
    CGFloat updateBtnY = CGRectGetMaxY(self.contentTextView.frame) + 10;
    self.updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.updateBtn setFrame:CGRectMake(updateBtnX, updateBtnY, updateBtnW, updateBtnH)];
    [self.updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [self.updateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.updateBtn.backgroundColor = [UIColor colorWithRed:253/255.0f green:145/255.0f blue:38/255.0f alpha:1.0f];
    self.updateBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.updateBtn.layer.cornerRadius = updateBtnH/2;
    [self.updateBtn addTarget:self action:@selector(updateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:self.updateBtn];
    
    // 重设alertView区域
    CGFloat alertViewW = iconImgViewW;
    CGFloat alertViewH = iconImgViewH + 5 + size.height + 5 + updateBtnH + 26;
    CGFloat alertViewX = (self.frame.size.width - alertViewW)/2;
    CGFloat alertViewY = (self.frame.size.height - alertViewH)/2;
    [self.alertView setFrame:CGRectMake(alertViewX, alertViewY, alertViewW, alertViewH)];
}

#pragma mark - 关闭
- (void)closeBtnClick:(UIButton *)sender {
    [self hidden];
}

#pragma mark - 确定更新
- (void)updateBtnClick:(UIButton *)sender {
    if (self.updateTipsViewBlock) {
        self.updateTipsViewBlock();
    }
    
    [self hidden];
}

#pragma mark - 隐藏
-(void)hidden {
    [self removeFromSuperview];
}

@end
