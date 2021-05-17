//
//  AdjustManage.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/9.
//

import UIKit
import Adjust

class AdjustManage: NSObject {

    let appToken = "sgtlnqx540sg"
    let app_launch_1st = "4ntf13"
    let app_baseline_1stshow = "oh0hdk"
    let login_button_1stclick = "v6iwu8"
    let login_success_1st = "4370wd"
    let app_baseline_show = "w5kkdp"
    let login_button_click = "s9lwde"
    let login_success_total = "da66h7"
    let purchase_success_total = "nkl1nq"
    let purchase_fail_total = "c1464f"
    let daoliang_impression = "3q1gv9"
    let login_sucess_sesssion = "ttx7k5"
    let weblogin_impression_fail = "sv3ehl"
    let coins_store_impression = "ces2kv"
    let purchase_item_click = "oh7ugu"
    let purchase_cancel = "wlhrm6"
    let exchange_success_like_total = "x55qut"
    let exchange_success_follower_total = "1mf8wt"
    let purchase_follower_success_total = "8tw9x6"
    
    class var sharedInstance : AdjustManage {
        struct Static {
            static let instance : AdjustManage = AdjustManage()
        }
        return Static.instance
    }
    
    private override init() {
        super.init()
    }
    
    func adjustInitializer() {
        Adjust.appDidLaunch(ADJConfig(appToken: appToken, environment: ADJEnvironmentProduction))
    }
    
    func pointLoginSuccessTotal() {
        Adjust.trackEvent(ADJEvent(eventToken: login_success_total))
    }
    
    func pointPurchaseSuccessTotal(price: Double? = nil, currencyCode: String? = nil) {
        
        let adjEvent = ADJEvent(eventToken: purchase_success_total)
        if let price = price {
            adjEvent?.setRevenue(price, currency: currencyCode ?? "USD")
        }
        Adjust.trackEvent(adjEvent)
    }
    
    func pointPurchaseFailTotal() {
        Adjust.trackEvent(ADJEvent(eventToken: purchase_fail_total))
    }
    
    func pointDaoliangImpression() {
        Adjust.trackEvent(ADJEvent(eventToken: daoliang_impression))
    }
    
    func pointLoginSucessSesssion() {
        Adjust.trackEvent(ADJEvent(eventToken: login_sucess_sesssion))
    }
    
    func pointWebloginImpressionFail() {
        Adjust.trackEvent(ADJEvent(eventToken: weblogin_impression_fail))
    }
    
    func pointCoinsStoreImpression() {
        Adjust.trackEvent(ADJEvent(eventToken: coins_store_impression))
    }
    
    func pointPurchaseItemClick() {
        Adjust.trackEvent(ADJEvent(eventToken: purchase_item_click))
    }
    
    func pointPurchaseCancel() {
        Adjust.trackEvent(ADJEvent(eventToken: purchase_cancel))
    }
    
    func pointExchangeSuccessLikeTotal() {
        Adjust.trackEvent(ADJEvent(eventToken: exchange_success_like_total))
    }
    
    func pointExchangeSuccessFollowerTotal() {
        Adjust.trackEvent(ADJEvent(eventToken: exchange_success_follower_total))
    }
    
    func pointPurchaseFollowerSuccessTotal() {
        Adjust.trackEvent(ADJEvent(eventToken: purchase_follower_success_total))
    }
    
    func pointAppBaselineShow() {
        Adjust.trackEvent(ADJEvent(eventToken: app_baseline_show))
    }
    
    func pointLoginButtonClick() {
        Adjust.trackEvent(ADJEvent(eventToken: login_button_click))
    }
    
    func pointLogin_Success_OneST() {
        guard let _ = UserDefaults.standard.string(forKey: "login_success_1st") else {
            Adjust.trackEvent(ADJEvent(eventToken: login_success_1st))
            UserDefaults.standard.set("login_success_1st", forKey: "login_success_1st")
            return
        }
    }
    
    func pointLoginButtonOneSTClick() {
        guard let _ = UserDefaults.standard.string(forKey: "login_button_1stclick") else {
            Adjust.trackEvent(ADJEvent(eventToken: login_button_1stclick))
            UserDefaults.standard.set("login_button_1stclick", forKey: "login_button_1stclick")
            return
        }
    }
    
    func pointAppBaselineOneSTshow() {
        guard let _ = UserDefaults.standard.string(forKey: "app_baseline_1stshow") else {
            Adjust.trackEvent(ADJEvent(eventToken: app_baseline_1stshow))
            UserDefaults.standard.set("app_baseline_1stshow", forKey: "app_baseline_1stshow")
            return
        }
    }
    
    func pointAppLanchOneST() {
        guard let _ = UserDefaults.standard.string(forKey: "app_launch_1st") else {
            Adjust.trackEvent(ADJEvent(eventToken: app_launch_1st))
            UserDefaults.standard.set("app_launch_1st", forKey: "app_launch_1st")
            return
        }
    }
}
