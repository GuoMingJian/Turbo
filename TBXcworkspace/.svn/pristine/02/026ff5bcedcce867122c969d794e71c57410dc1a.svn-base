//
//  AddCardViewController.m
//  TBBusiness
//
//  Created by Apple on 2018/10/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "AddCardViewController.h"
#import "CollectionViewController.h"
#import "header.h"

@interface AddCardViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cardNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTopConstraint;

@end

@implementation AddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"注册结果";
    [self createLeftItemWithImg:nil];
    [self hideNavigationBarShadowLine:YES];
    self.topViewTopConstraint.constant = Height_NavBar;
    
    self.nextBtn.enabled = NO;
    self.cardNumTextField.delegate = self;
    [self.cardNumTextField addTarget:self action:@selector(cardNumTextFieldChanged:) forControlEvents:(UIControlEventEditingChanged)];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
-(void)cardNumTextFieldChanged:(UITextField *)cardNumTextField {
    if (cardNumTextField.text.length == 0) {
        [self setNextBtnEnabled:NO];
    } else {
        [self setNextBtnEnabled:YES];
    }
}

#pragma mark -
- (IBAction)nextBtnClick:(UIButton *)sender {
    CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
    [self.navigationController pushViewController:collectionVC animated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= 19) {
        return NO;
    }
    return YES;
}

#pragma mark - 
-(void)setNextBtnEnabled:(BOOL)enabled {
    if (enabled) {
        self.nextBtn.enabled = YES;
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
        
    } else {
        self.nextBtn.enabled = NO;
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"unSelectBtn"] forState:UIControlStateNormal];
    }
}

@end
