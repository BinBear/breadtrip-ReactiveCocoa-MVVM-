//
//  CommonUtils+Custom.h
//  futongdai
//
//  Created by 熊彬 on 16/3/9.
//  Copyright © 2016年 OFIM. All rights reserved.
//

#import "CommonUtils.h"


@interface CommonUtils (Custom)

#pragma  mark - NSUserDefaults存取操作
+(void)saveBoolValueInUD:(BOOL)value forKey:(NSString *)key;
+(void)saveDataValueInUD:(NSData *)data forKey:(NSString *)key;
+(void)saveValueInUD:(id)value forKey:(NSString *)key;
+(void)saveStrValueInUD:(NSString *)str forKey:(NSString *)key;
+(void)saveDicValueInUD:(NSDictionary *)dic forKey:(NSString *)key;
+(void)saveArrValueInUD:(NSArray *)arr forKey:(NSString *)key;
+(void)saveDateValueInUD:(NSDate *)date forKey:(NSString *)key;
+(void)saveIntValueInUD:(NSInteger)value forKey:(NSString *)key;
+(void)removeValueInUDWithKey:(NSString *)key;
+(id)getValueInUDWithKey:(NSString *)key;
+(NSDate *)getDateValueInUDWithKey:(NSString *)key;
+(NSString *)getStrValueInUDWithKey:(NSString *)key;
+(NSInteger )getIntValueInUDWithKey:(NSString *)key;
+(NSDictionary *)getDicValueInUDWithKey:(NSString *)key;
+(NSArray *)getArrValueInUDWithKey:(NSString *)key;
+(NSData *)getdataValueInUDWithKey:(NSString *)key;
+(BOOL)getBoolValueInUDWithKey:(NSString *)key;

#pragma mark - 归档和反归档
+ (void) keyedArchiverObject:(id)object ForKey:(NSString *)key ToFile:(NSString *)path;
+ (NSArray *) keyedUnArchiverForKey:(NSString *)key FromFile:(NSString *)path;

#pragma mark - 获得相应的颜色
+(UIColor *)getColor:(NSString*)hexColor;
+(UIColor *)getCommonBgColor;
+(UIColor *)getCommonBorderColor;
+(UIColor *)getCommonDarkGrayColor;
+(UIColor *)getCommonLightGrayColor;
+(UIColor *)getCommonBlueColor;
+(UIColor *)getCommonNavBlueColor;
+(UIColor *)getCommonNavBarColor;
+(UIColor *)getCommonTagBgColor;
+(UIColor *)getCommonSepLineColor;
+(UIColor *)getCommonGreenColor;
+(UIColor *)getCommonNewGreenColor;
+(UIColor *)getCommonNewLightGrayColor;
+(UIColor *)getNewCommonBgColor;
+(UIColor *)getCommonPinkColor;
+(UIColor *)getCommonOrangeColor;

#pragma mark - string & int trim
/// string --> int
+ (NSInteger)trimIntValue:(NSString *)sender;
+ (NSString *)trimStringValue:(NSString *)sender;


@end
