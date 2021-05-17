//
//  HubManager.swift
//  Adjust
//
//  Created by 薛忱 on 2020/8/6.
//

import UIKit
import ZKProgressHUD

class HubManager: NSObject {
    static func show() {
        guard !ZKProgressHUD.isShowing else { return }
        ZKProgressHUD.show()
    }
    
    static func showHideMask() {
        guard !ZKProgressHUD.isShowing else { return }
        ZKProgressHUD.setMaskBackgroundColor(.clear)
        ZKProgressHUD.show()
    }

    static func hide() {
        ZKProgressHUD.dismiss()
    }

    static func error(_ value: String? = nil) {
        hide()
        ZKProgressHUD.showError(value, autoDismissDelay: 2.0)
    }
    
    static func success(_ value: String? = nil) {
        hide()
        ZKProgressHUD.showSuccess(value, autoDismissDelay: 2.0)
    }
}

