//
//  CommonUtils+Custom.m
//  futongdai
//
//  Created by 熊彬 on 16/3/9.
//  Copyright © 2016年 OFIM. All rights reserved.
//

#import "CommonUtils+Custom.h"

@implementation CommonUtils (Custom)


+(void)saveValueInUD:(id)value forKey:(NSString *)key{
    if(!value){
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:key];
    [ud synchronize];
}


+(void)saveIntValueInUD:(NSInteger)value forKey:(NSString *)key{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:value forKey:key];
    [ud synchronize];
}

+(void)saveBoolValueInUD:(BOOL)value forKey:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:key];
    [ud synchronize];
}

+(void)saveStrValueInUD:(NSString *)str forKey:(NSString *)key{
    if(!str){
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:str forKey:key];
    [ud synchronize];
}


+(void)saveDateValueInUD:(NSDate *)date forKey:(NSString *)key{
    if(!date){
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:date forKey:key];
    [ud synchronize];
}

+(void)saveDicValueInUD:(NSDictionary *)dic forKey:(NSString *)key{
    if(!dic){
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:dic forKey:key];
    [ud synchronize];
}

+ (void)saveArrValueInUD:(NSArray *)arr forKey:(NSString *)key
{
    if(!arr){
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:arr forKey:key];
    [ud synchronize];
}

+ (void)saveDataValueInUD:(NSData *)data forKey:(NSString *)key
{
    if(!data){
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:data forKey:key];
    [ud synchronize];
}
+(void)removeValueInUDWithKey:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:key];
    [ud synchronize];
}

+(NSString *)getStrValueInUDWithKey:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud stringForKey:key];
}

+(NSInteger )getIntValueInUDWithKey:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud integerForKey:key];
}

+(BOOL)getBoolValueInUDWithKey:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:key];
}


+(NSDictionary *)getDicValueInUDWithKey:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud dictionaryForKey:key];
}
+ (NSArray *)getArrValueInUDWithKey:(NSString *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud arrayForKey:key];
}

+(NSDate *)getDateValueInUDWithKey:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud valueForKey:key];
}

+(id)getValueInUDWithKey:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud valueForKey:key];
    
}

+ (NSData *)getdataValueInUDWithKey:(NSString *)key
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud dataForKey:key];
}

+ (UIColor *)getColor:(NSString*)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}

+(UIColor *)getCommonBgColor{
    return [self getColor:@"efeff4"];

}


+(UIColor *)getNewCommonBgColor{
    return [self getColor:@"f2f2f2"];
    
}


+(UIColor *)getCommonPinkColor{
    return [UIColor colorWithRed:250/255.0 green:45/255.0 blue:101/255.0 alpha:1];
    
}
+(UIColor *)getCommonOrangeColor
{
    return [UIColor colorWithRed:250/255.0 green:84/255.0 blue:10/255.0 alpha:1];
}

+(UIColor *)getCommonSepLineColor{
    return [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2];
}

+(UIColor *)getCommonBorderColor{
    return [self getColor:@"c8c7cc"];
}

+(UIColor *)getCommonDarkGrayColor{
    return [self getColor:@"292828"];
}

+(UIColor *)getCommonLightGrayColor{
    return [self getColor:@"5c5c5c"];
}

+(UIColor *)getCommonBlueColor{
    return [self getColor:@"007aff"];
}

+(UIColor *)getCommonNewGreenColor{
    return [self getColor:@"06c7a5"];
}

+(UIColor *)getCommonNewLightGrayColor{
    return [self getColor:@"08bca0"];
}

+(UIColor *)getCommonNavBlueColor{
    return [UIColor colorWithRed:32/255.0 green:141/255.0 blue:228/255.0 alpha:1.0];
}

+(UIColor *)getCommonTagBgColor{
    return [self getColor:@"f5f3fc"];
}

+(UIColor *)getCommonNavBarColor{
    return [UIColor colorWithRed:62/255.0 green:175/255.0 blue:245/255.0 alpha:1.0];
}

+(UIColor *)getCommonGreenColor{
    return [UIColor colorWithRed:14/155.0 green:153/255.0 blue:12/255.0 alpha:1.0];
}

#pragma mark - add by lam
/// string 转 int
+ (NSInteger)trimIntValue:(NSString *)sender{
    if([sender isKindOfClass:[NSNull class]] || !sender){
        return -1;
        
    }else if([@"" isEqualToString:sender]){
        return 0;
        
    }else{
        return [sender integerValue];
    }
}

+ (NSString *)trimStringValue:(NSString *)sender{
    if([sender isKindOfClass:[NSNull class]] || !sender){
        return @"";
        
    }else{
        return sender;
    }
}

///归档
+ (void)keyedArchiverObject:(id)object ForKey:(NSString *)key ToFile:(NSString *)path
{
    NSMutableData *md=[NSMutableData data];
    NSKeyedArchiver *arch=[[NSKeyedArchiver alloc]initForWritingWithMutableData:md];
    [arch encodeObject:object forKey:key];
    [arch finishEncoding];
    [md writeToFile:path atomically:YES];
}

///反归档
+ (NSArray *)keyedUnArchiverForKey:(NSString *)key FromFile:(NSString *)path
{
    NSData *data=[NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver *unArch=[[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSArray *arr = [unArch decodeObjectForKey:key];
    return arr;
}


@end
