//
//  PublicTool.swift
//  Alamofire
//
//  Created by 薛忱 on 2020/7/28.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
import SwifterSwift
import ZKProgressHUD

typealias ButtonClickBlock = () -> Void

let screenWidth_CGFloat = UIScreen.main.bounds.width
let screenWidth_Int = Int(UIScreen.main.bounds.width)

let screenHeight_CGFloat = UIScreen.main.bounds.height
let screenHeight_Int = Int(UIScreen.main.bounds.height)

func currentDiviceIsFullSceen() -> Bool {
    
    if let keyWindow = UIApplication.shared.keyWindow {
        return keyWindow.safeAreaInsets.top > CGFloat(20) ? true : false
    } else {
        let keyW = UIApplication.shared.windows[0]
        return keyW.safeAreaInsets.top > CGFloat(20) ? true : false
    }
}

func getNavigationViewHeight() -> Int {
    return currentDiviceIsFullSceen() ? 88 : 64
}

/// 整数转换 K M
func digitalFormat(num: Int) -> String {
    
    if num >= 100000 && num < 1000000 {
        return String(format: "%.1f", Float(num) / 1000) + "K"
    } else if num >= 1000000 {
        return String(format: "%.1f", Float(num) / 1000000) + "M"
    } else {
        return String(num)
    }
}

/// bundleID
func obtainBundleIdentifier() -> String {
    var bundleID = Bundle.main.bundleIdentifier ?? ""
    debugOnly {
        bundleID = debugBundleIdentifier
    }
    
    return bundleID
}

// font
//let fontHiraginoSansW3 = "HiraginoSans-W3"
//let fontHiraginoSansW6 = "HiraginoSans-W6"
let fontHiraginoSansW3 = "Avenir-Medium"
let fontHiraginoSansW6 = "Avenir-Heavy"
let fontAvenirHeavy = "Avenir-Heavy"
let fontAvenirMedium = "Avenir-Medium"
let fontAvenirBlack = "Avenir-Black"
let fontPingFangSCSemibold = "PingFangSC-Semibold"


// unicode string
let uStrf = "\u{0066}\u{006f}\u{006c}\u{006c}\u{006f}\u{0077}"
let uStrF = "\u{0046}\u{006f}\u{006c}\u{006c}\u{006f}\u{0077}"
let uStrFing = "\u{0046}\u{006f}\u{006c}\u{006c}\u{006f}\u{0077}\u{0069}\u{006e}\u{0067}"
let uStrOW = "\u{004f}\u{0066}\u{0066}\u{0057}\u{0061}\u{006c}\u{006c}"
let uStrl = "\u{006c}\u{0069}\u{006b}\u{0065}"


func debugOnly(_ action: () -> Void) {
    assert(
        { action(); return true }()
    )
}


extension NSNotification.Name {
    static let GREDUserChange = Notification.Name("notification_GRED_UserChange")
    static let GREDReloadData = Notification.Name("notification_GRED_ReloadData")
    static let GREDTabBarSelectIndex = Notification.Name("notification_GRED_TabBarSelectIndex")
    static let GREDJumpToStore = Notification.Name("notification_GRED_JumpToStore")
    static let GREDUserCoinsChange = Notification.Name("notification_GRED_coinsChange")
    static let GREDLoginPageDismiss = Notification.Name("notification_GRED_loginPagedismiss")
}


enum EIRequestError: Error {
    case verificationFailed
    case networkFailure
    case apiLogout
    
    var errorDescription: String {
        switch self {
        case .verificationFailed:
            return "This account is invalid, please try again"
        case .networkFailure:
            return "Network error, please try again"
        case .apiLogout:
            return "Login Required"
        }
    }
}

extension UIApplication {
    static var rootController: UIViewController? {
        return shared.keyWindow?.rootViewController
    }
}

extension DispatchQueue {
    private static var _onceTracker = [String]()
    public class func once(token: String, block: () -> ()) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
    
    func async(block: @escaping ()->()) {
        self.async(execute: block)
    }
    
    func after(time: DispatchTime, block: @escaping ()->()) {
        self.asyncAfter(deadline: time, execute: block)
    }
}
