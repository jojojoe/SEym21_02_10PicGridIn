//
//  LogInManage.swift
//  Adjust
//
//  Created by 薛忱 on 2020/7/31.
//

import UIKit
import TTIGLoginProject
import SwiftyJSON

enum ELoginStatus {
    case EWeb
    case EApi
}

typealias OperationBlock = () -> Void

class LogInManage: NSObject {
    
    public static let `default` = LogInManage()
    public var showedLoginVC = false
    
    private override init() {
    }
    
    static func showLoginView(controller: UIViewController) {
        
        let showed = LogInManage.default.showedLoginVC
        
        if showed || UserManage.default.currentUserModel != nil {
            showNativeView(controller: controller)
            
        } else {
            let loginVC = LoginViewController()
            controller.presentFullScreen(loginVC)
        }
    }
    
    static func showNativeView(controller: UIViewController) {
        let config = NativeConfigManage.default.config

        switch config?.cfgLoginSaram ?? 0 {
        case 0:
            self.showCoreWebLogin(controller: controller)
            break

        case 1:
            self.showCoreApiLogin(controller: controller)
            break
        default:
            break
        }
    }
    
    /// Core Api login
    static private func showCoreApiLogin(controller: UIViewController) {
        let vc = TTLoginViewController()
        vc.showCloseBtn = true
        vc.view.backgroundColor = .white
        
        
        var loginUserDic: [AnyHashable: Any]?
        var cookies: String?
        vc.loginComplete = { success, _, _, dict, cookieString in
            
            AdjustManage.sharedInstance.pointLoginButtonOneSTClick()
            AdjustManage.sharedInstance.pointLoginButtonClick()
            
            guard success else { return }
            loginUserDic = dict
            cookies = cookieString
        }
        vc.closeLoginPageHandler = {
            guard let loginUserDic = loginUserDic, let cookies = cookies else { return }
            showInsApiLoginNext(loginUserDic: loginUserDic, cookies: cookies)
            AdjustManage.sharedInstance.pointLoginSuccessTotal()
            AdjustManage.sharedInstance.pointLogin_Success_OneST()
            NotificationCenter.default.post(name: .GREDLoginPageDismiss, object: nil)
        }
        
        
        controller.presentVC(presentVC: vc)
    }
    
    private static func showInsApiLoginNext(loginUserDic: [AnyHashable: Any]?, cookies: String?) {
       
        let data = loginUserDic?.jsonData()
        UserManage.default.assignmentUserModel(model: UserModel.createModel(data: data!, cookies: cookies!))
        self.requestNativeUserInfoAndNodes(userName: (UserManage.default.currentUserModel?.userName)!, showAd: true)
    }
    
    /// Core web login
    static private func showCoreWebLogin(controller: UIViewController?) {
        let vc = TTNativeWebLoginVC()
        vc.showCloseBtn = true
//        vc.view.backgroundColor = .white
        // adjust

        var loginUserDic: [String: String]?
        var cookies: [String: String]?
        vc.loginComplete = { _, cookiesDict in
            AdjustManage.sharedInstance.pointLoginButtonOneSTClick()
            AdjustManage.sharedInstance.pointLoginButtonClick()
            cookies = cookiesDict
            debugPrint("*-*-* loginComplete *** \(cookiesDict)")
        }
        vc.getUserInfoComplete = { success, _, userDetailsDic in
            guard success else { return }
            loginUserDic = userDetailsDic
            debugPrint("*-*-* getUserInfoComplete *** \(userDetailsDic)")
        }

        vc.closeLoginPageHandler = {
            guard let loginUserDic = loginUserDic, let cookies = cookies else { return }
            self.loginWeb(loginUserDic: loginUserDic, cookies: cookies)
            debugPrint("*-*-* closeLoginPageHandler *** ")
            
            AdjustManage.sharedInstance.pointLoginSuccessTotal()
            AdjustManage.sharedInstance.pointLogin_Success_OneST()
            NotificationCenter.default.post(name: .GREDLoginPageDismiss, object: nil)
        }
        controller?.presentVC(presentVC: vc)
    }
    
    private static func loginWeb(loginUserDic: [String: String], cookies: [String: String]) {
        print(loginUserDic)
        UserManage.default.assignmentUserModel(model: UserModel.createMode(dataDic: loginUserDic, cookies: cookies))
        self.requestNativeUserInfoAndNodes(userName: (UserManage.default.currentUserModel?.userName)!, showAd: true)
    }
    
    /// 请求core的帖子 和 native的 user info
    static func requestNativeUserInfoAndNodes(userName: String, showAd: Bool) {
        AdjustManage.sharedInstance.pointLoginSucessSesssion()
        UserManage.requestNativeUserInfoAndNodes(userName: userName, showAd: showAd)
    }
}
