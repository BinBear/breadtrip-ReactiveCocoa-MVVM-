//
//  CommonUtils.m
//  futongdai
//
//  Created by 熊彬 on 16/3/9.
//  Copyright © 2016年 OFIM. All rights reserved.
//

#import "CommonUtils.h"
static CGRect oldframe;
@implementation CommonUtils

/*!
 @method
 @abstract 单例获取方法
 @discussion
 @param
 @result 返回公共方法单例对象
 */
//+(CommonUtils  *)getInstance{
//
//    static CommonUtils *instance;
//    if (instance == nil) {
//        @synchronized(self){
//            if (instance == nil) {
//                instance = [[CommonUtils alloc] init];
//            }
//        }
//    }
//    return instance;
//}

#pragma mark - 适配系数-宽 以6为标准
+ (double)WidthCoefficient{
    return SCREEN_WIDTH/375;
}

#pragma mark - 适配系数-高 以6为标准
+ (double)HeightCoefficient{
    return SCREEN_HEIGHT/667;
}

+(NSString *)getFilePath:(NSString *)folder fileName:(NSString *)filename
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    if ([self isStringNilOrEmpty:folder])
    {
        path = [NSString stringWithFormat:@"%@/",path];
    }
    else
    {
        path = [NSString stringWithFormat:@"%@/%@",path,folder];
    }
    return [path stringByAppendingPathComponent:filename];
}

+(NSString *)judgeFile:(NSString *)filename InFolder:(NSString *)folder
{
    NSString *filepath = [self getFilePath:folder fileName:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filepath])
    {
        return filepath;
    }
    return nil;
}

+(UIImage *)judgeImage:(NSString *)filename InFolder:(NSString *)strFolder
{
    NSString *filepath = [self judgeFile:filename InFolder:strFolder];
    if (![self isStringNilOrEmpty:filepath])
    {
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@",filepath]];
        return img;
    }
    else
    {
        return nil;
    }
}


+(void)savePic:(NSData *)data inFolder:(NSString *)strFolder andName:(NSString *)imageName
{
    //    NSData *data = [NSData dataWithContentsOfURL:urlStr];
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:strFolder];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    //    NSString *imageName = [NSString stringWithFormat:@"image_%@.jpg",[DateUtil formatDate:[NSDate date] datePattern:@"yyyy_MM_dd__HH_mm_ss"]];
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//    BOOL y = [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@.jpg",imageName]] contents:data attributes:nil];
}

//删除文件夹及文件级内的文件：
+(void)deleteImagesInFolder
{
    NSString *imageDir = [NSString stringWithFormat:@"%@/Documents/showImages/", NSHomeDirectory()];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:imageDir error:nil];
}


+(void)saveAddressBook:(NSArray *)arr path:(NSString *)filePath
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:arr forKey:@"key"];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
}


+(void)deleteAddressBookInFolder:(NSString *)strFolder
{
    NSString *imageDir = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(),strFolder];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:imageDir error:nil];
}



+(void)showDialogWithTaget:(nullable id)taget andTitle:(NSString *)title message:(NSString *)msg delegate:(nullable id)delegate
{
    
    Class class = NSClassFromString(@"UIAlertController");
    if (class) {
        
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:title
                                            message:msg
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:action1];
        
        [taget presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }


}

+(void)showAlertWithTaget:(nullable id)taget andMsg:(NSString *)msg
{
    Class class = NSClassFromString(@"UIAlertController");
    if (class) {
        
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@""
                                            message:msg
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:action1];
        [taget presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }

}

+(void)showDialogWithTwoBtnsTaget:(nullable id)taget andWithTitle:(NSString *)title message:(NSString *)msg delegate:(nullable id)delegate
{
    Class class = NSClassFromString(@"UIAlertController");
    if (class) {
        
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:title
                                            message:msg
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:action1];
        [alertController addAction:action2];
        [taget presentViewController:alertController animated:YES completion:nil];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert show];
    }

}

+(BOOL)nibFileExist:(NSString *)nibName{
    NSString *nibFilePath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *nibNameWithExtention = [NSString stringWithFormat:@"%@.xib", nibName];
    nibFilePath = [rootPath stringByAppendingPathComponent:nibNameWithExtention];
    return [[NSFileManager defaultManager] fileExistsAtPath:nibFilePath];
}

+(NSInteger)getUnicodeLengthForStr:(NSString*)strtemp{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

+(BOOL)isStringNilOrEmpty:(NSString *)str{
    if(str == nil || [@"" isEqualToString:str]){
        return YES;
    }else{
        return NO;
    }
}

//利用正则表达式验证邮箱的合法性
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)isValidatePassword:(NSString *)pw {
    NSString *emailRegex = @"[A-Z0-9a-z_]{6,15}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:pw];
}
+(BOOL)isAlphbet:(NSString *)pw {
    NSString *emailRegex = @"[A-Za-z]{1}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:pw];
}
+(BOOL)isValidateNickname:(NSString *)nickName {
    NSString *emailRegex = @"[A-Z 0-9a-z\u4e00-\u9fa5]{1,15}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:nickName];
}
+(BOOL)isValidatePhoneNum:(NSString *)phone
{
    NSString *phoneRegex = @"^((147)|((17|13|15|18|14)[0-9]))\\d{8}$";//@"\\d{3}-\\d{8}|\\d{4}-\\d{7}|\\d{11}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

+(BOOL)isValidateTelephoneNum:(NSString *)phone{
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    return [phoneTest evaluateWithObject:phone];
}
+(BOOL)isValidateTelephone:(NSString *)phone
{
    NSString * PHS = @"(”^(\\d{3,4}-)\\d{7,8}$”)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    return [phoneTest evaluateWithObject:phone];
}

+(BOOL)isValidateNumber:(NSString *)number
{
    NSString * num = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",num];
    return [numberTest evaluateWithObject:number];
}

+(BOOL)isValidateChinese:(NSString *)chineseName
{
    NSString *chineseStr = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *chineseTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",chineseStr];
    return [chineseTest evaluateWithObject:chineseName];
}

+(BOOL)isStrFitRegex:(NSString *)str regex:(NSString *)regex{
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pwdTest evaluateWithObject:str];
}
+ (BOOL)isValidateAreaCodeNum:(NSString *)areaCodePhone
{
    NSString * num = @"^\\d{3,4}$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",num];
    return [numberTest evaluateWithObject:areaCodePhone];
}
+ (BOOL)isValidateSevenNum:(NSString *)SevenNum
{
    NSString * num = @"^\\d{7,8}$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",num];
    return [numberTest evaluateWithObject:SevenNum];
}


+(BOOL)isViewControllerVisible:(UIViewController *)ctl{
    BOOL isVisible = NO;
    if(![ctl isKindOfClass:[UIViewController class]]){
        return isVisible;
    }
    
    if([ctl isViewLoaded] ){
        if([[ctl view]window]){
            isVisible = YES;
        }
    }
    return isVisible;
}

+(BOOL)isPureFloat:(NSString*)string
{
    NSScanner* scan=[NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val]&&[scan isAtEnd];
}

+(BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan=[NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val]&&[scan isAtEnd];
}
+(void)printSupportedFontInfo{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {

        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {

        }
    }
}


+(UIColor*)getColor:(UInt32)value withAlpha:(CGFloat)alpha
{
    CGFloat red=((value/0xff0000)&0xff)/255.0;
    CGFloat green=((value/0xff)&0xff)/255.0;
    CGFloat blue=(value&0xff)/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


+(NSString*)getAppVersion
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appVersion=[infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

+(NSString*)getAppName
{
    NSDictionary* infoDictionary=[[NSBundle mainBundle]infoDictionary];
    NSString* appName=[infoDictionary objectForKey:@"CFBundleDisplayName"];
    return appName;
}

//international
+(NSString *)getAllSupportLanguage{
    NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
    // 取得 iPhone 支持的所有语言设置
    NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
    return [NSString stringWithFormat:@"%@" , languages];
}

+(NSString *)getCurrentLanguage{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return [NSString stringWithFormat:@"%@" , currentLanguage];
}

+(void)addGrayGradientShadow:(UIView *)v{
    // 0.8 is a good feeling shadowOpacity
    v.layer.shadowOpacity = 0.9;
    
    // The Width and the Height of the shadow rect
    //    CGFloat rectWidth = 100.0;
    CGFloat rectHeight = v.frame.size.height;
    CGFloat rectWidth = v.frame.size.width;
    
    // Creat the path of the shadow
    CGMutablePathRef shadowPath = CGPathCreateMutable();
    // Move to the (0, 0) point
    CGPathMoveToPoint(shadowPath, NULL, -2.5, -2.5);
    // Add the Left and right rect
    CGPathAddRect(shadowPath, NULL, CGRectMake(-2.5, 2.5, 5, rectHeight-2.5));//left
    CGPathAddRect(shadowPath, NULL, CGRectMake(0, -2.5, rectWidth, 5));//top
    CGPathAddRect(shadowPath, NULL, CGRectMake(rectWidth, 0, 2.0, rectHeight));//right
    CGPathAddRect(shadowPath, NULL, CGRectMake(0, rectHeight, rectWidth, 2.0));//bottom
    
    v.layer.shadowPath = shadowPath;
    CGPathRelease(shadowPath);
    // Since the default color of the shadow is black, we do not need to set it now
    //self.layer.shadowColor = [UIColor blackColor].CGColor;
    
    v.layer.shadowOffset = CGSizeMake(0, 0);
    // This is very important, the shadowRadius decides the feel of the shadow
    v.layer.shadowRadius = 3.0;
    v.layer.shadowColor = [[UIColor blackColor]CGColor];
}

+(NSString *)bytesToString:(int)bytes{
    
    if(bytes < 1024)		// B
    {
        return [NSString stringWithFormat:@"%dB", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024)	// KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)	// MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else	// GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
    
}


+(UIImage *)getResizeImage:(NSString *)imageName{
    UIImage *tempImage = [UIImage imageNamed:imageName];
    if([tempImage respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]){
        tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch];
    }else{
        tempImage = [tempImage stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    }
    return tempImage;
}

+(UIImage *)getResizeImage:(NSString *)imageName withCap:(NSInteger)cap{
    UIImage *tempImage = [UIImage imageNamed:imageName];
    if([tempImage respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]){
        tempImage = [tempImage resizableImageWithCapInsets:UIEdgeInsetsMake(cap,cap, cap, cap) resizingMode:UIImageResizingModeStretch];
    }else{
        tempImage = [tempImage stretchableImageWithLeftCapWidth:cap topCapHeight:cap];
    }
    return tempImage;
}


+(int)getStringLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}


+(NSDate *)getDateFromTimeInternalDateStr:(NSString *)d{
    if([self isStringNilOrEmpty:d]){
        return nil;
    }else{
        return [NSDate dateWithTimeIntervalSince1970:[d longLongValue]/1000];
    }
}


//两个时间之差
+ (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
    dateString1=[timeArray1 objectAtIndex:0];
    
    
    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
    dateString2=[timeArray2 objectAtIndex:0];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *d1=[date dateFromString:dateString1];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    
    
    NSDate *d2=[date dateFromString:dateString2];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    
    
    NSTimeInterval cha=late2-late1;
    NSString *timeString=@"";
    NSString *house=@"";
    NSString *min=@"";
    NSString *sen=@"";
    
    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
    //        min = [min substringToIndex:min.length-7];
    //    秒
    sen=[NSString stringWithFormat:@"%@", sen];
    
    
    
    min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
    //        min = [min substringToIndex:min.length-7];
    //    分
    min=[NSString stringWithFormat:@"%@", min];
    
    
    //    小时
    house = [NSString stringWithFormat:@"%d", (int)cha/3600];
    //        house = [house substringToIndex:house.length-7];
    house=[NSString stringWithFormat:@"%@", house];
    
    
    timeString=[NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
    
    
    return timeString;
}

//时间转化成字符串
+ (NSString * )NSDateToNSString: (NSDate * )date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

#pragma - mark 图片点击放大缩小
+(void)showImage:(UIImageView *)avatarImageView{
    
    UIImage *image = avatarImageView.image;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = oldframe;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

+(void)textfieldChangeClearButtonImageWithTextfield:(UITextField *)textfield andClearImage:(UIImage *)image
{
    @try {
        //更改clearButton的图片
        UIButton *clearButton = [textfield valueForKey:@"_clearButton"];        
        [clearButton setImage:image forState:UIControlStateNormal];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
@end
