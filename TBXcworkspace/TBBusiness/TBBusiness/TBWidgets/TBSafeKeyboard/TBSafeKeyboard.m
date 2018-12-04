//
//  SafeKeyboard.m
//  TBBusiness
//
//  Created by Apple on 2018/5/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBSafeKeyboard.h"
#import "UIImage+Handle.h"
#import "TBCharButton.h"

#pragma mark ------------------------ define ------------------------

// 字体
#define KBFont(s) [UIFont fontWithName:@"HelveticaNeue-Light" size:s]
// 字体大小
#define FontSize 18

#define CHAR_CORNER 6
#define TITLEHEIGHT 35
#define ICONHEIGHT TITLEHEIGHT*0.5
#define NHSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
// 键盘背景色
#define BGColor RGB(210,214,219)
// 标题文字颜色
#define TitleColor RGB(0,0,0)
// 按键文字颜色
#define BtnTitleColor RGB(0,0,0)
// 字母按键文字背景色
#define BtnBgColor RGB(255,255,255)
// 数字按键文字背景色
#define NumBtnBgColor RGB(244,244,244)
// 数字键边框颜色
#define BtnBoardColor [UIColor lightGrayColor]
// 数字按键高亮背景色
#define BtnHighlightColor RGB(43, 116, 224)

// title分割线颜色
#define LineColor [UIColor lightGrayColor]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define Characters @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m"]
#define Symbols  @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"-",@"/",@":",@";",@"(",@")",@"$",@"&",@"@",@"\"",@".",@",",@"?",@"!",@"'"]
#define moreSymbols  @[@"[",@"]",@"{",@"}",@"#",@"%",@"^",@"*",@"+",@"=",@"_",@"\\",@"|",@"~",@"<",@">",@"€",@"£",@"¥",@"•",@".",@",",@"?",@"!",@"'"]

@interface TBSafeKeyboard ()
/**
 *  数字 数字小数点 字母
 */
@property (nonatomic, assign) SafeKeyboardType type;

/**
 *  数字键按钮
 */
@property (nonatomic, strong) NSArray *numKeys;

@property (nonatomic, assign) BOOL shiftEnable,showSymbol,showMoreSymbol;
@property (nonatomic, strong) UIButton *shiftBtn,*charSymSwitch;
@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic, strong) UIButton *frontBtn;
@end

static TBSafeKeyboard* keyboardViewInstance = nil;
@implementation TBSafeKeyboard

//+(SafeKeyboard *)shareKeyboardViewWithType:(KeyboardType)type
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//        keyboardViewInstance = [[SafeKeyboard alloc] initWithFrame:CGRectMake(0, 0, NHSCREEN_WIDTH, KEYBOARDHEIGHT+ICONHEIGHT) withType:type];
//    });
//    return keyboardViewInstance;
//}

+ (instancetype)keyboardWithType:(SafeKeyboardType)type
{
    return [[TBSafeKeyboard alloc] initWithFrame:CGRectMake(0, 0, NHSCREEN_WIDTH, KEYBOARDHEIGHT+ICONHEIGHT) withType:type];
}

- (instancetype)initWithFrame:(CGRect)frame withType:(SafeKeyboardType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self initSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.type = SafeKeyboardTypeNum;
        [self initSetup];
    }
    return self;
}
#pragma mark - 创建键盘
- (void)initSetup
{
    self.enterprise = @"安全键盘";
    // 背景色
    self.backgroundColor = BGColor;
    CGRect bounds = self.bounds;
    // 总高度
    bounds.size.height = KEYBOARDHEIGHT+TITLEHEIGHT;
    self.bounds = bounds;
    
    // 分割线
    CGFloat lineH = 1;
    bounds = CGRectMake(0, TITLEHEIGHT-lineH, NHSCREEN_WIDTH,lineH);
    UIView *line = [[UIView alloc] initWithFrame:bounds];
    line.backgroundColor = LineColor;
    [self addSubview:line];
    
    //创建键盘
    if (SafeKeyboardTypeNum == self.type)
    {
        [self setUpNumberPad:NO];
    }
    else if (SafeKeyboardTypeNumDecimal == self.type)
    {
        [self setUpNumberPad:YES];
    }
    else if (SafeKeyboardTypeABC == self.type)
    {
        [self setupABCLayout:YES];
    }
}

#pragma mark- 创建字母按键
/**
 *  布局字母键盘
 *  固定几个功能键去除 剩下的按键平分计算，按钮个数根据是否是符号区分
 *  每次切换清空按钮数组 重新创建
 *  @param init 是否初始化 - 切换字符时
 */
- (void)setupABCLayout:(BOOL)init
{
    if (!init) //不是初始化创建 重新布局字母或字符界面
    {
        NSArray *subviews = self.subviews;
        [subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[TBCharButton class]])
            {
                [obj removeFromSuperview];
            }
        }];
    }
    
    // 需要显示的字符
    NSArray *charSets;
    // 每行的长度
    NSArray *rangs;
    if (!self.showSymbol)// 显示字母时的3行的长度
    {
        charSets = Characters;
        rangs = @[@10,@19,@26];
    }
    else // 显示符号时的3行的长度
    {
        // 显示符号是显示普通数字符号 还是 更多符号
        charSets = self.showMoreSymbol? moreSymbols:Symbols;
        rangs = @[@10,@20,@25];
    }
    
    //第一排
    NSInteger loc = 0;
    // 取到每行的长度
    NSInteger length = [[rangs objectAtIndex:0] integerValue];
    NSArray *chars = [charSets subarrayWithRange:NSMakeRange(loc, length)];
    NSInteger len = [chars count];
    // 按键间距，左右间距为此间距一半
    CGFloat charMarginX = 5.5;//左右间距
    CGFloat charMarginY = 10;// 上下间距
    CGFloat KBMarginY = 10; // 最上排和最下排键盘距离键盘的边距
    // 字母宽度
    CGFloat char_width = (NHSCREEN_WIDTH-charMarginX*len)/len;
    CGFloat char_heigh = (KEYBOARDHEIGHT-KBMarginY*2-charMarginY*3)/4;
    // 字母
    UIFont *titleFont = KBFont(FontSize);
    UIColor *titleColor = BtnTitleColor;
    // 背景色
    UIColor *bgColor = BtnBgColor;
    UIImage *bgImg = [UIImage imageWithColor:bgColor];
    // 第一行的Y值
    CGFloat cur_y = TITLEHEIGHT+KBMarginY;
    
    int n = 0;
    // 处理背景图片
    UIImage *charbgImg = [bgImg drawRectWithRoundCorner:CHAR_CORNER toSize:CGSizeMake(char_width, char_heigh)];
    for (int i = 0 ; i < len; i ++)
    {
        CGRect bounds = CGRectMake(charMarginX*0.5+(char_width+charMarginX)*i, cur_y, char_width, char_heigh);
        TBCharButton *btn = [TBCharButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        btn.exclusiveTouch = true;
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setBackgroundImage:charbgImg forState:UIControlStateNormal];
        [btn setTag:n+i];
        
        [self setBtnShadow:btn];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(characterTouchAction:) forControlEvents:UIControlEventTouchDown];
    }
    // 10
    n+=len;
    
    //第二排
    cur_y += char_heigh+charMarginY;
    loc = [[rangs objectAtIndex:0] integerValue];
    length = [[rangs objectAtIndex:1] integerValue];
    // 第二排的字符
    chars = [charSets subarrayWithRange:NSMakeRange(loc, length-loc)];
    len = [chars count];
    CGFloat start_x = (NHSCREEN_WIDTH-char_width*len-charMarginX*(len-1))/2;
    
    for (int i = 0 ; i < len; i ++)
    {
        CGRect bounds = CGRectMake(start_x+(char_width+charMarginX)*i, cur_y, char_width, char_heigh);
        TBCharButton *btn = [TBCharButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        
        btn.exclusiveTouch = true;
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setBackgroundImage:charbgImg forState:UIControlStateNormal];
        [btn setTag:n+i];
        
        [self setBtnShadow:btn];
        [btn addTarget:self action:@selector(characterTouchAction:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
    }
    // 29、30
    n+=len;
    
    //第三排
    cur_y += char_heigh+charMarginY;
    loc = [[rangs objectAtIndex:1] integerValue];
    length = [[rangs objectAtIndex:2] integerValue];
    chars = [charSets subarrayWithRange:NSMakeRange(loc, length-loc)];
    
    len = [chars count];
    // 特殊宽度
    CGFloat shiftWidth = char_width*1.5;
    // 除去2个特殊宽度 和 4个间距  其中2个0.5左右前后 2个1.5为特殊按钮和普通的间距
    char_width = (NHSCREEN_WIDTH-charMarginX*4-shiftWidth*2-charMarginX*(len-1))/len;
    // 重新生成图片
    charbgImg = [bgImg drawRectWithRoundCorner:CHAR_CORNER toSize:CGSizeMake(char_width, char_heigh)];
    CGRect bounds;
    UIButton *btn;
    if (init)// 如果是初始化 需要创建shift 不然不用管
    {
        // shift
        UIImage *roundImg = [bgImg drawRectWithRoundCorner:CHAR_CORNER toSize:CGSizeMake(shiftWidth, char_heigh)];
        bounds = CGRectMake(charMarginX*0.5, cur_y, shiftWidth, char_heigh);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        
        btn.exclusiveTouch = true;
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        if (self.shiftEnable) {
            [btn setImage:[UIImage imageNamed:@"TBKeyboardImages.bundle/shift_select.png"] forState:UIControlStateNormal];
        } else {
            [btn setImage:[UIImage imageNamed:@"TBKeyboardImages.bundle/shift_unselect.png"] forState:UIControlStateNormal];
        }
        [btn setBackgroundImage:roundImg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shiftAction:) forControlEvents:UIControlEventTouchUpInside];
        [self setBtnShadow:btn];
        
        [self addSubview:btn];
        self.shiftBtn = btn;
        
        // delete
        bounds = CGRectMake(NHSCREEN_WIDTH-charMarginX*0.5-shiftWidth, cur_y, shiftWidth, char_heigh);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        btn.exclusiveTouch = true;
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"TBKeyboardImages.bundle/delete.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:roundImg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setBtnShadow:btn];
        
        [self addSubview:btn];
    }
    
    for (int i = 0 ; i < len; i ++)
    {
        // 0.5+1.5 + shiftW + 正常的算法（charW+Margin）
        CGRect bounds = CGRectMake(charMarginX*2+shiftWidth+(char_width+charMarginX)*i, cur_y, char_width, char_heigh);
        TBCharButton *btn = [TBCharButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        btn.exclusiveTouch = true;
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setBackgroundImage:charbgImg forState:UIControlStateNormal];
        [btn setTag:n+i];
        [self setBtnShadow:btn];
        [btn addTarget:self action:@selector(characterTouchAction:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
    }
    
    //第四排
    if (init) {
        cur_y += char_heigh+charMarginY;
        // #+123
        CGFloat symbolWidth = shiftWidth*2;
        UIImage *roundImg = [bgImg drawRectWithRoundCorner:CHAR_CORNER toSize:CGSizeMake(symbolWidth, char_heigh)];
        bounds = CGRectMake(charMarginX*0.5, cur_y, symbolWidth, char_heigh);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        btn.exclusiveTouch = true;
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setTitle:@".?123" forState:UIControlStateNormal];
        [btn setBackgroundImage:roundImg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(charSymbolSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [self setBtnShadow:btn];
        
        [self addSubview:btn];
        self.charSymSwitch = btn;
        // 完成按钮
        bounds = CGRectMake(NHSCREEN_WIDTH-charMarginX*0.5-symbolWidth, cur_y, symbolWidth, char_heigh);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        btn.exclusiveTouch = true;
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setTitle:@"Done" forState:UIControlStateNormal];
        [btn setBackgroundImage:roundImg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setBtnShadow:btn];
        
        [self addSubview:btn];
        // space 前后0.5 中间2
        CGFloat spaceWidth = (NHSCREEN_WIDTH-charMarginX*3-symbolWidth*2);
        bounds = CGRectMake(charMarginX*1.5+symbolWidth, cur_y, spaceWidth, char_heigh);
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = bounds;
        btn.exclusiveTouch = true;
        btn.titleLabel.font = titleFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.textColor = titleColor;
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setTitle:@"space" forState:UIControlStateNormal];
        [btn setBackgroundImage:roundImg forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(charSpaceAction:) forControlEvents:UIControlEventTouchUpInside];
        [self setBtnShadow:btn];
        
        [self addSubview:btn];
    }
    // 设置符号
    [self setCharactersText:charSets];
}

// 设置键盘符号
- (void)setBtnShadow:(UIButton *)btn
{
    btn.layer.shadowColor = [UIColor colorWithWhite:0.1 alpha:1.0].CGColor;
    btn.layer.shadowOffset = CGSizeMake(0, 0.5);
    btn.layer.shadowOpacity = 0.8;
    btn.layer.shadowRadius = 0.8;
    //设定路径：与视图的边界相同
    // 使用shadowPath 性能
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(CHAR_CORNER, CHAR_CORNER)];
    btn.layer.shadowPath = path.CGPath;//路径默认为 nil
    //    btn.clipsToBounds = NO;
}

// 设置键盘符号
- (void)setCharactersText:(NSArray *)array
{
    NSInteger len = [array count];
    if (!array || len == 0)
    {
        return;
    }
    NSArray *subviews = self.subviews;
    [subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && [obj isKindOfClass:[TBCharButton class]]) {
            TBCharButton *tmp = (TBCharButton *)obj;
            NSInteger btnTag = tmp.tag;
            if (btnTag < len)
            {
                NSString *tmpTitle = [array objectAtIndex:btnTag];
                if (self.showSymbol) // 是否是符号
                {
                    [tmp updateChar:tmpTitle];
                }
                else // 字母需要考虑大小写
                {
                    [tmp updateChar:tmpTitle shift:self.shiftEnable];
                }
            }
        }
    }];
    
}

#pragma mark - 字母键盘事件

// #+123-ABC   字母 符号切换
- (void)charSymbolSwitch:(UIButton *)btn
{
    self.showSymbol = !self.showSymbol;
    NSString *title = self.showSymbol?@"ABC":@".?123";
    [self.charSymSwitch setTitle:title forState:UIControlStateNormal];
    // 修改shift
    [self updateShiftBtnTitleState];
    // 重新设置按键
    [self setupABCLayout:NO];
}


// shift 、#+=-123 按键
- (void)shiftAction:(UIButton *)btn
{
    if (self.showSymbol)
    {
        // 显示字符时  切换更多还是123
        self.showMoreSymbol = !self.showMoreSymbol;
        [self updateShiftBtnTitleState];
        NSArray *symbols = self.showMoreSymbol?moreSymbols:Symbols;
        // 不用重新设置按键 设置文本即可
        [self setCharactersText:symbols];
    }
    else // 非符号 切换大小写
    {
        self.shiftEnable = !self.shiftEnable;
        NSArray *subChars = [self subviews];
        [self updateShiftBtnTitleState];
        [subChars enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[TBCharButton class]]) {
                TBCharButton *tmp = (TBCharButton *)obj;
                [tmp updateChar:tmp.chars shift:self.shiftEnable];
            }
        }];
    }
}

// 更新shift的title
- (void)updateShiftBtnTitleState
{
    NSString *title ;
    if (self.showSymbol) {
        title = self.showMoreSymbol?@"123":@"#+=";
        [self.shiftBtn setTitle:title forState:UIControlStateNormal];
        [self.shiftBtn setImage:nil forState:UIControlStateNormal];
    } else {
        [self.shiftBtn setTitle:@"" forState:UIControlStateNormal];
        if (self.shiftEnable) {
            [self.shiftBtn setImage:[UIImage imageNamed:@"TBKeyboardImages.bundle/shift_select.png"] forState:UIControlStateNormal];
        } else {
            [self.shiftBtn setImage:[UIImage imageNamed:@"TBKeyboardImages.bundle/shift_unselect.png"] forState:UIControlStateNormal];
        }
    }
    
}

#pragma mark - 字母键盘功能键事件

// 字符按键 是加在view的触摸事件上的 【还可以给self添加一个长按手势，根据触摸点改变popView】
- (void)characterTouchAction:(TBCharButton *)btn
{
    NSString *content = [btn titleLabel].text;
    if (self.inputSource) {
        // 设置浮标
        if (!self.isHideBuoy) {
            // 立刻移除上一个按钮的浮标
            if (self.frontBtn && self.frontBtn.subviews.count == 3) {
                [[self.frontBtn.subviews lastObject] removeFromSuperview];
            }
            // 如果已经显示浮标则先移除
            if (btn.subviews.count == 3) {
                [[btn.subviews lastObject] removeFromSuperview];
            }
            
            if (CGRectContainsPoint(btn.frame, CGPointMake(btn.frame.origin.x, btn.frame.origin.y))) {
                [btn addPopup];
            }
            // 0.15秒后移除按钮的浮标
            [self performSelector:@selector(removeButtonBuoy:) withObject:btn afterDelay:0.15f];
        }
        
        // 设置输入内容
        [self setSafeTextFieldContent:content];
        self.frontBtn = btn;
    }
}

- (void)charSpaceAction:(UIButton *)btn {
    NSString *content = @" ";
    if (self.inputSource) {
        // 设置输入内容
        [self setSafeTextFieldContent:content];
    }
}

- (void)doneClick:(UIButton *)btn {
    if (self.inputSource) {
        if ([self.inputSource isKindOfClass:[UITextField class]]) {
            UITextField *tmp = (UITextField *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
                BOOL ret = [tmp.delegate textFieldShouldEndEditing:tmp];
                [tmp endEditing:ret];
            } else {
                [tmp resignFirstResponder];
            }
            
        } else if ([self.inputSource isKindOfClass:[UITextView class]]){
            UITextView *tmp = (UITextView *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
                BOOL ret = [tmp.delegate textViewShouldEndEditing:tmp];
                [tmp endEditing:ret];
            } else {
                [tmp resignFirstResponder];
            }
            
        } else if ([self.inputSource isKindOfClass:[UISearchBar class]]){
            UISearchBar *tmp = (UISearchBar *)self.inputSource;
            
            if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
                BOOL ret = [tmp.delegate searchBarShouldEndEditing:tmp];
                [tmp endEditing:ret];
            } else {
                [tmp resignFirstResponder];
            }
        }
    }
}

#pragma mark - 移除字符按钮的浮标
-(void)removeButtonBuoy:(UIButton *)btn {
    if (btn.subviews.count == 3) {
        [[btn.subviews lastObject] removeFromSuperview];
    }
}

#pragma mark - 创建数字键盘
/**
 *  创建数字键盘
 *  @param decimal 是否支持小数
 */
- (void)setUpNumberPad:(BOOL)decimal
{
    if (self.type != SafeKeyboardTypeABC)
    {
        int cols = 3;
        int rows = 4;
        UIColor *borderColor = BtnBoardColor;
        UIColor *titleColor = BtnTitleColor;
        UIColor *highlightedColor = BtnTitleColor;
        UIFont *titleFont = KBFont(FontSize);
        CGFloat itemH = KEYBOARDHEIGHT/rows;
        CGFloat itemW = NHSCREEN_WIDTH/cols;
        NSMutableArray *numkeys = [NSMutableArray array];
        for (int i = 0; i < rows; i++)
        {
            // 采用2个for  也可以用rows*cols 1个for
            for (int j = 0; j < cols; j++)
            {
                CGRect bounds = CGRectMake(j*itemW, i*itemH+TITLEHEIGHT, itemW, itemH);
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                //                [btn setHighlighted:true];
                btn.exclusiveTouch = true;
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = borderColor.CGColor;
                btn.frame = bounds;
                btn.titleLabel.font = titleFont;
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.titleLabel.textColor = titleColor;
                [btn setTitleColor:titleColor forState:UIControlStateNormal];
                [btn setTitleColor:highlightedColor forState:UIControlStateHighlighted];
                [btn setBackgroundImage:[UIImage imageWithColor:NumBtnBgColor] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageWithColor:BtnHighlightColor] forState:UIControlStateHighlighted];
                
                NSInteger btnIndex = i*(rows-1)+j;
                btn.tag = btnIndex;
                
                SEL selector;
                if (btnIndex == 9)
                {
                    selector = decimal?@selector(numberPadClick:):@selector(deleteClick:);
                } else if (btnIndex == 11) {
                    selector = decimal?@selector(deleteClick:):@selector(doneClick:);
                } else {
                    selector = @selector(numberPadClick:);
                }
                
                [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
                
                [numkeys addObject:btn];
                
            }
        }
        self.numKeys = numkeys;
        [self setRandomNumberText];
    }
}

// 设置数字键盘文字
- (void)setRandomNumberText
{
    BOOL isDecimal = self.type == SafeKeyboardTypeNum?NO:YES;
    NSMutableArray *numbers = [NSMutableArray array];
    
    int startNum = 0;
    int length = 10;
    
    // 0-9 string
    for (int i = startNum; i < length; i++)
    {
        [numbers addObject:[NSString stringWithFormat:@"%d", i]];
    }
    if (isDecimal)
    {
        [numbers addObject:@"."];
    }
    for (int i = 0; i < self.numKeys.count; i++)
    {
        UIButton *button = self.numKeys[i];
        
        if (i == 9) {
            if (!isDecimal) {
                [button setImage:[UIImage imageNamed:@"TBKeyboardImages.bundle/delete.png"] forState:UIControlStateNormal];
                continue;
            }
        } else if (i == 11) {
            if (isDecimal) {
                [button setImage:[UIImage imageNamed:@"TBKeyboardImages.bundle/delete.png"] forState:UIControlStateNormal];
            } else {
                [button setTitle:@"Done" forState:UIControlStateNormal];
            }
            continue;
        }
        
        // 0-9 + .
        int index = arc4random() % numbers.count;
        // 换成索引
        [button setTitle:numbers[index] forState:UIControlStateNormal];
        // count减少
        [numbers removeObjectAtIndex:index];
    }
}

#pragma mark - 数字键盘点击事件

/**
 *  数字键盘按键
 *
 *  @param numBtn numBtn description
 */
- (void)numberPadClick:(UIButton *)numBtn
{
    NSString *content = [numBtn titleLabel].text;
    if (self.inputSource) {
        // 设置输入内容
        [self setSafeTextFieldContent:content];
    }
}

#pragma mark - 删除操作
-(void)deleteClick:(UIButton *)deleteBtn {
    if (self.inputSource)
    {
        if ([self.inputSource isKindOfClass:[UITextField class]])
        {
            UITextField *tmp = (UITextField *)self.inputSource;
            [tmp deleteBackward];
            
        } else if ([self.inputSource isKindOfClass:[UITextView class]]) {
            UITextView *tmp = (UITextView *)self.inputSource;
            [tmp deleteBackward];
            
        } else if ([self.inputSource isKindOfClass:[UISearchBar class]]) {
            UISearchBar *tmp = (UISearchBar *)self.inputSource;
            NSMutableString *info = [NSMutableString stringWithString:tmp.text];
            if (info.length > 0)
            {
                NSString *s = [info substringToIndex:info.length-1];
                [tmp setText:s];
            }
        }
    }
}

#pragma mark - getter setter
// 标题
- (UILabel *)iconLabel
{
    if (!_iconLabel)
    {
        _iconLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _iconLabel.backgroundColor = [UIColor clearColor];
        // 比数字小一点
        _iconLabel.font = KBFont(FontSize-5);
        _iconLabel.textColor = TitleColor;
        _iconLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_iconLabel];
    }
    return _iconLabel;
}

// 计算title的位置
- (void)setEnterprise:(NSString *)enterprise
{
    if (enterprise.length > 0)
    {
        _enterprise = [enterprise copy];
        // logo 其实这就是宽高
        CGFloat icon_w_h = ICONHEIGHT;
        // title w
        CGFloat width = [self widthForInfo:enterprise];
        // logow 宽高+0.5宽高+宽度
        CGFloat wwww = icon_w_h*1.5+width;
        // 一半 居中
        CGFloat start_x = (NHSCREEN_WIDTH-wwww)*0.5+icon_w_h*1.5;
        // y轴 上0.25 logo0.5 线间隔还剩0.25
        CGRect bounds = CGRectMake(start_x, TITLEHEIGHT*0.25, width, TITLEHEIGHT*0.5);
        self.iconLabel.frame = bounds;
        self.iconLabel.text = enterprise;
        // logo的frame 间距是0.5的宽高
        bounds.origin.x -= icon_w_h*1.5;
        bounds.size = CGSizeMake(icon_w_h, icon_w_h);
    }
}

// 字符串的宽度
- (CGFloat)widthForInfo:(NSString *)info
{
    if (info.length == 0)
    {
        return 0;
    }
    NSDictionary *attributs = [NSDictionary dictionaryWithObjectsAndKeys:KBFont(FontSize - 5), NSFontAttributeName, nil];
    return [info sizeWithAttributes:attributs].width;
}

#pragma mark - 设置输入框内容(显示密文，返回明文)
-(void)setSafeTextFieldContent:(NSString *)content {
    if ([self.inputSource isKindOfClass:[UITextField class]]) {
        UITextField *tmp = (UITextField *)self.inputSource;
        
        if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            NSRange range = NSMakeRange(tmp.text.length, 1);
            BOOL ret = [tmp.delegate textField:tmp shouldChangeCharactersInRange:range replacementString:content];
            if (ret) {
//                [tmp insertText:content];
            }
        } else {
//            [tmp insertText:content];
        }
        
    } else if ([self.inputSource isKindOfClass:[UITextView class]]){
        UITextView *tmp = (UITextView *)self.inputSource;
        
        if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            NSRange range = NSMakeRange(tmp.text.length, 1);
            BOOL ret = [tmp.delegate textView:tmp shouldChangeTextInRange:range replacementText:content];
            if (ret) {
                [tmp insertText:content];
            }
        } else {
            [tmp insertText:content];
        }
        
    } else if ([self.inputSource isKindOfClass:[UISearchBar class]]){
        UISearchBar *tmp = (UISearchBar *)self.inputSource;
        NSMutableString *info = [NSMutableString stringWithString:tmp.text];
        [info appendString:content];
        
        if (tmp.delegate && [tmp.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
            NSRange range = NSMakeRange(tmp.text.length, 1);
            BOOL ret = [tmp.delegate searchBar:tmp shouldChangeTextInRange:range replacementText:content];
            if (ret) {
                [tmp setText:[info copy]];
            }
        } else {
            [tmp setText:[info copy]];
        }
    }
}

@end
