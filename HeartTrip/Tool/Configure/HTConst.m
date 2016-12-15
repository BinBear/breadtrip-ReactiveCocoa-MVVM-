//
//  HTConst.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/13.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTConst.h"

/********** Project Key ***********/

// 首页banner数据key
NSString *const  BannerDatakey = @"BannerDatakey";
// 首页热门游记数据key
NSString *const  TravelDatakey = @"TravelDatakey";
// 发现视频数据key
NSString *const  FindVideoDatakey = @"FindVideoDatakey";
// 发现feed数据key
NSString *const  FindFeedDatakey = @"FindFeedDatakey";
// 经度key
NSString *const  Longitudekey = @"Longitudekey";
// 纬度key
NSString *const  Latitudekey = @"Latitudekey";
// 城市名key
NSString *const  CityNamekey = @"CityNamekey";
// 网页标题key
NSString *const  WebTitlekey = @"WebTitlekey";
// 网页请求地址key
NSString *const  RequestURLkey = @"RequestURLkey";


/********** 网络请求地址 ***********/

// 服务地址
NSString *const  HTURL = @"http://api.breadtrip.com";
NSString *const  HTURL_Test = @"";


// 首页
NSString *const  CityTravel_URL = @"/v2/index/";

// 发现
NSString *const  Find_URL = @"/hunter/feeds/";

// 新手必读
NSString *const  XinShouBiDu_URL = @"http://www.futongdai.com/act/app_ftdd/required.html";

// 注册绑卡
NSString *const  ZhuCeBangKa_URL = @"http://www.futongdai.com/act/app_ftdd/invest.html";

// 投资操作
NSString *const  TouZiCaoZuo_URL = @"http://www.futongdai.com/act/app_ftdd/enroll.html";

// 收益保障
NSString *const  ShouYiBaoZhagn_URL = @"http://www.futongdai.com/act/app_ftdd/income.html";

// 产品介绍
NSString *const  ChanPingJieShao_URl = @"http://www.futongdai.com/act/app_ftdd/product.html";

// 版本更新
NSString *const  APPVersonUpdate_URL = @"/verson_anr.json";

// 用户登录
NSString *const  LOGIN_URL = @"/ulog.json";

//首页
NSString *const  FirsPage_URL = @"/firstPage.json";

// 账户中心
NSString *const  AcountCenter_URL = @"/ua/uacount.json";

// 信息中心
NSString *const  InfomationCenter_URL = @"/ua/umail.json";

// 修改密码
NSString *const  ChangePW_URL = @"/ua/upwd.json";

// 忘记登录密码
NSString *const  ForgetLoginPW_URL = @"/flpwd.json";

// 充值
NSString *const  Recharge_URL = @"/ua/ucharg.json";

//提现
NSString *const  WithDraw_RUL = @"/ua/uwith.json";

// 用户注册
NSString *const  REGISTER_URL = @"/reg.json";

// 用户注册验证码
NSString *const  SEND_REGISTER_URL = @"/sendmsg.json";

// 实名认证
NSString *const  RealName_URL = @"/ua/ureal.json";

// 绑定银行卡
NSString *const  BanCard_URL = @"/ua/ubindcard.json";

// 银行列表
NSString *const  BankList_URL = @"/bankList.json";

// 更改银行卡
NSString *const  ChangeBankCard_URL = @"/ua/uChangeCard.json";

// 更换头像
NSString *const  UPHEADER_URL = @"/iapi/member/upheader";

//意见反馈
NSString *const  FEEDBACK_URL = @"/ua/feedback.json";

//首页轮播图
NSString *const  FirsScroPage_URL = @"/firstlink.json";

//公告
NSString *const  Announce_URL = @"/board.json";

//标列表
NSString *const  InvestList_URL = @"/bits.json";

//邀请好友
NSString *const  InvestFriends_URL = @"/ua/uvite.json";

//首页启动图
NSString *const  FirstIMG_URL = @"/firstlink.json";

//首页启动图
NSString *const  INVestDetail_URL = @"/bitinfo.json";

//个人红包
NSString *const  PersonRedPackage_URL = @"/ua/ured.json";

// 绑定邮箱
NSString *const  BindUamil_URL = @"/verifyemail.json";

// 安全退出
NSString *const  LoginOut_URL = @"/logout.json";

//资金流水记录
NSString *const  FundRecord_URL = @"/ua/ubits.json";

//待回收记录
NSString *const  WaitingReceiveRecord_URL = @"/ua/uprebits.json";

//列表投资记录
NSString *const  InvestListRect_URL = @"/investList.json";

NSString *const  Buy_URL = @"/ua/upay.json";

// 特权活动
NSString *const  Advact_URL = @"/ua/advact.json";

// 签到信息
NSString *const  SignInRecordInfo_URL = @"/ua/ucheck.json";

//购买记录
NSString *const  PurchaseRecord_URL = @"/ua/uby/";
//精彩活动
NSString *const  FTDActivity_URL = @"/jingcaihuodong.json";

//红包规则
NSString *const  FTDRedPacketRule_URL = @"/packetRule.json";
