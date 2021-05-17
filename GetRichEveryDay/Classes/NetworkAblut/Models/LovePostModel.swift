//
//  LovePostModel.swift
//  Adjust
//
//  Created by 薛忱 on 2020/9/14.
//

import UIKit
import SwiftyJSON

class LovePostModel: NSObject {
    
    var ordertyep = 0
    var orderID = 0
    var orderOwner_fullName = ""
    var orderOwner_userid = 0
    var orderOwner_ID = 0
    var orderOwner_profileUrl = ""
    var media_low_resolution_url = ""
    var media_thumbnail_url = ""
    var media_id = ""
    
    static func createData(data: Data) -> Array<LovePostModel> {
        
        var resultArray: Array<LovePostModel> = []
        let jsonData = JSON.init(from: data)
                
        for subJson in jsonData?["likeOrderList"].array ?? [] {
            let model = LovePostModel()
            model.ordertyep = subJson["orderType"].int ?? 0
            model.orderID = subJson["orderId"].int ?? 0
            model.orderOwner_fullName = subJson["orderOwner"]["i\("nst")aFullName"].string ?? ""
            model.orderOwner_userid = subJson["orderOwner"]["instUserId"].int ?? 0
            model.orderOwner_ID = subJson["orderOwner"]["id"].int ?? 0
            model.orderOwner_profileUrl = subJson["orderOwner"]["profileUrl"].string ?? ""
            model.media_low_resolution_url = subJson["media"]["low_resolution_url"].string ?? ""
            model.media_thumbnail_url = subJson["media"]["thumbnail_url"].string ?? ""
            model.media_id = subJson["media"]["media_id"].string ?? ""
            
            if model.media_thumbnail_url.count > 0 {
                resultArray.append(model)
            }
            
        }
        return resultArray
    }
}
