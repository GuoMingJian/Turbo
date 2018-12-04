//
//  TBCountDownButton.m
//  TBBusiness
//
//  Created by Apple on 2018/10/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBCountDownButton.h"

@interface TBCountDownButton ()
{
    UIColor *beforeColor;
    UIColor *nextColor;
}

@end
@implementation TBCountDownButton

#pragma mark - 带圆角的初始化
-(instancetype)initWithFrame:(CGRect)frame andCornerRadius:(CGFloat)radius{
    if(self = [super initWithFrame:frame]){
        self.frame = frame;
        // 圆角
        self.layer.cornerRadius = radius;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.layer.cornerRadius = 5.0f;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

-(void)addToucheHandler:(TouchedDownBlock)touchHandler {
    _touchedDownBlock = [touchHandler copy];
    [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)touched:(TBCountDownButton *)sender {
    if (_touchedDownBlock) {
        _touchedDownBlock(sender,sender.tag);
    }
}

#pragma mark - count down method
-(void)startWithSecond:(int)totalSecond
{
    _totalSecond = totalSecond;
    _second = totalSecond;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    _startDate = [NSDate date];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)timerStart:(NSTimer *)theTimer {
    double deltaTime = [[NSDate date] timeIntervalSinceDate:_startDate];
    _second = _totalSecond - (int)(deltaTime)+1 ;
    if (_second< 1.0){
        [self stop];
    }
    else{
        if (_didChangeBlock){
            [self setTitle:_didChangeBlock(self,_second) forState:UIControlStateNormal];
            [self setTitle:_didChangeBlock(self,_second) forState:UIControlStateDisabled];
        }
        else{
            NSString *title = [NSString stringWithFormat:@"%ds",_second];
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitle:title forState:UIControlStateDisabled];
        }
    }
}

- (void)stop {
    if (_timer) {
        if ([_timer respondsToSelector:@selector(isValid)])
        {
            if ([_timer isValid])
            {
                [_timer invalidate];
                _timer = nil;
                _second = _totalSecond;
                if (_didFinishedBlock)
                {
                    [self setTitle:_didFinishedBlock(self,_totalSecond)forState:UIControlStateNormal];
                    [self setTitle:_didFinishedBlock(self,_totalSecond)forState:UIControlStateDisabled];
                }
            }
        }
    }
}

#pragma mark - 回调
-(void)didChange:(DidChangeBlock)didChangeBlock{
    _didChangeBlock = [didChangeBlock copy];
}
-(void)didFinished:(DidFinishedBlock)didFinishedBlock{
    _didFinishedBlock = [didFinishedBlock copy];
}

#pragma mark - dealloc
- (void)dealloc {
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
