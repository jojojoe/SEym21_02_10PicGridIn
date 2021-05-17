//
//  SalesOrderLimitationModel.swift
//  Adjust
//
//  Created by 薛忱 on 2020/9/17.
//

import UIKit

class SalesOrderLimitationModel: NSObject {
    var msg: String = ""
    var sleepTime: Int = 0
    var limitReached: Bool = false
    var secondsTime: TimeInterval = 0
}
