//
//  FTM.swift
//  GetRichEveryDay_Example
//
//  Created by 薛忱 on 2021/2/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class FTM: NSObject {
    
    class func obtainItm() -> UInt64 {
        let itmKey = "lObw4oNFS69vKrt1hCTyylRC5N"
        let keyChainManager = Keychain(service: obtainBundleIdentifier())
        
        if let itm = keyChainManager[itmKey] {
            return UInt64(itm) ?? Date().milliStamp
        } else {
            var itm = Date().milliStamp * 4
            do {
                try keyChainManager.set(String(itm), key: itmKey)
            } catch _ {
                return Date().milliStamp
            }
                        
            let itmStr = keyChainManager[itmKey] ?? String(Date().milliStamp)
            return UInt64(itmStr) ?? Date().milliStamp
        }
    }
    
}

extension Date {

    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : UInt64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = UInt64(round(timeInterval*1000))
        return millisecond
    }
}
