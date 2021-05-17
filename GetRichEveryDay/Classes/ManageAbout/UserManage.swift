//
//  UserManage.swift
//  Adjust
//
//  Created by 薛忱 on 2020/7/31.
//

import UIKit
import CoreTelephony
import AdSupport

class UserManage: NSObject {
    static let `default` = UserManage()
    var userModels: Array<UserModel> = []
    var currentUserModel: UserModel?
    
    private override init() {
    }
    
    func changeCurrentUserCoins(coinsNum: Int) {
        self.currentUserModel?.userNativeCoinsNum = coinsNum
        NotificationCenter.default.post(name: .GREDUserCoinsChange, object: nil)
    }
        
    func assignmentUserModel(model: UserModel) {
        
        userModels = userModels.filter({ (item) -> Bool in
            return item.userCore_ID != model.userCore_ID
        })
        
        model.isCurrent = true
        self.currentUserModel = model
        
        for model in userModels {
            model.isCurrent = false
        }
        
        self.userModels.insert(model, at: 0)
    }
    
    func selectUserLogin(userIndex: Int) {
        guard let selectUserID = self.userModels[userIndex].userNativeID else {
            return
        }
        
        self.userModels = userModels.sorted(by: { (item1, item2) -> Bool in
            return item1.userNativeID == selectUserID ? true : false
        })
        
        self.assignmentUserModel(model: self.userModels[0])
    }
    
    func logoutUser() {
        guard let currentUser = self.currentUserModel else {
            return
        }
        // 删除cacha
        MarsCache.removeUser(model: currentUser)
        let currentCoreID = currentUser.userCore_ID
        userModels = userModels.filter({ (item) -> Bool in
            return item.userCore_ID != currentCoreID
        })
        
        if self.userModels.count > 0 {
            self.assignmentUserModel(model: self.userModels[0])
            UserManage.requestNativeUserInfoAndNodes(userName: UserManage.default.currentUserModel?.userName ?? "",
                                                     showAd: true,
                                                     showHub: true)
            
        } else {
            self.currentUserModel = nil
            NotificationCenter.default.post(name: .GREDUserChange, object: nil)
            
        }
    }
    
    func validationUserLogIn() -> Bool {
        if currentUserModel == nil {
            LogInManage.showLoginView(controller: UIViewController.currentViewController() ?? UIViewController())
            return false
        }
        return true
    }
    
    /// 当前用户的帖子
    func assignmentCurrentUserCoreInfo(data: Data) {
        self.currentUserModel?.assignmentCoreInfo(data: data)
    }
    
    static func userInfoUpload(showHub: Bool = true) {
        guard let userName = UserManage.default.currentUserModel?.userName else {
            return
        }
        requestNativeUserInfoAndNodes(userName: userName, showAd: false, showHub: showHub)
    }
    
    /// 请求core的帖子 和 native的 user info, showAd: 当前是倒量，以后会是promootion 等
    static func requestNativeUserInfoAndNodes(userName: String = UserManage.default.currentUserModel?.userName ?? "",
                                              showAd: Bool = false,
                                              showHub: Bool = true) {
        
        if showHub {
            HubManager.show()
        }
    
        RequestNetWork.requestProfile(name: userName, success: { (data) in
            UserManage.default.assignmentCurrentUserCoreInfo(data: data)
            
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
            
            let snString = "unknown"
            let adID = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
            let strUudi = snString + "_" + adID + "_" + deviceID
            let currentUserModel = UserManage.default.currentUserModel
            var operatorCode = (CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileCountryCode ?? "") + (CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode ?? "")
            operatorCode = operatorCode.count < 5 ? "000000" : operatorCode
            
            
            RequestNetWork.requestNativeSession(profileUrl: currentUserModel?.userIconUrl ?? "",
                                                foreverCount: currentUserModel?.userLoveNum ?? 0,
                                                foreveringCount: currentUserModel?.userAdheretNum ?? 0,
                                                fullName: currentUserModel?.userFullName ?? "",
                                                userName: currentUserModel?.userName ?? "",
                                                userID: currentUserModel?.userCore_ID ?? "",
                                                mediaCount: currentUserModel?.nodesNum ?? 0,
                                                tagCount: 0,
                                                userType: 0,
                                                isPrivate: (currentUserModel?.isPrivate ?? false) ? 1 : 0,
                                                clientType: 0,
                                                vpnStatus: vpnisOn,
                                                operatorType: operatorCode,
                                                countryType: CTTelephonyNetworkInfo().subscriberCellularProvider?.isoCountryCode ?? "cn",
                                                deviceId: adID,
                                                uuid: strUudi, success: { (result) in
                                                    
                                                    guard let model = UserManage.default.currentUserModel else { return }
                                                    
                                                    model.assignmentNativeInfo(data: result)
                                                    MarsCache.assignmentUser(model: model)
                                                    NotificationCenter.default.post(name: .GREDUserChange, object: nil)
                                                    if showAd {
//                                                        DaoLiangManager.default.showDaoLiang()
                                                    }
                                                    HubManager.hide()
            }) { (error) in
                debugPrint(error)
                UserManage.default.logoutUser()
//                UserManage.default.currentUserModel = nil
                if UserManage.default.currentUserModel == nil {
                    LogInManage.showLoginView(controller: UIViewController.currentViewController()!)
                }
                HubManager.hide()
                HubManager.error("Login error")
            }
            
            
        }) { (errorString) in
            debugPrint(errorString)
            UserManage.default.logoutUser()
            if UserManage.default.currentUserModel == nil {
                LogInManage.showLoginView(controller: UIViewController.currentViewController()!)
            }
//            UserManage.default.currentUserModel = nil
            HubManager.hide()
            HubManager.error("Login error")
        }
    }
}
