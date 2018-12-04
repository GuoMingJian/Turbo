//
//  TBRegularExpression.m
//  TBBusiness
//
//  Created by 郭明健 on 2018/10/29.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "TBRegularExpression.h"

@implementation TBRegularExpression

#pragma mark - Regular Expressions[正则表达式]
//http://deerchao.net/tutorials/regex/regex.htm[正则表达式入门]
//http://gold.xitu.io/entry/571807a88ac247005f117209/promote?utm_source=baidu&utm_medium=keyword&utm_content=regexp&utm_campaign=q3_search[20 个正则表达式]

/**
 判断传入的数据在传入的正则表达式中是否正确
 */
+ (BOOL)isRightExpression:(NSString *)expression
                    value:(NSString *)value
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", expression];
    BOOL isMatch = [pred evaluateWithObject:value];
    if (!isMatch)
    {
        return NO;
    }
    return YES;
}

/**
 手机号[@"^1(3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$"]
 //13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
 http://blog.csdn.net/xlawszero/article/details/52053184
 */
+ (BOOL)isMobileNumber:(NSString *)value
{
    NSString *mobile = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$";
    return [self isRightExpression:mobile value:value];
}

/**
 中国移动(China Mobile)[@"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"]
 //134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
 */
+ (BOOL)isChinaMobile:(NSString *)phoneNum
{
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    return [self isRightExpression:CM value:phoneNum];
}

/**
 中国联通(China Unicom)[@"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"]
 //130,131,132,155,156,185,186,145,176,1709
 */
+ (BOOL)isChinaUnicom:(NSString *)phoneNum
{
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    return [self isRightExpression:CU value:phoneNum];
}

/**
 中国电信(China Telecom)[@"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)"]
 //133,153,180,181,189,177,1700
 */
+ (BOOL)isChinaTelecom:(NSString *)phoneNum
{
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    return [self isRightExpression:CT value:phoneNum];
}

/**
 手机运营商[中国移动,中国联通,中国电信]
 */
+ (NSString *)getPhoneNumType:(NSString *)phoneNum
{
    return [self isChinaMobile:phoneNum]? @"中国移动":
    ([self isChinaUnicom:phoneNum]? @"中国联通":
     ([self isChinaTelecom:phoneNum]? @"中国电信": @"未知"));
}

/**
 是否为邮箱
 */
+ (BOOL)isEmail:(NSString *)email
{
    NSString *emailExp = @"[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?";
    //@"^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$"
    return [self isRightExpression:emailExp value:email];
}

/**
 是否为身份证号[15或18 位]
 */
+ (BOOL)isIdCard:(NSString *)idCard
{
    if (idCard.length == 15)
    {
        NSString *idCard15Exp = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
        return [self isRightExpression:idCard15Exp value:idCard];
    }
    else if (idCard.length == 18)
    {
        NSString *idCard18Exp = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
        return [self isRightExpression:idCard18Exp value:idCard];
    }
    else
    {
        return NO;
    }
}

/**
 加权因子判断身份证号码

 @param idCard 身份证号
 @return 是否为身份证号
 */
+ (BOOL)isIdCard2:(NSString *)idCard
{
    // 判断位数
    if (idCard.length != 15 && idCard.length != 18)
    {
        return NO;
    }

    NSString *carid = idCard;
    long lSumQT = 0;
    // 加权因子
    int R[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    // 校验码
    unsigned char sChecker[11] = {'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};

    // 将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:idCard];
    if (idCard.length == 15)
    {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];

        for (int i = 0; i <= 16; i ++)
        {
            p += (pid[i] - 48) * R[i];
        }

        int o = p % 11;
        NSString *string_content = [NSString stringWithFormat:@"%c", sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }

    // 判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    if (![self areaCode:sProvince])
    {
        return NO;
    }

    // 判断年月日是否有效
    // 年份
    int strYear = [[self substringWithString:carid begin:6 end:4] intValue];
    // 月份
    int strMonth = [[self substringWithString:carid begin:10 end:2] intValue];
    // 日
    int strDay = [[self substringWithString:carid begin:12 end:2] intValue];

    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",
                                                strYear, strMonth, strDay]];
    if (date == nil)
    {
        return NO;
    }

    const char *PaperId  = [carid UTF8String];
    // 检验长度
    if(18 != strlen(PaperId)) return NO;
    // 校验数字
    for (int i = 0; i < 18; i++)
    {
        if (!isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i))
        {
            return NO;
        }
    }

    // 验证最末的校验码
    for (int i = 0; i <= 16; i ++)
    {
        lSumQT += (PaperId[i] - 48) * R[i];
    }

    if (sChecker[lSumQT%11] != PaperId[17])
    {
        return NO;
    }
    return YES;
}

/**
 * 功能:获取指定范围的字符串
 * 参数:字符串的开始小标
 * 参数:字符串的结束下标
 */
+ (NSString *)substringWithString:(NSString *)str begin:(NSInteger)begin end:(NSInteger )end
{
    return [str substringWithRange:NSMakeRange(begin, end)];
}

/**
 * 功能:判断是否在地区码内
 * 参数:地区码
 */
+ (BOOL)areaCode:(NSString *)code
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];

    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    return YES;
}

/**
 是否是中文[@"^[\\u4e00-\\u9fa5]{0,}$"]
 */
+ (BOOL)isChinese:(NSString *)value
{
    NSString *regexp = @"^[\\u4e00-\\u9fa5]{0,}$";
    return [self isRightExpression:regexp value:value];
}

/**
 金额校验，精确到2位小数[@"^[0-9]+(.[0-9]{2})?$"]
 */
+ (BOOL)isMoney:(NSString *)value
{
    NSString *regexp = @"^[0-9]+(.[0-9]{2})?$";
    return [self isRightExpression:regexp value:value];
}

/**
 车牌号码[@"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$"]
 */
+ (BOOL)isCarNo:(NSString *)carNum
{
    NSString *regexp = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    //@"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    return [self isRightExpression:regexp value:carNum];
}

/**
 用户名[字母，数字(长度4-20)]
 */
+ (BOOL)isUserName:(NSString *)username
{
    NSString *regexp = @"^[A-Za-z0-9]{4,20}+$";
    return [self isRightExpression:regexp value:username];
}

/**
 密码[字母，数字(长度6-20)]
 */
+ (BOOL)isPassword:(NSString *)pwd
{
    NSString *regexp = @"^[a-zA-Z0-9]{6,20}+$";
    return [self isRightExpression:regexp value:pwd];
}

@end
