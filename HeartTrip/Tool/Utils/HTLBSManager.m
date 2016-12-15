//
//  HTLBSManager.m
//  HeartTrip
//
//  Created by 熊彬 on 16/12/1.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTLBSManager.h"
#import <CoreLocation/CoreLocation.h>

@interface HTLBSManager ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    NSString *longitude;
    NSString *latitude;
}

@property (nonatomic, assign) BOOL didResponseLbsInfo;  //是否已经成功返回过Lbs信息

@end

@implementation HTLBSManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.didResponseLbsInfo = NO;
    }
    return self;
}

+ (HTLBSManager *)startGetLBSWithDelegate:(id<HTLBSManagerDelegate>)delegate
{
    HTLBSManager *lbs = [[HTLBSManager alloc] init];
    lbs.delegate = delegate;
    [lbs getLBS];
    return lbs;
}

- (void)getLBS
{
    //设置locationManager
    [self setupLocationManager];
    
    //第一步，先判断定位服务开关
    [self locationServerSwitch];
}

- (void)locationServerSwitch
{
    BOOL enable = [CLLocationManager locationServicesEnabled];
    if (!enable) {   //分支1：定位服务没有开启的情况下
        
    }else {         //分支2：定位服务已经开启的情况下
        
    }
}

- (void)setupLocationManager {
    
    //初始化locationManager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //设置定位精度
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次
    locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    
}

#pragma mark -
#pragma mark Location Manager Delegate Callback Method

//获取位置信息成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (self.didResponseLbsInfo) { return; }
    
    //获取最新的位置信息,取出第一个位置
    CLLocation *checkinLocation = [locations firstObject];
    
    //经度,保留14位小数
    longitude = [NSString stringWithFormat:@"%lf", checkinLocation.coordinate.longitude];
    //纬度
    latitude = [NSString stringWithFormat:@"%lf", checkinLocation.coordinate.latitude];
    
    // 保存经纬度
    [CommonUtils saveStrValueInUD:longitude forKey:Longitudekey];
    [CommonUtils saveStrValueInUD:latitude forKey:Latitudekey];
    
    CLLocationCoordinate2D coordinate = checkinLocation.coordinate;//位置坐标
    
    //根据经纬度反向地理编译出地址信息
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    //停止定位服务
    [manager stopUpdatingLocation];
    
    //定位信息成功，返回地理位置信息成功
    [self responseGetLbsInfoSuccess];
    
    self.didResponseLbsInfo = YES;
    
}

//获取位置信息失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //停止定位服务
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    if (status == kCLAuthorizationStatusNotDetermined) {//用户从未选择过权限，那么就开启请求权限
        //允许后台定位
        //        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {  //iOS8 新增的手动请求权限的方法
        //            [locationManager requestAlwaysAuthorization]; //请求权限，系统会弹出询问用户是否允许使用位置信息的对话框（选择完成后，app会再次回调locationManager:didChangeAuthorizationStatus:方法）
        //        }else {
        //            //iOS7请求权限的方法
        //            [locationManager startUpdatingLocation];
        //        }
        
        //         使用时定位
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {  //iOS8 新增的手动请求权限的方法
            [locationManager requestWhenInUseAuthorization]; //请求权限，系统会弹出询问用户是否允许使用位置信息的对话框（选择完成后，app会再次回调locationManager:didChangeAuthorizationStatus:方法）
        }else {
            //iOS7请求权限的方法
            [locationManager startUpdatingLocation];
        }
        
    }else {  //用户已经选择过权限
        
        if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {  //用户允许授权
            
            if (latitude && longitude) {
                //已经执行过请求lbs的信息，本地有数据了，直接返回数据
                [self responseGetLbsInfoSuccess];
                return;
            }
            
            //开始获取地理位置信息
            [locationManager startUpdatingLocation];  //如果成功调用代理 locationManager：didUpdateLocations: 失败则调用代理 locationManger:didFailWithError:
        }else {  //用户不授权
            
            //返回用户不授权获取位置信息，或者不返回
            [CommonUtils saveStrValueInUD:@"定位失败" forKey:CityNamekey];
        }
        
    }
    
}


- (void)responseGetLbsInfoSuccess
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getLbsSuccessWithLongitude:latitude:)]) {
        [self.delegate getLbsSuccessWithLongitude:longitude latitude:latitude];
    }
}

#pragma mark 根据坐标取得地名
/*
 NSString *name=placemark.name;//地名
 NSString *thoroughfare=placemark.thoroughfare;//街道
 NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
 NSString *locality=placemark.locality; // 城市
 NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
 NSString *administrativeArea=placemark.administrativeArea; // 州
 NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
 NSString *postalCode=placemark.postalCode; //邮编
 NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
 NSString *country=placemark.country; //国家
 NSString *inlandWater=placemark.inlandWater; //水源、湖泊
 NSString *ocean=placemark.ocean; // 海洋
 NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
 */

-(void)getAddressByLatitude:(CLLocationDegrees)latitude2 longitude:(CLLocationDegrees)longitude2{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude2 longitude:longitude2];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSString *area = [NSString stringWithFormat:@"%@",placemark.locality];
        [CommonUtils saveStrValueInUD:area forKey:CityNamekey];
    }];
    
}
@end
