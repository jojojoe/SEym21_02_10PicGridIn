//
//  AdherePostModel.swift
//  Adjust
//
//  Created by 薛忱 on 2020/9/14.
//

import UIKit
import SwiftyJSON

class AdherePostModel: NSObject {
    
    var managerBalance = 0
    var adhereBanlance = 0
    var repostBanlance = 0
    var banlance = 0
    var userID = 0
    var instUserID = 0
    var instFullName = ""
    var profileUrl = ""

    static func createData(data: Data) -> Array<AdherePostModel> {
        
        var resultArray: Array<AdherePostModel> = []
        let jsonData = JSON.init(from: data)
                
        for subJson in jsonData?.array ?? [] {
            let model = AdherePostModel()
            model.managerBalance = subJson["managerBalance"].int ?? 0
            model.adhereBanlance = subJson["f\("ollo")wBalance"].int ?? 0
            model.repostBanlance = subJson["repostBalance"].int ?? 0
            model.banlance = subJson["balance"].int ?? 0
            model.userID = subJson["user"]["id"].int ?? 0
            model.instUserID = subJson["user"]["instUserId"].int ?? 0
            model.instFullName = subJson["user"]["instaFullName"].string ?? ""
            model.profileUrl = subJson["user"]["profileUrl"].string ?? ""
            
            if model.profileUrl.count > 0 {
                resultArray.append(model)
            }
        }
        return resultArray
    }
}

