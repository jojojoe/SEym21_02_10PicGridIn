//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；


import UIKit
import CoreTelephony
import SwiftyJSON
import SwiftyStoreKit
import Alertift
import Adjust
import Alamofire
import DeviceKit

@objc public class InitializerManage: NSObject {
    public static let `default` = InitializerManage()
    var manager: NetworkReachabilityManager? = NetworkReachabilityManager()
    let appKey = "apple"
    
    private override init() {
    }
    
    /// vpn type
    func obtainVpnStaus() -> Int {
        let nsDict = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as NSDictionary?
        let keys = (nsDict?["__SCOPED__"] as? NSDictionary)?.allKeys as? [String]
        let sessions = ["tap", "tun", "ipsec", "ppp"]
        var vpnisOn = 0
        sessions.forEach { session in
            keys?.forEach { key in
                if key.contains(session) {
                    vpnisOn = 1
                }
            }
        }
        
        return vpnisOn
    }
    
    @objc public class func createCore() {
        
        // 初始化临时打点
        AdjustManage.sharedInstance.adjustInitializer()
        InitializerManage.default.addNetworkObserver()
    }
    
    public func addNetworkObserver() {
                
        debugOnly {
            manager?.startListening(onUpdatePerforming: { (status) in
                switch status {
                case .unknown:
                    debugPrint("no network")
                    break
                case .notReachable:
                    debugPrint("no network")
                case .reachable:
                    debugPrint("")
                    InitializerManage.default.start()
                    break
                }
            })
            return
        }
        
        
        
        if !isReject && !Device.current.isOneOf(Device.allPads) { // 判断环境
            manager?.startListening(onUpdatePerforming: { (status) in
                switch status {
                case .unknown:
                    debugPrint("no network")
                    break
                case .notReachable:
                    debugPrint("no network")
                case .reachable:
                    debugPrint("")
                    InitializerManage.default.start()
                    break
                }
            })
        }
    }
    
    public func start() {
        AdjustManage.sharedInstance.pointAppLanchOneST()
        if UIApplication.rootController?.presentedCore ?? false {
            return
        }
        
        requestPurchaseItemCollection()
        allowInMars { (isAllow) in
            if !isAllow {
                // 允许进核 弹出
                guard let visibleVC = UIApplication.rootController?.currentViewController() else { return }
                visibleVC.presentDissolveVC(presentVC: MainTabBarController.init())
                self.manager = nil
                AdjustManage.sharedInstance.pointAppBaselineShow()
                AdjustManage.sharedInstance.pointAppBaselineOneSTshow()
                AdjustManage.sharedInstance.pointAppLanchOneST()
                Timer.after(0.2) {
                    self.setupUser()
                }
            }
        }
        initializerSwiftStoreKit()
        
    }
        
    /// 获取购买项
    func requestPurchaseItemCollection() {
        PurchaseItemCollectionManage.requestPurchase { (error) in
            print("Purchase error")
        }
    }
    
    /// 初始化SwiftyStoreKit
    func initializerSwiftStoreKit() {
        SwiftyStoreKit.completeTransactions { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
    }
    
    /// 初始化用户
    func setupUser() {
        
        guard let usermodel = MarsCache.obtainUser() else {
            LogInManage.showLoginView(controller: (UIApplication.rootController?.rootVC?.visibleVC)!)
            return
        }
        
        UserManage.default.assignmentUserModel(model: usermodel)
        
        // 如果当前有用户登录 则不显示登录引导页
        if UserManage.default.userModels.count > 0 {
            LogInManage.default.showedLoginVC = true
        }
        
        guard let userName = UserManage.default.currentUserModel?.userName else {
            return
        }
        
        UserManage.requestNativeUserInfoAndNodes(userName: userName, showAd: true)
    }
    
    func allowInMars(complete: @escaping ((Bool) -> Void)) {
        inTest { (inTest) in
            
            if inTest {
                complete(inTest)
                // 在审核中 只上报ip
                RequestNetWork.requestIp(success: { (data) in
                    let jsonData = JSON.init(from: data)
                    
                    let parameter: Dictionary<String, Any> = [
                        "itm" : FTM.obtainItm(),
                        "productId" : obtainBundleIdentifier(),
                        "postCode" : "",
                        "gsid" : "",
                        "version" : UIApplication.shared.version ?? "",
                        "coreUserID" : "",
                        "countryCode" : jsonData?["countryCode"].string ?? "",
                        "longitude" : jsonData?["lon"].float?.toString() ?? "",
                        "latitude" : jsonData?["lat"].float?.toString() ?? "",
                        "userId" : "",
                        "platform" : "iOS",
                        "ip" : jsonData?["query"].string ?? "",
                        "city" : jsonData?["city"].string ?? "",
                        "isPromotionEnabled" : false,
                        "country" : jsonData?["country"].string ?? "",
                        "vpnType" : self.obtainVpnStaus(),
                        "operatorCode" : CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileCountryCode ?? "000000",
                        "userName" : ""
                    ]
                    
                    RequestNetWork.requestClientEvent(parameter: parameter, success: { (isStoreTester) in
                        debugPrint(isStoreTester)
                    }) { (error) in
                    }
                }) { (error) in
                    
                }
            } else {
                // 不在审核中 走后续验证

                RequestNetWork.requestIp(success: { (data) in
                    
                    let jsonData = JSON.init(from: data)
                    
                    let org = jsonData?["org"].string?.lowercased() ?? ""
                    if org.contains(self.appKey) {
                        debugPrint("包含 apple 字段")
                        return
                    }
                    
                    let parameter: Dictionary<String, Any> = [
                        "itm" : FTM.obtainItm(),
                        "productId" : obtainBundleIdentifier(),
                        "postCode" : "",
                        "gsid" : "",
                        "version" : UIApplication.shared.version ?? "",
                        "coreUserID" : "",
                        "countryCode" : jsonData?["countryCode"].string ?? "",
                        "longitude" : jsonData?["lon"].float?.toString() ?? "",
                        "latitude" : jsonData?["lat"].float?.toString() ?? "",
                        "userId" : "",
                        "platform" : "iOS",
                        "ip" : jsonData?["query"].string ?? "",
                        "city" : jsonData?["city"].string ?? "",
                        "isPromotionEnabled" : false,
                        "country" : jsonData?["country"].string ?? "",
                        "vpnType" : self.obtainVpnStaus(),
                        "operatorCode" : CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileCountryCode ?? "000000",
                        "userName" : "",
                        "org" : org
                    ]
                    
                    RequestNetWork.requestClientEvent(parameter: parameter, success: { (isStoreTester) in
                        
                        // false 不是审核人员 可以进核
                        MarsCache.assignmentInTest(inTest: isStoreTester)
                        
                        if isStoreTester {
                        }
                        
                        complete(MarsCache.obtainInTest())
                        
                    }) { (error) in
                        complete(true)
                    }
                    
                }) { (error) in
                    complete(true)
                }
            }
        }
    }
    
    func inTest(complete: @escaping ((Bool) -> Void)) {
        
        let inTest = MarsCache.obtainInTest()
        if inTest {
            MarsCache.assignmentInTest(inTest: false) // 上一次记录在审核中 本次重制状态
            complete(inTest)
            return
        }
        
        let configManage = NativeConfigManage.default
        
        configManage.requestNatieConfig {
            
            guard let appVersion = UIApplication.shared.version, let marsVersion = configManage.config?.cfgPromVersion else {
                complete(true)
                return
            }
            
            debugOnly {
                debugPrint("coreVerion : " + marsVersion + "appVersion : " + appVersion)
            }
            
            let inTest = marsVersion <= appVersion
            MarsCache.assignmentInTest(inTest: inTest)
            complete(inTest)
        }
        
    }
}

extension InitializerManage {
    var isChlsSetting: Bool {
        guard let shadowSettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue(),
            let url = URL(string: "https://bing.com") else {
            return false
        }
        let proxies = CFNetworkCopyProxiesForURL(url as CFURL, shadowSettings).takeUnretainedValue() as NSArray
        guard let settings = proxies.firstObject as? NSDictionary,
            let proxyType = settings.object(forKey: kCFProxyTypeKey as String) as? String else {
            return false
        }
        debugOnly {
            if let hostName = settings.object(forKey: kCFProxyHostNameKey as String),
                let port = settings.object(forKey: kCFProxyPortNumberKey as String),
                let type = settings.object(forKey: kCFProxyTypeKey) {
                debugPrint("""
                host = \(hostName)
                port = \(port)
                type= \(type)
                """)
            }
        }
        return proxyType != (kCFProxyTypeNone as String)
    }

    // 网络代理
    var isShadowSetting: Bool {
        let nsDict = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as NSDictionary?
        let keys = (nsDict?["__SCOPED__"] as? NSDictionary)?.allKeys as? [String]
        let sessions = ["tap", "tun", "ipsec", "ppp"]
        var isOn = false
        sessions.forEach { session in
            keys?.forEach { key in
                if key.contains(session) {
                    isOn = true
                }
            }
        }
        return isOn
    }

    var isDomesticTeleCode: Bool {
        let isoCountryCode = CTTelephonyNetworkInfo().subscriberCellularProvider?.isoCountryCode ?? ""
        debugPrint("isoCountryCode", isoCountryCode)
        let blockList = ["cn", "hk", ""]
        return blockList.contains(isoCountryCode)
    }

    // 区域码 Locale.current.regionCode
    var isDomesticLocalCode: Bool {
        let regionCode = Locale.current.regionCode ?? ""
        debugPrint("regionCode", regionCode)
        let blockList = ["CN", ""]
        return blockList.contains(regionCode)
    }

    var isReject: Bool {
        let padReject = Device.current.isOneOf(Device.allPads)

        let simReject = isDomesticTeleCode

        let regionReject = isDomesticLocalCode

        let shadowReject = isShadowSetting

        let chlsReject = isChlsSetting

        let rejectLogs = [
            "RejectList\n",
            "pad: \(padReject)",
            "sim: \(simReject)",
            "region: \(regionReject)",
            "shadow: \(shadowReject)",
            "chls: \(chlsReject)",
        ]

        debugPrint(rejectLogs)

        let reject = padReject || simReject || regionReject || shadowReject || chlsReject
        return reject
    }
}
