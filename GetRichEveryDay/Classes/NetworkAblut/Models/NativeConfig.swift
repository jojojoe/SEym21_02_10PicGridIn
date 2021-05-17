//
//  NativeConfig.swift
//  Adjust
//
//  Created by 薛忱 on 2020/7/30.
//

import UIKit
import SwiftyJSON

// cfg mdoel
class NativeConfig: NSObject {
    /// 点击‘获取金币’按钮x次后展示一次广告
    var cfgAdGetcoinsMax: Int?
    /// 自家广告显示频率
    var cfgAdShowTimes: Int?
    /// 获取金币页 连续按 action 次数，后展示积分墙
    var cfgClickGetcoinsWallappCounts: Int?
    /// App导量是否打开
    var cfgDliangDakai: Int?
    /// App导量描述
    var cfgDliangDesc: String?
    /// App导量地址
    var cfgDliangDest: String?
    /// 导量ICON
    var cfgDliangIcon: String?
    /// 导量标题,网页支付导量标题建议字符长度在30左右
    var cfgDliangTitle: String?
    /// Earncoins Display ???
    var cfgEarncoinsDisplay: Int?
    /// 重新检查进核开关是否打开
    var cfgEntercheckInterval: Double?
    /// Freecoins Display Get likes ???
    var cfgFreecoinsDisplayGetlikes: Int?
    /// 重新抓取IP所需最小间隔时间
    var cfgIpcheckInterval: Double?
    /// 是否下线
    var cfgIslive: Int?
    /// 登录方式: 0-webview,ins网页登陆， 1-api直接调用接口登陆方式
    var cfgLoginSaram: Int?
    /// Mopub Daoliang Switch ???
    var cfgMopubDaoliangSwitch: Int?
    /// Offwall提供商的id
    var cfgOfferwallProvider: Int?
    /// Oidentry ???
    var cfgOidentry: Int?
    /// 系统类型 iOS
    var cfgPlatform: String?
    /// 一天内展示 Promotion 弹框的展示次数
    var cfgPopupShowCounts: Int?
    /// Promotion间隔，按天计算,0.5为半天
    var cfgPromInterval: Double?
    /// 当前审核版本
    var cfgPromVersion: String?
    /// 线上discountType参数,存放203，204等参数 ???
    var cfgUserchurnDiscountType: Int?
    /// web支付导量文案(cfgWebpayDliangDesc),web支付导量banner比较小，建议字符长度在80左右
    var cfgWebpayDliangDesc: String?
    /// web支付中原生支付的开关
    var cfgWebpayNativepayShow: Int?
    /// getconins 页面 广告显示时间
    var cfgYincangDays: Double?
    // MARK: - ios config
    /// 购买倒量:  强制开关
    var cfgBuyManualTransfer: Int?
    /// 首页倒量: 产品列表
    var cfgDaoliangLevelScheme: Array<DaoliangSchemeModel>?
    /// 购买倒量: 倒量类型
    var cfgDaoliangMaiTransferType: String?
    /// 购买倒量: APP 列表
    var cfgDaoliangScheme: Array<DaoliangSchemeModel>?
    /// 是否开启用户分级导量：首页和点击8次导量
    var cfgDliangUserlevelSwitch: Int?
    /// IAP支付失败时导量 导量文案 以 | (竖线)代表换行
    var cfgFailpyDoc: String?
    /// IAP支付失败时导量 导量Icon地址
    var cfgFailpyIcon: String?
    /// IAP支付失败时导量 导量产品名称
    var cfgFailpyProductName: String?
    /// IAP支付失败时导量 导量文案的标题
    var cfgFailpyTitle: String?
    /// IAP支付失败时导量 导量app地址
    var cfgFailpyUrl: String?
    /// 混合模式下Follow Order 显示次数
    var cfgFollowOrderShowTimes: Int?
    /// 免费用户硬币上限
    var cfgFreeUserCoinsUpperLimit: Int?
    /// 获取金币的方 0 无操作, 1 插屏, 2 积分墙, 3 金币购买, 4 原生广告, 5 倒量广告
    var cfgGetcoinsAdType: Int?
    /// GetCoins页面Follow操作次数限制
    var cfgGetcoinsFollowLimit: Int?
    /// GetCoins页面Like操作次数限制(cfg_getcoins_like_limit)，小于0代表无限制，大于0代表具体次数
    var cfgGetcoinsLikeLimit: Int?
    /// getcoins页面点赞控制项，非付费用户，单位：次数，点击多少次之后，不能再点击，必须要购买后才能继续点
    var cfgGetcoinsLimitFreeuser: Int?
    /// GetCoins页面初始 Index
    var cfgGetcoinsOrderTypeIndex: Int?
    /// GetCoins页面展示订单时样式
    var cfgGetcoinsPageStyle: Int?
    /// 点击n次，弹出一次promotion 0表示无操作。单位：次数
    var cfgGetcoinsPromotionInterval: Int?
    /// GetCoins页面Follow or Like操作次数限制, 小于0代表无限制，大于0代表具体次数
    var cfgInsactionLimiationInterval: Int?
    /// 混合模式下Like Order 显示次数(cfg_like_order_show_times)
    var cfgLikeOrderShowTimes: Int?
    /// 原生广告: 广告误点击控制, n 次误点击后一次非误点击
    var cfgNativeadDisplayInterval: Int?
    /// 首页倒量: 强制开关
    var cfgNobackTransfer: Int?
    /// 标识积分墙展示类型 : -1代表no our；0 代表 only our offer wall; 正数代表都有，同时代表间隔次数，例如：2 代表别家的offerwall展示两次后，第三次展示自己的;
    var cfgOfferwallSelfIntervalTimes: Int?
    /// 激励导量文案, 以 | (竖线)代表换行
    var cfgRewarddlDesc: String?
    /// 销单请求发送间隔时间
    var cfgSendOrderIntervalTime: Int?
    
    class func createModel(json: Any) -> NativeConfig {
        let jsonData = JSON.init(json)
        
        let nativConfigModel = NativeConfig.init()
        nativConfigModel.cfgAdGetcoinsMax = jsonData["cfg_ad_getcoins_max"].int
        nativConfigModel.cfgAdShowTimes = jsonData["cfg_ad_show_times"].int
        nativConfigModel.cfgClickGetcoinsWallappCounts = jsonData["cfg_click_getcoins_wallapp_counts"].int
        nativConfigModel.cfgDliangDakai = jsonData["cfg_dliang_dakai"].int
        nativConfigModel.cfgDliangDesc = jsonData["cfg_dliang_desc"].string
        nativConfigModel.cfgDliangDest = jsonData["cfg_dliang_dest"].string
        nativConfigModel.cfgDliangIcon = jsonData["cfg_dliang_icon"].string
        nativConfigModel.cfgDliangTitle = jsonData["cfg_dliang_title"].string
        nativConfigModel.cfgEarncoinsDisplay = jsonData["cfg_earncoins_display"].int
        nativConfigModel.cfgIpcheckInterval = jsonData["cfg_entercheck_interval"].double
        nativConfigModel.cfgFreecoinsDisplayGetlikes = jsonData["cfg_freecoins_display_getlikes"].int
        nativConfigModel.cfgIpcheckInterval = jsonData["cfg_ipcheck_interval"].double
        nativConfigModel.cfgIslive = jsonData["cfg_islive"].int
        nativConfigModel.cfgLoginSaram = jsonData["cfg_login_saram"].int
        nativConfigModel.cfgMopubDaoliangSwitch = jsonData["cfg_mopub_daoliang_switch"].int
        nativConfigModel.cfgOfferwallProvider = jsonData["cfg_offerwall_provider"].int
        nativConfigModel.cfgOidentry = jsonData["cfg_oidentry"].int
        nativConfigModel.cfgPlatform = jsonData["cfg_platform"].string
        nativConfigModel.cfgPopupShowCounts = jsonData["cfg_popup_show_counts"].int
        nativConfigModel.cfgPromInterval = jsonData["cfg_prom_interval"].double
        nativConfigModel.cfgPromVersion = jsonData["cfg_prom_version"].string
        nativConfigModel.cfgUserchurnDiscountType = jsonData["cfg_userchurn_discount_type"].int
        nativConfigModel.cfgWebpayDliangDesc = jsonData["cfg_webpay_dliang_desc"].string
        nativConfigModel.cfgWebpayNativepayShow = jsonData["cfg_webpay_nativepay_show"].int
        nativConfigModel.cfgYincangDays = jsonData["cfg_yincang_days"].double
        nativConfigModel.cfgBuyManualTransfer = jsonData["iosConfig"]["cfg_buy_manual_transfer"].int
        nativConfigModel.cfgDaoliangLevelScheme = createDaoliangSchemeModels(strJson: jsonData["iosConfig"]["cfg_daoliang_level_scheme"].string)
        nativConfigModel.cfgDaoliangMaiTransferType = jsonData["iosConfig"]["cfg_daoliang_mai_transfer_type"].string
        nativConfigModel.cfgDaoliangScheme = createDaoliangSchemeList(strJson: jsonData["iosConfig"]["cfg_daoliang_scheme"].string)
        nativConfigModel.cfgDliangUserlevelSwitch = jsonData["iosConfig"]["cfg_dliang_userlevel_switch"].int
        nativConfigModel.cfgFailpyDoc = jsonData["iosConfig"]["cfg_failpy_doc"].string?.replacingOccurrences(of: "|", with: "\n")
        nativConfigModel.cfgFailpyIcon = jsonData["iosConfig"]["cfg_failpy_icon"].string
        nativConfigModel.cfgFailpyProductName = jsonData["iosConfig"]["cfg_failpy_product_name"].string
        nativConfigModel.cfgFailpyTitle = jsonData["iosConfig"]["cfg_failpy_title"].string
        nativConfigModel.cfgFailpyUrl = jsonData["iosConfig"]["cfg_failpy_url"].string
        nativConfigModel.cfgFollowOrderShowTimes = jsonData["iosConfig"]["cfg_follow_order_show_times"].int
        nativConfigModel.cfgFreeUserCoinsUpperLimit = jsonData["iosConfig"]["cfg_free_user_coins_upper_limit"].int
        nativConfigModel.cfgGetcoinsAdType = jsonData["iosConfig"]["cfg_getcoins_ad_type"].int
        nativConfigModel.cfgGetcoinsFollowLimit = jsonData["iosConfig"]["cfg_getcoins_follow_limit"].int
        nativConfigModel.cfgGetcoinsLikeLimit = jsonData["iosConfig"]["cfg_getcoins_like_limit"].int
        nativConfigModel.cfgGetcoinsLimitFreeuser = jsonData["iosConfig"]["cfg_getcoins_limit_freeuser"].int
        nativConfigModel.cfgGetcoinsOrderTypeIndex = jsonData["iosConfig"]["cfg_getcoins_order_type_index"].int
        nativConfigModel.cfgGetcoinsPageStyle = jsonData["iosConfig"]["cfg_getcoins_page_style"].int
        nativConfigModel.cfgGetcoinsPromotionInterval = jsonData["iosConfig"]["cfg_getcoins_promotion_interval"].int
        nativConfigModel.cfgInsactionLimiationInterval = jsonData["iosConfig"]["cfg_insaction_limiation_interval"].int
        nativConfigModel.cfgLikeOrderShowTimes = jsonData["iosConfig"]["cfg_like_order_show_times"].int
        nativConfigModel.cfgNativeadDisplayInterval = jsonData["iosConfig"]["cfg_nativead_display_interval"].int
        nativConfigModel.cfgNobackTransfer = jsonData["iosConfig"]["cfg_noback_transfer"].int
        nativConfigModel.cfgOfferwallSelfIntervalTimes = jsonData["iosConfig"]["cfg_offerwall_self_interval_times"].int
        nativConfigModel.cfgRewarddlDesc = jsonData["iosConfig"]["cfg_rewarddl_desc"].string?.replacingOccurrences(of: "|", with: "\n")
        nativConfigModel.cfgSendOrderIntervalTime = jsonData["iosConfig"]["cfg_send_order_interval_time"].int
        
        return nativConfigModel
    }
    
    
    /// 倒量列表
    private class func createDaoliangSchemeModels(strJson: String?) -> Array<DaoliangSchemeModel> {
        
        guard let strData = strJson  else {
            return []
        }
        
        var resultArray: Array<DaoliangSchemeModel> = []
        let jsonData = JSON.init(parseJSON: strData)
        let array = jsonData["home_page"].array
        for subJson in array ?? [] {
            let model = DaoliangSchemeModel.init()
            model.index = subJson["index"].int
            model.productName = subJson["product_name"].string
            model.failpyUrl = subJson["failpy_url"].string
            model.failpyIcon = subJson["cfg_failpy_icon"].string
            model.scheme = subJson["scheme"].string
            model.app_id = subJson["app_id"].string
            model.level = Int(subJson["level"].string ?? "0") ?? 0
            resultArray.append(model)
        }
        
        return resultArray
    }
    
    /// 购买倒量列表
    private class func createDaoliangSchemeList(strJson: String?) -> Array<DaoliangSchemeModel> {
        guard let strData = strJson  else {
            return []
        }
        
        var resultArray: Array<DaoliangSchemeModel> = []
        let jsonData = JSON.init(parseJSON: strData).array
        for subJson in jsonData ?? [] {
            let model = DaoliangSchemeModel.init()
            model.index = subJson["index"].int
            model.productName = subJson["product_name"].string
            model.failpyUrl = subJson["failpy_url"].string
            model.failpyIcon = subJson["cfg_failpy_icon"].string
            model.scheme = subJson["scheme"].string
            model.app_id = subJson["app_id"].string
            model.level = Int(subJson["level"].string ?? "0") ?? 0
            resultArray.append(model)
        }
        return resultArray
    }
}

class DaoliangSchemeModel: NSObject {
    var index: Int?
    var productName: String?
    var failpyUrl: String?
    var failpyIcon: String?
    var scheme: String?
    var app_id: String?
    var level: Int?
    var isShow: Bool = false
}
