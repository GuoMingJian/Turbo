//
//  TBCountDownButton.h
//  TBBusiness
//
//  Created by Apple on 2018/10/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TBCountDownButton;

typedef NSString* (^DidChangeBlock)(TBCountDownButton *countdownButton,int second);
typedef NSString* (^DidFinishedBlock)(TBCountDownButton *countDownButton,int second);
typedef void (^TouchedDownBlock)(TBCountDownButton *countDownButton,NSInteger tag);

@interface TBCountDownButton : UIButton
{
    int _second;
    int _totalSecond;
    
    NSTimer *_timer;
    NSDate *_startDate;
    
    DidChangeBlock _didChangeBlock;
    DidFinishedBlock _didFinishedBlock;
    TouchedDownBlock _touchedDownBlock;
}

#pragma mark - 带圆角的初始化
-(instancetype)initWithFrame:(CGRect)frame andCornerRadius:(CGFloat)radius;
-(void)addToucheHandler:(TouchedDownBlock)touchHandler;
-(void)didChange:(DidChangeBlock)didChangeBlock;
-(void)didFinished:(DidFinishedBlock)didFinishedBlock;
-(void)startWithSecond:(int)second;
-(void)stop;

@end

NS_ASSUME_NONNULL_END
