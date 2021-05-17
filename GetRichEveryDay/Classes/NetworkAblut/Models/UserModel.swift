//
//  UserModel.swift
//  Adjust
//
//  Created by 薛忱 on 2020/7/31.
//

import UIKit
import SwiftyJSON

class UserModel: NSObject {
    
    var userName: String?
    var userFullName: String?
    var userNativeID: String?
    var userNativeSession: String?
    var userNativeCoinsNum: Int?
    var userLevel: Int? = 0
    var isPrivate: Bool = false
    var userIconUrl: String?
    var userAdheretNum: Int = 0
    var userLoveNum: Int = 0
    var userCore_ID: String?
    var userCore_mid: String?
    var userCore_cookieString: String?
    var userCore_csrftoken: String?
    var userCore_rur: String?
    var userCore_Session: String?
    var userCore_urlgen: String?
    var userIsCoreApiLogin: Bool = true
    var isCurrent: Bool = false
    var openWebBuy: Int = 0
    var nodesNum: Int? = 0
    var feedbackEmail: String?
    var userOneLoveGetCoins = "1"
    var userOneAdhereGetCoins = "4"
    var nodes: Array<Node> = []

    
    class func createMode(dataDic: Dictionary<String, String>, cookies: Dictionary<String, String>) -> UserModel {
        let userModel = UserModel()
        userModel.userName = dataDic["username"]
        userModel.userIconUrl = dataDic["profile_pic_url"]
        userModel.userCore_mid = cookies["mid"]
        userModel.userCore_ID = cookies["ds_user_id"]
        userModel.userCore_rur = cookies["rur"]
        userModel.userCore_csrftoken = cookies["csrftoken"]
        userModel.userCore_Session = cookies["sessionid"]
        userModel.userIsCoreApiLogin = false
        userModel.userCore_cookieString = cookies.cookiesDictToModel()
                
        return userModel
    }
    
    class func createModel(data: Data, cookies: String) -> UserModel {
        let jsonData = JSON.init(from: data)
        let userModel = UserModel()
        userModel.userName = jsonData?["username"].string
        userModel.userIconUrl = jsonData?["profile_pic_url"].string
        userModel.userCore_ID = jsonData?["pk"].int?.toString() ?? "0"
        
        let tokenArray = cookies.components(separatedBy: "; ")
        print(tokenArray)
        
        for str in tokenArray {
            if str.contains("mid") {
                userModel.userCore_mid = str.components(separatedBy: "=")[1]
            } else if str.contains("csrftoken") {
                userModel.userCore_csrftoken = str.components(separatedBy: "=")[1]
            } else if str.contains("sessionid") {
                userModel.userCore_Session = str.components(separatedBy: "=")[1]
            } else if str.contains("rur") {
                userModel.userCore_rur = str.components(separatedBy: "=")[1]
            } else if str.contains("urlgen") {
                userModel.userCore_urlgen = str.components(separatedBy: "=")[1]
            }
        }
        
//        let token = userModel.userCore_csrftoken ?? ""
//        let session = userModel.userCore_Session ?? ""
//        let mid = userModel.userCore_mid ?? ""
//        let urlgen = userModel.userCore_urlgen ?? ""
//        let rur = userModel.userCore_rur ?? ""
//        let userName = userModel.userName ?? ""
//        let userID = userModel.userCore_ID ?? ""
//
//        let cookeONE = "csrftoken=" + token + "; " + "sessionid=" + session + "; " + "mid=" + mid + "; " + "urlgen=" + urlgen + "; "
//        let cookeTwo = "rur=" + rur + "; " + "ds_user=" + userName + "; " + "ds_user_id=" + userID + ";"
        userModel.userCore_cookieString =  cookies.convertCookies()

        return userModel
    }
    
    class func createModel(loginUserDic: [String: String], cookies: [String: String]) -> UserModel {
        let userModel = UserModel()
        userModel.userIsCoreApiLogin = false
        
        userModel.userName = loginUserDic["username"]
        userModel.userIconUrl = loginUserDic["profile_pic_url"]
        userModel.userCore_mid = cookies["mid"]
        userModel.userCore_csrftoken = cookies["csrftoken"]
        userModel.userCore_rur = cookies["rur"]
        userModel.userCore_Session = cookies["sessionid"]
        
        return userModel
    }
    
    /// inst info
    func assignmentCoreInfo(data: Data) {
        let jsonData = JSON.init(from: data)
        self.nodesNum = jsonData?["user"]["edge_owner_to_timeline_media"]["count"].int ?? 0
        self.isPrivate = jsonData?["user"]["is_private"].bool ?? false
        self.userAdheretNum =  jsonData?["user"]["edge_followed_by"]["count"].int ?? 0
        self.userLoveNum = jsonData?["user"]["edge_follow"]["count"].int ?? 0
        self.userFullName = jsonData?["user"]["full_name"].string
        
//        for nodeJson in jsonData?["user"]["edge_owner_to_timeline_media"]["edges"].array ?? [] {
//            let node = Node()
//            node.ID = nodeJson["node"]["id"].string ?? ""
//            node.shortcode = nodeJson["node"]["shortcode"].string
//            node.edgeLoveBy = nodeJson["node"]["edge_liked_by"]["count"].int
//            node.thumbnailSrc = nodeJson["node"]["thumbnail_src"].url
//            node.displayUrl = nodeJson["node"]["display_url"].url
//            node.typename = nodeJson["node"]["__typename"].string
//            node.edgeMediaToComment = nodeJson["node"]["edge_media_to_comment"]["count"].int
//            node.isVideo = nodeJson["node"]["is_video"].int
//            self.nodes.append(node)
//        }
    }
    
    /// native user info
    func assignmentNativeInfo(data: Data) {
        let jsonData = JSON.init(from: data)
        self.userNativeID = jsonData?["userId"].int?.string ?? ""
        self.userNativeSession = jsonData?["session"].string ?? ""
        self.userNativeCoinsNum = jsonData?["balance"].int ?? 0
        self.userLevel = jsonData?["discounds"]["discoundsTypeId"].int ?? 0
        self.openWebBuy = jsonData?["isSpecialIAPMode"].int ?? 0
        self.feedbackEmail = jsonData?["feedbackEmail"].string
        self.userOneLoveGetCoins = jsonData?[""].string ?? "1"
        self.userOneAdhereGetCoins = jsonData?[""].string ?? "4"
        
        
    }
}

class Node: NSObject {
    var ID: String?
    var shortcode: String?
    var edgeLoveBy: Int?
    var thumbnailSrc: URL?
    var displayUrl: URL?
    var typename: String?
    var edgeMediaToComment: Int?
    var mediaType: Int? //1-image 8-images 2-video
}

private extension Dictionary where Key == String, Value == String {
    func cookiesDictToModel() -> String {
        let cookieString = compactMap { $0 + "=" + $1 }.joined(separator: "; ")
        return cookieString
    }
}

private extension String {
    func convertCookies() -> String? {
        let parameters = ["ds_user", "csrftoken", "ds_user_id",
                          "urlgen", "sessionid", "shbid",
                          "shbts", "rur", "mid"]

        let array = components(separatedBy: "; ")

        var dict = [String: String]()
        array.forEach { str in
            parameters.forEach { parameter in
                if str.contains(parameter),
                    let index = str.range(of: "\(parameter)=")?.upperBound {
                    let item = str.suffix(from: index).description
                    if !item.isEmpty {
                        dict[parameter] = item
                    }
                }
            }
        }

        let cookieString = dict.compactMap { $0 + "=" + $1 }.joined(separator: "; ")
        return cookieString
    }
}
