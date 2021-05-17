//
//  NativeConfigManage.swift
//  Adjust
//
//  Created by 薛忱 on 2020/8/4.
//

import UIKit
import Alertift

class NativeConfigManage: NSObject {
    
    var config: NativeConfig?
    var retryCount = 3
    
    public static let `default` = NativeConfigManage()
    private override init() {
    }
    
    func requestNatieConfig(complete: @escaping (() -> Void)) {
        RequestNetWork.requestNativeCfgConfig(success: { model in
            self.config = model
            complete()
        }) { (error) in
            complete()
            
            Alertift.alert(title: error.localizedDescription, message: nil)
            .action(.cancel("OK")) { _, _, _ in
            }
            .show(on: UIApplication.rootController?.visibleVC, completion: nil)
        }
    }

}
