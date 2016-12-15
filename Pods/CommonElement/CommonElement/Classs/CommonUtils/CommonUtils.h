//
//  CommonUtils.h
//  futongdai
//
//  Created by 熊彬 on 16/3/9.
//  Copyright © 2016年 OFIM. All rights reserved.
//

#define TR_WidthCoefficient                [CommonUtils WidthCoefficient]
#define TR_HeightCoefficient               [CommonUtils HeightCoefficient]
#define TR_COLOR_RGBACOLOR_A(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//获取屏幕宽度，高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 @class
 @abstract 公共方法单例类
 */
@interface CommonUtils : NSObject

#pragma mark - 适配系数-宽 以6为标准
+ (double)WidthCoefficient;

#pragma mark - 适配系数-高 以6为标准
+ (double)HeightCoefficient;

/*!
 @method
 @abstract 单例获取方法
 @discussion
 @result 返回公共方法单例对象
 */
//+(CommonUtils  *)getInstance;


/*!
 @method
 @abstract 只有一个“确定”按钮的系统提示对话框
 @discussion
 @param msg 提示消息内容
 @result 无返回
 */
+(void)showAlertWithTaget:(nullable id)taget andMsg:(NSString *)msg;

/*!
 @method
 @abstract 只有一个“确定”按钮的系统提示对话框
 @discussion
 @param title 标题
 @param msg 提示消息内容
 @param delegate 对话框点击后回调委托
 @param tag 对话框tag，用于同一viewController多个提示框中区分
 @result 无返回
 */
+(void)showDialogWithTaget:(nullable id)taget andTitle:(NSString *)title message:(NSString *)msg delegate:(nullable id)delegate;

/*!
 @method
 @abstract 有“确定”、"取消"按钮的系统提示对话框
 @discussion
 @param title 标题
 @param msg 提示消息内容
 @param delegate 对话框点击后回调委托
 @param tag 对话框tag，用于同一viewController多个提示框中区分
 @result 无返回
 */
+(void)showDialogWithTwoBtnsTaget:(nullable id)taget andWithTitle:(NSString *)title message:(NSString *)msg delegate:(nullable id)delegate;


/*!
 @method
 @abstract 判断nib文件是否存在
 @discussion
 @param nibName nib文件名称
 @result YES 存在 NO 不存在
 */
+(BOOL)nibFileExist:(NSString *)nibName;

/*!
 @method
 @abstract 获取字符串unicode的长度
 @discussion 英文一个字符长度为1，中文一个字符长度为2
 @param strtemp 要判断的字符串
 @result 字符串unicode的长度
 */
+(NSInteger)getUnicodeLengthForStr:(NSString*)strtemp;

/*!
 @method
 @abstract 判断字符串是否为空或nil
 @discussion
 @param str 要判断的字符串
 @result YES 字符串为nil或空  NO 字符串非空
 */
+(BOOL)isStringNilOrEmpty:(NSString *)str;

/*!
 @method
 @abstract 邮箱合法型正则表达式判断
 @discussion
 @param email 要判断的字符串
 @result YES 合法  NO 不合法
 */
+(BOOL)isValidateEmail:(NSString *)email;

/*!
 @method
 @abstract 数字合法型正则表达式判断
 @discussion
 @param email 要判断的字符串
 @result YES 合法  NO 不合法
 */
+(BOOL)isValidateNumber:(NSString *)number;

+(BOOL)isValidatePassword:(NSString *)pw;
+(BOOL)isValidateNickname:(NSString *)nickName;

/*!
 @method
 @abstract 手机号码合法型正则表达式判断
 @discussion
 @param phone 要判断的字符串
 @result YES 合法  NO 不合法
 */
+(BOOL)isValidatePhoneNum:(NSString *)phone;

/*!
 @method
 @abstract 固定电话合法型正则表达式判断
 @discussion
 @param phone 要判断的字符串
 @result YES 合法  NO 不合法
 */
+(BOOL)isValidateTelephoneNum:(NSString *)phone;
/*!
 @method
 @abstract 固定电话家横杆合法型正则表达式判断
 @discussion
 @param phone 要判断的字符串
 @result YES 合法  NO 不合法
 */
+(BOOL)isValidateTelephone:(NSString *)phone;

/**
 *  中文合法型正则表达式判断
 *
 *  @param chineseName 要判断的字符串
 *
 *  @return YES 合法  NO 不合法
 */
+(BOOL)isValidateChinese:(NSString *)chineseName;

/**
 *  区号合法型正则表达式判断
 *
 *  @param chineseName 要判断的字符串
 *
 *  @return YES 合法  NO 不合法
 */
+(BOOL)isValidateAreaCodeNum:(NSString *)areaCodePhone;

/**
 *  7~8位数字合法型正则表达式判断
 *
 *  @param chineseName 要判断的字符串
 *
 *  @return YES 合法  NO 不合法
 */
+(BOOL)isValidateSevenNum:(NSString *)SevenNum;

/*!
 @method
 @abstract 利用正则表达式判断字符串是否符合规则
 @discussion
 @param str 要判断的字符串
 @param regex 正则表达式字符串
 @result YES 合法  NO 不合法
 */
+(BOOL)isStrFitRegex:(NSString *)str regex:(NSString *)regex;

/*!
 @method
 @abstract 判断某个viewController是否可见
 @discussion 判断项目中某个viewController是否可见
 @param ctl 要判断的viewController对象示例
 @result YES 可见  NO 不可见
 */
+(BOOL)isViewControllerVisible:(UIViewController *)ctl;


/*!
 @method
 @abstract 打印系统支持的字体
 @discussion 包括Family name和Font name，打印显示在console中
 @result 无
 */
+(void)printSupportedFontInfo;

/*!
 @method
 @abstract 十六进制RGB颜色值转化为UIColor对象
 @discussion
 @result UIColor对象
 */
+(UIColor*)getColor:(UInt32)value withAlpha:(CGFloat)alpha;

/*!
 @method
 @abstract 获取当前项目版本号
 @discussion
 @result 当前项目版本号
 */
+(NSString*)getAppVersion;

/*!
 @method
 @abstract 获取当前项目名称
 @discussion
 @result 当前项目名称
 */
+(NSString*)getAppName;


/*!
 @method
 @abstract 取得iPhone支持的所有语言设置
 @discussion
 @result 系统支持的语言
 */
+(NSString *)getAllSupportLanguage;

/*!
 @method
 @abstract 取得iPhone当前设定的语言类型
 @discussion
 @result 当前设定的语言类型
 */
+(NSString *)getCurrentLanguage;


/*!
 @method
 @abstract 给view加黑色阴影
 @discussion
 @result 无
 */
+(void)addGrayGradientShadow:(UIView *)v;

/*!
 @method
 @abstract 将byte装换为带单位的大小字符串
 @discussion 如2048 bytes，输出为2kb
 @result 单位的大小字符串
 */
+(NSString *) bytesToString:(int)bytes;

/*!
 @method
 @abstract 自动拉伸图片，使用过默认的8像素边框
 @discussion
 @param date 待处理的图片的名称
 @result 得到拉伸后的图片
 */
+(UIImage *)getResizeImage:(NSString *)imageName;

/*!
 @method
 @abstract 自动拉伸图片
 @discussion
 @param date 待处理的图片的名称
 @param cap 不拉伸的边框值
 @result 得到拉伸后的图片
 */
+(UIImage *)getResizeImage:(NSString *)imageName withCap:(NSInteger)cap;

/*!
 @method
 @abstract 计算字符串长度
 @discussion
 @param text 待计算的字符串
 @result 返回字符串的长度
 */
+(int)getStringLength:(NSString *)text;

+(NSDate *)getDateFromTimeInternalDateStr:(NSString *)d;

//判断是浮点数据类型
+(BOOL)isPureFloat:(NSString*)string;
//判断是int数据类型
+(BOOL)isPureInt:(NSString*)string;
+(BOOL)isAlphbet:(NSString *)pw;

//判断file是否在本地
+ (NSString *)judgeFile:(NSString *)filename InFolder:(NSString *)folder;
//判断图片是否在本地
+ (UIImage *)judgeImage:(NSString *)filename InFolder:(NSString *)strFolder;
//保存图片到本地
+ (void)savePic:(NSData *)data inFolder:(NSString *)strFolder andName:(NSString *)imageName;
//删除文件夹及文件级内的文件：
+ (void)deleteImagesInFolder;

+ (NSString *)getFilePath:(NSString *)folder fileName:(NSString *)filename;
+ (void)saveAddressBook:(NSArray *)arr path:(NSString *)filePath;
+ (void)deleteAddressBookInFolder:(NSString *)strFolder;

//计算两个时间点之间的时间差
+ (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2;
//时间转化字符串
+ (NSString * )NSDateToNSString: (NSDate * )date;

/*图片点击放大缩小
 @avatarImageView 需要缩放的imageView
 */
+(void)showImage:(UIImageView*)avatarImageView;

/*
 @textfield
 @image 替换的图片
 */
+(void)textfieldChangeClearButtonImageWithTextfield:(UITextField *)textfield andClearImage:(UIImage *)image;

/**
 *  获取当前屏幕的控制器
 */
+ (UIViewController *)getCurrentVC;

@end

NS_ASSUME_NONNULL_END