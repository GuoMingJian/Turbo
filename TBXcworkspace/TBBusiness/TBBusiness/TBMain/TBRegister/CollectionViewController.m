//
//  CollectionViewController.m
//  TBBusiness
//
//  Created by Apple on 2018/10/24.
//  Copyright © 2018年 Apple. All rights reserved.
//expiration

#import "CollectionViewController.h"
#import "TBSafeTextField.h"
#import "ResultViewController.h"
//#import "UIView+TBKeyboardOffset.h"
#import "TBCountDownButton.h"
#import "header.h"
#import "TBRegularExpression.h"

@interface CollectionViewController ()<UITextFieldDelegate, SafeTextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollFrontView;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIImageView *cardImgView;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;//卡类型
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;//卡号
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;//姓名拼音
@property (weak, nonatomic) IBOutlet UILabel *validityLabel;//有效期
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *idTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *idNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *expirationTextField;
@property (weak, nonatomic) IBOutlet TBSafeTextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeNumTextField;
@property (weak, nonatomic) IBOutlet TBCountDownButton *countDownBtn;
// 底部按钮约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@end

@implementation CollectionViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.view openKeyboardOffsetView];
//    self.view.keyboardGap = 25;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"添加银行卡";
    [self createLeftItemWithImg:nil];
    [self hideNavigationBarShadowLine:YES];
    
    self.nextBtn.enabled = NO;
    
    self.nameTextField.delegate = self;
    [self.nameTextField addTarget:self action:@selector(nameTextFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    
    self.idNumTextField.delegate = self;
    [self.idNumTextField addTarget:self action:@selector(idNumTextFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    
    self.expirationTextField.delegate = self;
    [self.expirationTextField addTarget:self action:@selector(expirationTextFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    
    self.pwdTextField.safeTextDelegate = self;
    self.pwdTextField.delegate = self;
    [self.pwdTextField addTarget:self action:@selector(pwdTextFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    
    self.codeNumTextField.delegate = self;
    [self.codeNumTextField addTarget:self action:@selector(codeNumTextFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    if (MAIN_SCREEN_WIDTH <= 320) {
        // 小屏手机
        [self.codeNumTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    }
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.scrollViewTopConstraint.constant = Height_NavBar;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapAction
{
    [self.view endEditing:YES];
}

#pragma mark -
-(void)nameTextFieldChanged:(UITextField *)nameTextField {
    NSString *str = nameTextField.text;
    if (str.length > 0)
    {
        NSString *pinyin = [self transform:str];
        pinyin = [pinyin uppercaseString];
        self.cardNameLabel.text = pinyin;
    }
    else
    {
        self.cardNameLabel.text = @"姓名拼音显示";
    }

    [self checkBtnCanClick];
}

-(void)idNumTextFieldChanged:(UITextField *)idNumTextField {
    [self checkBtnCanClick];
}

-(void)expirationTextFieldChanged:(UITextField *)expirationTextField {
    [self checkBtnCanClick];
}

-(void)pwdTextFieldChanged:(TBSafeTextField *)pwdTextField {
    [self checkBtnCanClick];
}

-(void)codeNumTextFieldChanged:(UITextField *)codeNumTextField {
    [self checkBtnCanClick];
}

#pragma mark -
// 点击完成 键盘消失
-(void)safeTextFieldDidResignFirstResponder:(TBSafeTextField *)textField {
    
}
// 删除字符 inputView需要知道，并传递给web
-(void)safeTextFieldDidDeleteString:(TBSafeTextField *)textField {
    
}
// 回调明文
-(void)plainText:(NSString *)plainStr safeTextField:(TBSafeTextField *)textField {
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.expirationTextField)
    {
        NSString *str = self.expirationTextField.text;
        if (str.length == 4)
        {
            NSString *month = [str substringToIndex:2];
            NSString *day = [str substringFromIndex:2];
            NSString *text = [NSString stringWithFormat:@"%@/%@", month, day];
            //self.expirationTextField.text = text;
            self.validityLabel.text = text;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.nameTextField) {
        if (textField.text.length >= 20) {
            return NO;
        }
        else
        {
            return [TBRegularExpression isChinese:string];
        }
    } else if (textField == self.idNumTextField) {
        if (textField.text.length >= 18) {
            return NO;
        }
        else
        {
            return ![TBRegularExpression isChinese:string];
        }
    } else if (textField == self.expirationTextField) {
        if (textField.text.length >= 4) {
            return NO;
        }
        else
        {
            //BOOL result = ![TBRegularExpression isChinese:string] ||
        }
    } else if (textField == self.codeNumTextField) {
        if (textField.text.length >= 6) {
            return NO;
        }
    }
    
    
    return YES;
}

#pragma mark -
- (IBAction)nextBtnClick:(UIButton *)sender {
    ResultViewController *resultVC = [[ResultViewController alloc] init];
    [self.navigationController pushViewController:resultVC animated:YES];
}

#pragma mark -
- (void)checkBtnCanClick {
    if (self.nameTextField.text.length == 0 ||
        self.idNumTextField.text.length == 0 ||
        self.expirationTextField.text.length == 0 ||
        self.pwdTextField.text.length == 0 ||
        self.codeNumTextField.text.length == 0) {
        [self setNextBtnEnabled:NO];
    } else {
        [self setNextBtnEnabled:YES];
    }
}

-(void)setNextBtnEnabled:(BOOL)enabled {
    if (enabled) {
        self.nextBtn.enabled = YES;
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
        
    } else {
        self.nextBtn.enabled = NO;
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"unSelectBtn"] forState:UIControlStateNormal];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark -
- (IBAction)countBtnClick:(TBCountDownButton *)sender {
    sender.enabled = NO;
    [sender startWithSecond:59];
    [sender didChange:^NSString *(TBCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"%ds重新发送",second];
        return title;
    }];
    [sender didFinished:^NSString *(TBCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"获取验证码";
    }];
}

#pragma mark - private

//汉字转拼音
- (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);

    return pinyin;
}

@end
