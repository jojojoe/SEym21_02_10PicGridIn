//
//  MarsCache.swift
//  Adjust
//
//  Created by 薛忱 on 2020/8/5.
//

import UIKit

class MarsCache: NSObject {
    
    static let inTestStr = "inTest"
    static let purchaseStr = "purchase"
    static let purchaseLoactionPrice = "purchaseLoactionPrice"
    static let userList = "userList"
    
    static func assignmentInTest(inTest: Bool) {
        let def = UserDefaults.standard
        def.set(inTest, forKey: inTestStr)
        def.synchronize()
    }
    
    static func obtainInTest() -> Bool {
        return UserDefaults.standard.bool(forKey: inTestStr)
    }
    
    static func assignmentPurchaseItems(purchaseData: Data) {
        let def = UserDefaults.standard
        def.set(purchaseData, forKey: purchaseStr)
        def.synchronize()
    }
    
    static func obtainPurchaseItems() -> Data? {
        return UserDefaults.standard.data(forKey: purchaseStr)
    }
    
    static func assignmentPurchaseLoactionPrice(locationPrice: Dictionary<String, String>) {
        let def = UserDefaults.standard
        def.set(locationPrice, forKey: purchaseLoactionPrice)
        def.synchronize()
    }
    
    static func obtainPurchaseLoactionPrice() -> Dictionary<String, String>? {
        return UserDefaults.standard.dictionary(forKey: purchaseLoactionPrice) as? Dictionary<String, String>
    }
    
    static func assignmentUser(model: UserModel) {
        let def = UserDefaults.standard
        var arrayList: Array<Dictionary<String, Any>>? = []
        
        
        if let defArray = def.array(forKey: userList) as? Array<Dictionary<String, Any>> {
            arrayList = defArray
        }
        
        let userDic: Dictionary<String, Any> = [
            "userName" : model.userName ?? "",
            "userFullName" : model.userFullName ?? "",
            "userNativeID" : model.userNativeID ?? "",
            "userNativeSession" : model.userNativeSession ?? "",
            "userNativeCoinsNum" : model.userNativeCoinsNum ?? "",
            "userLevel" : model.userLevel ?? "",
            "isPrivate" : model.isPrivate,
            "userIconUrl" : model.userIconUrl ?? "",
            "userAdheretNum" : model.userAdheretNum,
            "userLoveNum" : model.userLoveNum,
            "userCore_ID" : model.userCore_ID ?? "",
            "userCore_mid" : model.userCore_mid ?? "",
            "userCore_cookieString" : model.userCore_cookieString ?? "",
            "userCore_csrftoken" : model.userCore_csrftoken ?? "",
            "userCore_rur" : model.userCore_rur ?? "",
            "userCore_Session" : model.userCore_Session ?? "",
            "userCore_urlgen" : model.userCore_urlgen ?? "",
            "userIsCoreApiLogin" : model.userIsCoreApiLogin,
            "isCurrent" : model.isCurrent,
            "nodesNum" : model.nodesNum ?? "",
            "openWebBuy" : model.openWebBuy,
            "feedbackEmail" : model.feedbackEmail ?? ""
        ]
        
        arrayList = arrayList?.filter({ (dic) -> Bool in
            return (dic["userCore_ID"] as? String ?? "") != model.userCore_ID
        })
        
        arrayList?.insert(userDic, at: 0)
        def.set(arrayList, forKey: userList)
        def.synchronize()
    }
    
    static func removeUser(model: UserModel) {
        let def = UserDefaults.standard
        var arrayList: Array<Dictionary<String, Any>>? = []
        
        
        if let defArray = def.array(forKey: userList) as? Array<Dictionary<String, Any>> {
            arrayList = defArray
        }
        
        arrayList = arrayList?.filter({ (dic) -> Bool in
            return (dic["userCore_ID"] as? String ?? "") != model.userCore_ID
        })
        
        def.set(arrayList, forKey: userList)
        def.synchronize()
    }
    
    static func obtainUserList() {
        let def = UserDefaults.standard
        
        guard let arrayList: Array<Dictionary<String, Any>> = def.array(forKey: userList) as? Array<Dictionary<String, Any>> else {
            return
        }
        
        
        var arrayModels: Array<UserModel> = []
        
        for userDic in arrayList {
            let userModel = UserModel()
            userModel.userName = userDic["userName"] as? String
            userModel.userFullName = userDic["userFullName"] as? String
            userModel.userNativeID = userDic["userNativeID"] as? String
            userModel.userNativeSession = userDic["userNativeSession"] as? String
            userModel.userNativeCoinsNum = userDic["userNativeCoinsNum"] as? Int
            userModel.userLevel = userDic["userLevel"] as? Int
            userModel.isPrivate = userDic["isPrivate"] as! Bool
            userModel.userIconUrl = userDic["userIconUrl"] as? String
            userModel.userAdheretNum = userDic["userAdheretNum"] as! Int
            userModel.userLoveNum = userDic["userLoveNum"] as! Int
            userModel.userCore_ID = userDic["userCore_ID"] as? String
            userModel.userCore_mid = userDic["userCore_mid"] as? String
            userModel.userCore_cookieString = userDic["userCore_cookieString"] as? String
            userModel.userCore_csrftoken = userDic["userCore_csrftoken"] as? String
            userModel.userCore_rur = userDic["userCore_rur"] as? String
            userModel.userCore_Session = userDic["userCore_Session"] as? String
            userModel.userCore_urlgen = userDic["userCore_urlgen"] as? String
            userModel.userIsCoreApiLogin = userDic["userIsCoreApiLogin"] as! Bool
            userModel.isCurrent = userDic["isCurrent"] as! Bool
            userModel.nodesNum = userDic["nodesNum"] as? Int
            userModel.openWebBuy = userDic["openWebBuy"] as? Int ?? 0
            userModel.feedbackEmail = userDic["feedbackEmail"] as? String
            arrayModels.append(userModel)
        }
        let userMange = UserManage.default
        userMange.userModels = arrayModels
    }
    
    static func obtainUser() -> UserModel? {
        let def = UserDefaults.standard
        
        guard let arrayList: Array<Dictionary<String, Any>> = def.array(forKey: userList) as? Array<Dictionary<String, Any>> else {
            return nil
        }
        
        
        var arrayModels: Array<UserModel> = []
        
        for userDic in arrayList {
            let userModel = UserModel()
            userModel.userName = userDic["userName"] as? String
            userModel.userFullName = userDic["userFullName"] as? String
            userModel.userNativeID = userDic["userNativeID"] as? String
            userModel.userNativeSession = userDic["userNativeSession"] as? String
            userModel.userNativeCoinsNum = userDic["userNativeCoinsNum"] as? Int
            userModel.userLevel = userDic["userLevel"] as? Int
            userModel.isPrivate = userDic["isPrivate"] as! Bool
            userModel.userIconUrl = userDic["userIconUrl"] as? String
            userModel.userAdheretNum = userDic["userAdheretNum"] as! Int
            userModel.userLoveNum = userDic["userLoveNum"] as! Int
            userModel.userCore_ID = userDic["userCore_ID"] as? String
            userModel.userCore_mid = userDic["userCore_mid"] as? String
            userModel.userCore_cookieString = userDic["userCore_cookieString"] as? String
            userModel.userCore_csrftoken = userDic["userCore_csrftoken"] as? String
            userModel.userCore_rur = userDic["userCore_rur"] as? String
            userModel.userCore_Session = userDic["userCore_Session"] as? String
            userModel.userCore_urlgen = userDic["userCore_urlgen"] as? String
            userModel.userIsCoreApiLogin = userDic["userIsCoreApiLogin"] as! Bool
            userModel.isCurrent = userDic["isCurrent"] as! Bool
            userModel.nodesNum = userDic["nodesNum"] as? Int
            userModel.openWebBuy = userDic["openWebBuy"] as? Int ?? 0
            userModel.feedbackEmail = userDic["feedbackEmail"] as? String
            arrayModels.append(userModel)
        }
        let userMange = UserManage.default
        userMange.userModels = arrayModels
        
        if userMange.userModels.count > 0 {
            return userMange.userModels[0]
        }
        
        return nil
    }
    
    static func eventStatus(tagKey: String) -> Bool {
        let status = UserDefaults.standard.bool(forKey: tagKey)
        return status
    }

    static func evenRecord(tagKey: String) {
        let def = UserDefaults.standard
        def.set(true, forKey: tagKey)
        def.synchronize()
    }
    
    static func userSalesOrderLimitation(msg: String, sleepTime: Int, limitReached: Bool) {
        guard let userCoreID = UserManage.default.currentUserModel?.userCore_ID else {
            return
        }
        
        let userDefsKey = userCoreID + "SalesOrder"
        let dic: Dictionary<String, Any> = [
            "msg" : msg,
            "sleepTime" : sleepTime,
            "limitReached" : limitReached,
            "time" : limitReached == true ? Date().timeIntervalSince1970 : 0
        ]
        UserDefaults.standard.set(dic, forKey: userDefsKey)
    }
    
    static func obtainUsersalesOrderLimitation() -> SalesOrderLimitationModel? {
        guard let userCoreID = UserManage.default.currentUserModel?.userCore_ID else {
            return nil
        }
        
        let userDefsKey = userCoreID + "SalesOrder"
        let dic = UserDefaults.standard.dictionary(forKey: userDefsKey)
        let model = SalesOrderLimitationModel()
        model.msg = (dic?["msg"] as? String) ?? "We limit your fo\("llow")/l\("ike") actions to avoid getting “Action Blocked” on your account from In\("stag")ram. You will be able to continue after countdown."
        model.sleepTime = (dic?["sleepTime"] as? Int) ?? 0
        model.limitReached = (dic?["limitReached"] as? Bool) ?? false
        model.secondsTime = (dic?["time"] as? TimeInterval) ?? 0
        return model
    }
}



