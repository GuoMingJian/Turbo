//
//  UIColor+MJExt.m
//  MJFramework
//
//  Created by 郭明健 on 2018/6/2.
//  Copyright © 2018年 GuoMingJian. All rights reserved.
//

#import "UIColor+MJExt.h"

@implementation UIColor (MJExt)

+ (UIColor *)colorWithHex:(NSString *)hexStr
{
    return [self colorWithHex:hexStr alpha:1.0f];
}

+ (UIColor *)colorWithHex:(NSString *)hexStr alpha:(CGFloat)alpha
{
    NSMutableString* color = [NSMutableString stringWithString:hexStr];
    [color replaceCharactersInRange:[color rangeOfString:@"#" ] withString:@"0x"];
    long colorLong = strtoul([color cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    
    return [UIColor colorWithRed:((float)((colorLong & 0xFF0000) >> 16))/255.0
                           green:((float)((colorLong & 0xFF00) >> 8))/255.0
                            blue:((float)(colorLong & 0xFF))/255.0 alpha:alpha];
}

+ (NSString *)hexStringFromUIColor:(UIColor *)color
{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
    NSString *result = [NSString stringWithFormat:@"#%06x", rgb];
    return [result uppercaseString];
}

@end
