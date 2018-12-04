//
//  TBCharButton.m
//  TBBusiness
//
//  Created by Apple on 2018/6/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBCharButton.h"
#define scaleW [UIScreen mainScreen].bounds.size.width/320
#define scaleH [UIScreen mainScreen].bounds.size.height/568

#define KBFont(s) [UIFont fontWithName:@"HelveticaNeue-Light" size:s]

#define _UPPER_WIDTH   (50.0 * [[UIScreen mainScreen] scale])
#define _LOWER_WIDTH   (30.0 * [[UIScreen mainScreen] scale])

#define _PAN_UPPER_RADIUS  (7.0 * [[UIScreen mainScreen] scale])
#define _PAN_LOWER_RADIUS  (7.0 * [[UIScreen mainScreen] scale])

#define _PAN_UPPDER_WIDTH   (_UPPER_WIDTH-_PAN_UPPER_RADIUS*2)
#define _PAN_UPPER_HEIGHT    (60.0 * [[UIScreen mainScreen] scale])

#define _PAN_LOWER_WIDTH     (_LOWER_WIDTH-_PAN_LOWER_RADIUS*2)
#define _PAN_LOWER_HEIGHT    (30.0 * [[UIScreen mainScreen] scale])

#define _PAN_UL_WIDTH        ((_UPPER_WIDTH-_LOWER_WIDTH)/2)

#define _PAN_MIDDLE_HEIGHT    (11.0 * [[UIScreen mainScreen] scale])

#define _PAN_CURVE_SIZE      (7.0 * [[UIScreen mainScreen] scale])

#define _PADDING_X     (15 * [[UIScreen mainScreen] scale])
#define _PADDING_Y     (11 * [[UIScreen mainScreen] scale])
#define _WIDTH   (_UPPER_WIDTH + _PADDING_X*2)
#define _HEIGHT   (_PAN_UPPER_HEIGHT + _PAN_MIDDLE_HEIGHT + _PAN_LOWER_HEIGHT + _PADDING_Y*2)

// 按键文字颜色
#define BtnTitleColor RGB(0,0,0)
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define _OFFSET_X    -20 * [[UIScreen mainScreen] scale])
#define _OFFSET_Y    59 * [[UIScreen mainScreen] scale])
@implementation TBCharButton

// 更新字符
- (void)updateChar:(nullable NSString *)chars
{
    if (chars.length > 0)
    {
        _chars = [chars copy];
        [self updateTitleState];
    }
}

// 更新字符 并需更新最新的大小写状态
- (void)updateChar:(nullable NSString *)chars shift:(BOOL)shift
{
    if (chars.length > 0)
    {
        _chars = [chars copy];
        self.isShift = shift;
        [self updateTitleState];
    }
}

// 更新按钮字符
- (void)updateTitleState
{
    // 转大小写
    NSString *tmp = self.isShift?[self.chars uppercaseString]:[self.chars lowercaseString];
    if ([[NSThread currentThread] isMainThread]) {
        [self setTitle:tmp forState:UIControlStateNormal];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle:tmp forState:UIControlStateNormal];
        });
    }
}

// 遮罩层
- (void)addPopup
{
    UIImageView *keyPop;
    CGFloat scale = [UIScreen mainScreen].scale;
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(_PADDING_X/scale*scaleW, _PADDING_Y/scale, _UPPER_WIDTH/scale*scaleW, _PAN_UPPER_HEIGHT/scale)];
    
    if ([self.chars isEqualToString:@"q"] ||
        [self.chars isEqualToString:@"1"] ||
        [self.chars isEqualToString:@"-"] ||
        [self.chars isEqualToString:@"["] ||
        [self.chars isEqualToString:@"_"])
    {
        keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:NHKBImageRight] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
        keyPop.frame = CGRectMake(-16*scaleW, -71, keyPop.frame.size.width*scaleW, keyPop.frame.size.height);
    
    } else if ([self.chars isEqualToString:@"p"] ||
               [self.chars isEqualToString:@"0"] ||
               [self.chars isEqualToString:@"\""]||
               [self.chars isEqualToString:@"="] ||
               [self.chars isEqualToString:@"•"])
    {
        keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:NHKBImageLeft] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
        keyPop.frame = CGRectMake(-38*scaleW, -71, keyPop.frame.size.width*scaleW, keyPop.frame.size.height);
        
    } else if ([self.chars isEqualToString:@"."] ||
               [self.chars isEqualToString:@","] ||
               [self.chars isEqualToString:@"?"] ||
               [self.chars isEqualToString:@"!"] ||
               [self.chars isEqualToString:@"'"])
    {
        keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:NHKBImageInner] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
        float dWidth = 4*scaleW;
        text.frame = CGRectMake(text.frame.origin.x+dWidth, text.frame.origin.y, text.frame.size.width, text.frame.size.height);
        keyPop.frame = CGRectMake(-(20*scaleW+dWidth), -71, keyPop.frame.size.width*scaleW+2*dWidth, keyPop.frame.size.height);
        
    } else {
        keyPop = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[self createKeytopImageWithKind:NHKBImageInner] scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationDown]];
        keyPop.frame = CGRectMake(-27*scaleW, -71, keyPop.frame.size.width*scaleW, keyPop.frame.size.height);
    }
    
    NSString *tmp = self.isShift?[self.chars uppercaseString]:[self.chars lowercaseString];
    [text setFont:KBFont(44)];
    [text setTextColor:BtnTitleColor];
    [text setTextAlignment:NSTextAlignmentCenter];
    [text setBackgroundColor:[UIColor clearColor]];
    [text setShadowColor:[UIColor whiteColor]];
    [text setText:tmp];
    
    keyPop.layer.shadowColor = [UIColor colorWithWhite:0.1 alpha:1.0].CGColor;
    keyPop.layer.shadowOffset = CGSizeMake(0, 3.0);
    keyPop.layer.shadowOpacity = 1;
    keyPop.layer.shadowRadius = 5.0;
    keyPop.clipsToBounds = NO;
    
    [keyPop addSubview:text];
    [self addSubview:keyPop];
    [[self superview] bringSubviewToFront:self];
}

/**
 *  生成遮罩图片
 *
 *  @param kind 左中右
 *
 *  @return return value description
 */
- (CGImageRef)createKeytopImageWithKind:(int)kind
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPoint p = CGPointMake(_PADDING_X, _PADDING_Y);
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointZero;
    
    p.x += _PAN_UPPER_RADIUS;
    CGPathMoveToPoint(path, NULL, p.x, p.y);
    
    p.x += _PAN_UPPDER_WIDTH;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.y += _PAN_UPPER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_UPPER_RADIUS,
                 3.0*M_PI/2.0,
                 4.0*M_PI/2.0,
                 false);
    
    p.x += _PAN_UPPER_RADIUS;
    p.y += _PAN_UPPER_HEIGHT - _PAN_UPPER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p1 = CGPointMake(p.x, p.y + _PAN_CURVE_SIZE);
    switch (kind) {
        case NHKBImageLeft:
            p.x -= _PAN_UL_WIDTH*2;
            break;
            
        case NHKBImageInner:
            p.x -= _PAN_UL_WIDTH;
            break;
            
        case NHKBImageRight:
            break;
    }
    
    p.y += _PAN_MIDDLE_HEIGHT + _PAN_CURVE_SIZE*2;
    p2 = CGPointMake(p.x, p.y - _PAN_CURVE_SIZE);
    CGPathAddCurveToPoint(path, NULL,
                          p1.x, p1.y,
                          p2.x, p2.y,
                          p.x, p.y);
    
    p.y += _PAN_LOWER_HEIGHT - _PAN_CURVE_SIZE - _PAN_LOWER_RADIUS;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.x -= _PAN_LOWER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_LOWER_RADIUS,
                 4.0*M_PI/2.0,
                 1.0*M_PI/2.0,
                 false);
    
    p.x -= _PAN_LOWER_WIDTH;
    p.y += _PAN_LOWER_RADIUS;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.y -= _PAN_LOWER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_LOWER_RADIUS,
                 1.0*M_PI/2.0,
                 2.0*M_PI/2.0,
                 false);
    
    p.x -= _PAN_LOWER_RADIUS;
    p.y -= _PAN_LOWER_HEIGHT - _PAN_LOWER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p1 = CGPointMake(p.x, p.y - _PAN_CURVE_SIZE);
    
    switch (kind) {
        case NHKBImageLeft:
            break;
            
        case NHKBImageInner:
            p.x -= _PAN_UL_WIDTH;
            break;
            
        case NHKBImageRight:
            p.x -= _PAN_UL_WIDTH*2;
            break;
    }
    
    p.y -= _PAN_MIDDLE_HEIGHT + _PAN_CURVE_SIZE*2;
    p2 = CGPointMake(p.x, p.y + _PAN_CURVE_SIZE);
    CGPathAddCurveToPoint(path, NULL,
                          p1.x, p1.y,
                          p2.x, p2.y,
                          p.x, p.y);
    
    p.y -= _PAN_UPPER_HEIGHT - _PAN_UPPER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.x += _PAN_UPPER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_UPPER_RADIUS,
                 2.0*M_PI/2.0,
                 3.0*M_PI/2.0,
                 false);
    
    CGContextRef context;
    UIGraphicsBeginImageContext(CGSizeMake(_WIDTH,
                                           _HEIGHT));
    context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, _HEIGHT);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    // 浮标颜色
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGFloat components[] = {
        1.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 1.0f};
    
    size_t count = sizeof(components)/ (sizeof(CGFloat)* 2);
    
    CGRect frame = CGPathGetBoundingBox(path);
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = frame.origin;
    endPoint.y = frame.origin.y + frame.size.height;
    // 渐变色
    CGGradientRef gradientRef =
    CGGradientCreateWithColorComponents(colorSpaceRef, components, NULL, count);
    
    CGContextDrawLinearGradient(context,
                                gradientRef,
                                startPoint,
                                endPoint,
                                kCGGradientDrawsBeforeStartLocation);
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();
    
    CFRelease(path);
    
    return imageRef;
}

@end
