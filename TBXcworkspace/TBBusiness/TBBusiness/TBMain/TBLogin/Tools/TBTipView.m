//
//  TBTipView.m
//  ZXToolProjects
//
//  Created by 郭明健 on 2018/6/25.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import "TBTipView.h"

@interface TBTipView()

/**
 提示框与屏幕的间距
 */
@property (nonatomic, assign)CGFloat spacOfWindow;

/**
 文字与提示框间距
 */
@property (nonatomic, assign)CGFloat spacOfTipView;

/**
 文字字体
 */
@property (nonatomic, strong) UIFont *font;

//
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat timeInterval;
@property (nonatomic, assign) TBAlignment currentAlignment;
@property (nonatomic, copy) NSString *currentContent;

@end

@implementation TBTipView

#pragma mark - 外部调用API

+ (void)showTipView:(NSString *)text
{
    [self showTipView:text duration:0.5f alignment:TBCenter];
}

+ (void)showTipView:(NSString *)text
           duration:(CGFloat)duration
{
    [self showTipView:text duration:duration alignment:TBCenter];
}

+ (void)showTipView:(NSString *)text
          alignment:(TBAlignment)alignment
{
    [self showTipView:text duration:2.0 alignment:alignment];
}

+ (void)showTipView:(NSString *)text
           duration:(CGFloat)duration
          alignment:(TBAlignment)alignment
{
    TBTipView *tbTipView = [[TBTipView alloc] init];
    //    tbTipView.spacOfWindow = 50;
    //    tbTipView.spacOfTipView = 30;
    [tbTipView showTipView:text duration:duration alignment:alignment];
}

#pragma mark - 内部实现

- (void)setSpacOfWindow:(CGFloat)spacOfWindow
{
    _spacOfWindow = spacOfWindow;
    [self updateUI ];
}

- (void)setSpacOfTipView:(CGFloat)spacOfTipView
{
    _spacOfTipView = spacOfTipView;
    [self updateUI];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    _label.font = self.font;
    [self updateUI];
}

- (id)init
{
    if (self = [super init])
    {
        _spacOfWindow = 30.f;
        _spacOfTipView = 15.0f;
        _font = [UIFont boldSystemFontOfSize:16];
        _currentContent = @"";
        _currentAlignment = 0;
        //
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font = self.font;
        _label.numberOfLines = 0;
        _label.textColor = [UIColor whiteColor];
        [self addSubview:_label];
        //
        self.backgroundColor = [UIColor blackColor];
        
        //
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        
        //监听横竖屏切换
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)showTipView:(NSString *)text
           duration:(CGFloat)duration
          alignment:(TBAlignment)alignment;
{
    self.currentAlignment = alignment;
    self.currentContent = text;
    [self updateUI];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    _timeInterval = (duration <= 0) ? 2 : duration;//提示框显示时间:默认2秒
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeTBTipView];
    });
}

- (void)updateUI
{
    //汉字左右对齐
    NSAttributedString *attStr = [self setTextString:_currentContent];
    _label.attributedText = attStr;
    //
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat navigationBarHeight = (screenHeight == 812.0) ? 88 : 64;
    CGFloat tabBarHeight = 49;
    //
    UIView *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect supFrame = keyWindow.frame;
    UIFont *font = _font;
    CGSize size = CGSizeMake(supFrame.size.width - _spacOfWindow * 2, screenHeight);
    //
    CGRect rect = [self textRect:_currentContent font:font displaySize:size];
    CGFloat space_x = _spacOfTipView;
    CGFloat space_y = _spacOfTipView;
    CGFloat x = (supFrame.size.width - (rect.size.width + space_x * 2)) / 2.0;
    CGFloat y = (supFrame.size.height - (rect.size.height + space_y * 2)) / 2.0;//默认居中
    //
    switch (_currentAlignment)
    {
        case 0:
            break;
        case 1:
            y = navigationBarHeight + space_y;
            break;
        case 2:
            y = supFrame.size.height - tabBarHeight - space_y - (rect.size.height + space_y * 2);
            break;
            
        default:
            break;
    }
    
    //
    self.frame = CGRectMake(x, y, rect.size.width + space_x * 2, rect.size.height + space_y * 2);
    
    //
    _label.text = _currentContent;
    _label.frame = CGRectMake(_spacOfTipView, _spacOfTipView, self.frame.size.width - _spacOfTipView * 2, self.frame.size.height - _spacOfTipView * 2);
}

//屏幕旋转处理
- (void)orientChange
{
    if (self)
    {
        [self updateUI];
    }
}

- (void)removeTBTipView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - private

/**
 设置汉字左右对齐
 */
- (NSAttributedString *)setTextString:(NSString *)text
{
    NSMutableAttributedString *mAbStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *npgStyle = [[NSMutableParagraphStyle alloc] init];
    npgStyle.alignment = NSTextAlignmentJustified;
    npgStyle.paragraphSpacing = 11.0;
    npgStyle.paragraphSpacingBefore = 10.0;
    npgStyle.firstLineHeadIndent = 0.0;
    npgStyle.headIndent = 0.0;
    NSDictionary *dic = @{
                          NSParagraphStyleAttributeName :npgStyle,
                          NSUnderlineStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleNone]
                          };
    [mAbStr setAttributes:dic range:NSMakeRange(0, mAbStr.length)];
    NSAttributedString *attrString = [mAbStr copy];
    
    return attrString;
}

/**
 文本Rect
 */
- (CGRect)textRect:(NSString *)text
              font:(UIFont *)font
       displaySize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGRect rect = [text boundingRectWithSize:size
                                     options:NSStringDrawingTruncatesLastVisibleLine
                   |NSStringDrawingUsesLineFragmentOrigin
                   |NSStringDrawingUsesFontLeading
                                  attributes:attribute context:nil];
    return rect;
}

@end

