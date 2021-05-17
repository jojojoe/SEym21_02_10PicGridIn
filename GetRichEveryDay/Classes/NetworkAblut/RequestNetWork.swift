//
//  RequestNetWork.swift
//  Adjust
//
//  Created by 薛忱 on 2020/7/30.
//

import UIKit
import Alamofire
import DeviceKit
import SwiftyJSON

class RequestNetWork: NSObject {
    
    static func currentToken() -> String {
        return UserManage.default.currentUserModel?.userNativeSession ?? normalToken
    }
    
    /// 获取ip 经纬度 等信息
    static func requestIp(success: @escaping (Data) -> Void, failure: @escaping (_ error: Error) -> Void) {
        let requestUrl = "http://ip-api.com/json"
        let reqeustUrlBackup = "https://ipapi.co/json"
        
        Alamofire.AF.request(requestUrl,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: nil).responseData { (response) in
                            
                            switch response.result {
                            case .success(let data):
                                success(data)
                                break
                            case .failure(_):
                                
                                Alamofire.AF.request(reqeustUrlBackup, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
                                    
                                    switch response.result {
                                    case .success(let data):
                                        success(data)
                                        break
                                    case .failure(let error):
                                        failure(error)
                                        break
                                    }
                                }
                                
                                break
                            }
        }
    }
    
    /// 判断是否进核
    static func requestClientEvent(parameter: [String : Any],
                                   success: @escaping (Bool) -> Void,
                                   failure: @escaping (_ error: Error) -> Void) {
        let requestUrl = requestNativeURL + "/api/misc/clientevent"
        
        Alamofire.AF.request(requestUrl,
                          method: .post,
                          parameters: parameter,
                          encoding: JSONEncoding.default,
                          headers: nil).responseData { (response) in
                            switch response.result {
                            case .success(let data):
                                let json = JSON.init(from: data)
                                success(json?["isStoreTester"].bool ?? true)
                                
                                break
                            case .failure(let error):
                                debugPrint(error)
                                failure(error)
                                break
                            }
        }
    }
    
    /// 获取cfg配置
    static func requestNativeCfgConfig(success: @escaping (NativeConfig) -> Void,
                                      failure: @escaping (_ error: Error) -> Void) {
        let requestUrl = requestNativeURL + "/cfg?productId=\(obtainBundleIdentifier())"

        Alamofire.AF.request(requestUrl,
                          method: .get,
                          headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                
                success(NativeConfig.createModel(json: json))
                break
            case .failure(let error):
                failure(error)
                break
            }
        }
    }
    
    /// adherent / love / store purchase Item
    static func requestPurchaseItems(success: @escaping (_ model: PurchaseItemModelCollection) -> Void,
                                    failure: @escaping (_ error: Error) -> Void) {
        let urlRoute = "/api/iap/items?session=\(currentToken())&productId=\(obtainBundleIdentifier())&lang=zh".gsidURL
        let requestUrl = requestNativeURL + urlRoute
        Alamofire.AF.request(requestUrl,
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: nil).responseData { (response) in
                            
            switch response.result {
            case .success(let data):
                MarsCache.assignmentPurchaseItems(purchaseData: data)
                let model = PurchaseItemModelCollection.createModelCollection(json: data)
                success(model)
                break
            case .failure(let error):
                debugPrint(error)
                failure(error)
                break
            }
        }
    }
    
    /// native profile
    static func requestNativeSession(profileUrl: String, foreverCount: Int, foreveringCount: Int, fullName: String,
                                     userName: String, userID: String, mediaCount: Int, tagCount: Int,
                                     userType: Int, isPrivate: Int, clientType: Int, vpnStatus: Int,
                                     operatorType: String, countryType: String, deviceId: String, uuid: String,
                                     success: @escaping (_ requestData: Data) -> Void,
                                     failure: @escaping (_ error: Error) -> Void) {
        let requestUrl = requestNativeURL + "/api/sessions"
        let boundlID = obtainBundleIdentifier()
        let shortVersion = UIApplication.shared.version ?? ""
        var gsid = userID + userName + shortVersion
        gsid += clientType.toString() + userType.toString()
        gsid = gsid.gsid
        
        let parament: [String : Any] = [
            "productId" : boundlID,
            "parentSession" : currentToken(),
            "clientType" : clientType,
            "version" : shortVersion,
            "userType" : userType,
            "usertagsCount" : tagCount,
            "gsid" : gsid,
            "fo\("llow")erCount" : foreverCount,
            "profileUrl" : profileUrl,
            "instUserId" : userID,
            "fo\("llow")ingCount" : foreveringCount,
            "instaFullName" : fullName,
            "isPrivate" : isPrivate,
            "mediaCount" : mediaCount,
            "name" : userName,
            "userAuxiliary" : [
                "vpnType" : vpnStatus,
                "operatorCode" : operatorType,
                "countryCode" : countryType,
                "deviceId" : deviceId,
                "uuid" : uuid
            ]
        ]
                
        Alamofire.AF.request(requestUrl,
                          method: .post,
                          parameters: parament,
                          encoding: JSONEncoding.default,
                          headers: nil).responseData { (response) in
            switch response.result {
            case .success(let result):
                debugPrint(result)
                success(result)
                break
                
            case .failure(let error):
                debugPrint(error)
                failure(error)
                break
            }
        }
    }
    
    /// 倒量点击倒量
    static func requestReardPost(productScheme: String, deviceID: String, success: @escaping () -> Void) {
        let requestUrl = requestNativeURL + "/misc/irewarddownloadr?session=\(currentToken())"
        Alamofire.AF.request(requestUrl,
                          method: .post,
                          parameters: ["product_id": productScheme, "device_id": deviceID],
                          encoding: JSONEncoding.default,
                          headers: nil).responseJSON { (response) in
                            
                            switch response.result {
                            case .success(let result):
                                debugPrint(result)
                                success()
                                break
                                
                            case .failure(let error):
                                debugPrint(error)
                                //failure(error)
                                break
                            }
        }
    }
    
    /// create Order
    static func requestCreateOrder(isLucky: Bool,
                                   productID: String,
                                   evironment: String,
                                   type: Int,
                                   promID: String?,
                                   isDirectForever: Bool?,
                                   directOrderLoveMediaURL: String?,
                                   directOrderLoveMediaID: String?,
                                   success: @escaping (String?) -> Void,
                                   failure: @escaping (_ error: String) -> Void) {
        
        let requesetURl = requestNativeURL + "/api/trade/order?session=\(currentToken())".gsidURL
        let param: Dictionary<String, Any> = [
            "isPromotionOrder": isLucky.int,
            "productName": productID,
            "environment": evironment,
            "type": type, //native 1, pay 2
            "promId": promID as Any,
            "isDirectFo\("llow")Order": isDirectForever as Any,
            "directOrderL\("ike")MediaUrl": directOrderLoveMediaURL as Any,
            "directOrderL\("ike")MediaId": directOrderLoveMediaID as Any
        ]
        
        Alamofire.AF.request(requesetURl,
                          method: .post,
                          parameters: param,
                          encoding: JSONEncoding.default,
                          headers: nil).responseData { (response) in
                            switch response.result {
                            case .success(let data):
                                let json = JSON.init(from: data)
                                
                                let result = json?["number"].string
                                
                                if (result?.count ?? 0) > 0 {
                                    success(result)
                                } else {
                                    failure("buy error")
                                }
                                
                                debugPrint(data)
                                break
                            case .failure(let error):
                                debugPrint(error)
                                failure("buy error")
                                break
                            }
        }
        
    }
    
    /// Update Order
    static func requestUpdateOrder(receipt: String,
                                   number: String,
                                   isLucky: Bool,
                                   promID: String?,
                                   success: @escaping (String?) -> Void,
                                   failure: @escaping (_ error: String) -> Void) {
        let requesetURl = requestNativeURL + "/api/trade/order?session=\(currentToken())".gsidURL
        let param: Dictionary<String, Any> = [
            "receipt": receipt,
            "number": number,
            "isPromotionOrder": isLucky.int,
            "promId": promID as Any
        ]
        
        Alamofire.AF.request(requesetURl,
                          method: .put,
                          parameters: param,
                          encoding: JSONEncoding.default,
                          headers: nil).responseData { (response) in
                            switch response.result {
                            case .success(let data):
                                let json = JSON.init(from: data)
                                let result = json?["number"].string

                                if (result?.count ?? 0) > 0 {
                                    success(result)
                                } else {
                                    failure("buy error")
                                }
                                
                                debugPrint(data)
                                break
                            case .failure(let error):
                                debugPrint(error)
                                failure("buy error")
                                break
                            }
        }
    }
    
    /// verify Order
    static func requestVerifyOrder(orderID: String,success: @escaping (Bool) -> Void) {
        let requesetURl = requestNativeURL + "/api/trade/order/\(orderID)?session=\(currentToken())".gsidURL
        Alamofire.AF.request(requesetURl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
            switch response.result {
            case .success(let data):
                let json = JSON.init(data)
                let result = json["number"].string
                if (result?.count ?? 0) > 0 {
                    success(true)
                } else {
                    success(false)
                }
                
                break
                
            case .failure(_):
                success(false)
                break
            }
        }
    }
    
    /// 金币兑换 f
    static func requestCoinsForever(isPromotion: Bool,
                                    foreverSize: Int,
                                    success: @escaping () -> Void,
                                    failure: @escaping (_ error: Error) -> Void) {
        let requesetURl = requestNativeURL + "/api/fo\("llow")/order?session=\(currentToken())&productId=\(obtainBundleIdentifier())".gsidURL
        let param = [
            "gsid" : foreverSize.string.gsid,
            "isPromotionOrder" : isPromotion,
            "fo\("llow")Size" : foreverSize
            ] as [String : Any]
        
        
        /*
         返回参数
         {
           "session" : "Mjc3NTc1NTM7cnVpcnVpMTMxOTsxNTk2NzE2MTAxMDM4OzA",
           "followBalance" : 34000,
           "repostBalance" : 20,
           "userId" : 27757553,
           "balance" : 1965,
           "managerBalance" : 0
         }
         */
        
        Alamofire.AF.request(requesetURl,
                          method: .post,
                          parameters: param, encoding: JSONEncoding.default).responseData { (response) in
            switch response.result {
            case .success(let data):
                let json = JSON.init(data)
                debugPrint(json)
                success()
                break
                
            case .failure(let error):
                failure(error)
                break
            }
        }
    }
    
    /// 金币兑换 l
    static func requestCoinsLove(mediaID: String,
                                 thumbnailUrl: String,
                                 lowResolutionUrl: String,
                                 isPromotion: Bool,
                                 loveSize: Int,
                                 success: @escaping () -> Void,
                                 failure: @escaping (_ error: Error) -> Void) {
        let requesetURl = requestNativeURL + "/api/sessions/order?session=\(currentToken())&productId=\(obtainBundleIdentifier())".gsidURL
        let param = [
            "gsid" : (mediaID + loveSize.string).gsid,
            "thumbnail_url" : thumbnailUrl,
            "low_resolution_url" : lowResolutionUrl,
            "mediaId": mediaID,
            "isPromotionOrder": isPromotion.int,
            "l\("ike")Size": loveSize
            ] as [String : Any]
        
        Alamofire.AF.request(requesetURl, method: .post, parameters: param, encoding: JSONEncoding.default).responseData { (response) in
            switch response.result {
            case .success(let data):
                let json = JSON.init(data)
                debugPrint(json)
                success()
                break
                
            case .failure(let error):
                failure(error)
                break
            }
        }
        
    }
    
    /// user Inster profile
    static func requestProfile(name: String,
                               success: @escaping (_ requestData: Data) -> Void,
                               failure: @escaping (_ errorString: EIRequestError) -> Void) {
        
        let userManage = UserManage.default
        let urlRoute = "/\(name)"
        let requestUrl = reqeustIProfileURL + urlRoute
        
        Alamofire.AF.request(requestUrl,
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: HTTPHeaders.init(customUserCookies(userModel: userManage.currentUserModel))).responseString { (response) in
                            switch response.result {
                            case .success(let strData):
                                debugPrint(strData)
                                
                                let pattern = "(?<=graphql\":)(.*)(?=,\"toast)"
                                let regex = try? NSRegularExpression(pattern: pattern,
                                                                     options: [])
                                let matches = regex?.matches(in: strData, options: [], range: NSRange(location: 0, length: strData.count))
                                guard let nsRange = matches?.first?.range,
                                    let range = Range(nsRange, in: strData) else {
                                        failure(.verificationFailed)
                                        return
                                }
                                
                                let jsonText = String(strData[range])
                                if let data = jsonText.data(using: .utf8, allowLossyConversion: false) {
                                    do {
                                        success(data)
                                    } catch {
                                        failure(.verificationFailed)
                                    }
                                } else {
                                    failure(.verificationFailed)
                                }
                                
                                break
                            case .failure(_):
                                failure(.verificationFailed)
                                break
                            }
        }
    }
    
    /// 获得其他帖子
    static func requestUserNodes(userCoreID: String,
                                 count: Int,
                                 lastID: String?,
                                 success: @escaping (_ requestData: Array<Node>, _ haveNext: Bool) -> Void,
                                 failure: @escaping (_ errorString: Error) -> Void) {
        let requestUrl = reqeustIDefURL + "/api/v1/feed/user/\(userCoreID)/?count=\(count)&max_id=\(lastID ?? "")"
        Alamofire.AF.request(requestUrl,
                          method: .get,
                          headers: HTTPHeaders.init(customUserCookies(userModel: UserManage.default.currentUserModel))).responseData { (response) in
                            switch response.result {
                            case .success(let data):
                                var resultArray: Array<Node> = []
                                let json = JSON.init(from: data)
                                
                                let moreAvailable = json?["more_available"].bool ?? false
                                let nodeArray = json?["items"].array ?? []
                                
                                for item in nodeArray {
                                    let node = Node()
                                    node.ID = item["id"].string
                                    node.edgeLoveBy = item["like_count"].int
                                    node.edgeMediaToComment = item["comment_count"].int
                                    node.mediaType = item["media_type"].int
                                    
                                    
                                    var urlJsonArray = item["carousel_media"][0]["image_versions2"]["candidates"].array
                                    var urlJson = urlJsonArray?[1]
                                    var url = urlJson?["url"].url
                                                                        
                                    if node.mediaType == 1 {
                                        urlJsonArray = item["image_versions2"]["candidates"].array
                                        urlJson = urlJsonArray?[1]
                                        url = urlJson?["url"].url
                                    }
                                    
                                    if node.mediaType == 2 {
                                        urlJsonArray = item["image_versions2"]["candidates"].array
                                        urlJson = urlJsonArray?[1]
                                        url = urlJson?["url"].url
                                        
                                        if item["image_versions2"]["additional_candidates"]["igtv_first_frame"].dictionary != nil {
                                            node.mediaType = 11
                                        }
                                    }
                                    
                                    node.displayUrl = url
                                    node.thumbnailSrc = url
                                    node.typename = ""
                                    node.shortcode = ""
                                    resultArray.append(node)
                                }
                                success(resultArray, moreAvailable)
                                break
                            case .failure(let error):
                                failure(error)
                                break
                            }
        }
    }
    
    /// 获得 adhere post
    static func requestAdherePost(count: Int,
                                  reset: Bool,
                                  success: @escaping (_ requestData: Data) -> Void,
                                  failure: @escaping (_ errorString: String) -> Void) {
        
        let requestUrl = requestNativeURL + "/api/fo\("llow")/newapi?session=\(currentToken())&requestCnt=\(count)&reset=\(reset.string)".gsidURL
        Alamofire.AF.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
            switch response.result {
            case .success(let data):
                success(data)
                break
                
            case .failure(let error):
                failure(error.errorDescription ?? "Error")
                break
            }
        }
    }
    
    /// 获得 love post
    static func requestLovePost(reset: Bool,
                                success: @escaping (_ requestData: Data) -> Void,
                                failure: @escaping (_ errorString: String) -> Void) {
        
        let requestUrl = requestNativeURL + "/api/item/batch?session=\(currentToken())&reset=\(reset.int)".gsidURL
        Alamofire.AF.request(requestUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
            switch response.result {
            case .success(let data):
                success(data)
                break
                
            case .failure(let error):
                failure(error.errorDescription ?? "Error")
                break
            }
        }
    }
    
    /// adhere public 订单
    static func requestAdhereOrder(userID: Int,
                                   success: @escaping () -> Void,
                                   accountError: @escaping (_ errotTitle: String, _ errorContent: String) -> Void,
                                   failure: @escaping (_ statusCode: String, _ errorString: String) -> Void) {
        let requestUrl = reqeustIDefURL + "/api/v1/friendships/create/\(userID)/"
        let uuid = UUID().uuidString
        let jsonString =
        #"""
        {
        "user_id":"\#(userID)",
        "_csrftoken":"\#(UserManage.default.currentUserModel?.userCore_csrftoken ?? "missing")",
        "radio_type":"wifi-none",
        "_uuid":"\#(uuid)"
        }
        """# .withoutSpacesAndNewLines
        
        let sha256 = jsonString.hmac(algorithm: .SHA256, key: sha256KEY)
        let signedBody = "\(sha256).\(jsonString)"
        let param = [
            "ig_sig_key_version": 5,
            "signed_body": signedBody
            ] as [String : Any]
        let userManage = UserManage.default
        Alamofire.AF.request(requestUrl,
                             method: .post,
                             parameters: param,
                             encoding: JSONEncoding.default,
                             headers: HTTPHeaders.init(customUserCookies(userModel: userManage.currentUserModel))).responseData { (response) in
                                
                                switch response.result {
                                case .success(let data):
                                    let jsonData = JSON.init(from: data)
                                    let status = jsonData?["status"].string
                                    
                                    if status == "ok" {
                                        success()
                                    } else {
                                        
                                        if let feedbackTitle = jsonData?["feedback_title"].string, let feedbackContent = jsonData?["feedback_message"].string {
                                            accountError(feedbackTitle, feedbackContent)
                                            return
                                        }
                                        
                                        let statusCode = response.response?.statusCode.string ?? "0"
                                        let errorString = jsonData?["message"].string ?? ""
                                        failure(statusCode, errorString)
                                    }
                                    
                                    break
                                    
                                case .failure(let error):
                                    let statusCode = response.response?.statusCode.string ?? "0"
                                    let errorString = error.errorDescription ?? ""
                                    failure(statusCode, errorString)
                                    break
                                }
                                
        }
    }
    
    /// native adhere order requst
    static func requestNativeAdhereOrder(orderID: Int,
                                         success: @escaping (_ data: Data) -> Void,
                                         failure: @escaping (_ errorString: String) -> Void) {
        let requestUrl = requestNativeURL + "/api/fo\("llow")/\(orderID).json?session=\(currentToken())".gsidURL
        Alamofire.AF.request(requestUrl, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
            
            switch response.result {
            case .success(let data):
//                let jsondata = JSON.init(from: data)
                success(data)
                break
                
            case .failure(let error):
                failure(error.errorDescription ?? "")
                break
            }
        }
    }
    
    /// love public 订单
    static func requestLoveOrder(mediaID: String,
                                 orderID: Int,
                                 userID: Int,
                                 success: @escaping () -> Void,
                                 accountError: @escaping (_ errotTitle: String, _ errorContent: String) -> Void,
                                 failure: @escaping (_ statusCode: String, _ errorString: String, _ errorBody: String) -> Void) {
        let requestUrl = reqeustIDefURL + "/api/v1/media/\(mediaID)/l\("ike")/"
        let uuid = UUID().uuidString
        let jsonString =
            #"""
            {
            "_csrftoken":\#(UserManage.default.currentUserModel?.userCore_csrftoken ?? "missing"),
            "_uid":\#(userID.string),
            "_uuid": \#(uuid),
            "container_module": \#("feed_timeline"),
            "feed_position": \#((1 ... 100).randomElement() ?? 28),
            "inventory_source": \#("media_or_ad"),
            "is_carousel_bumped_post": \#("false"),
            "media_id": \#(mediaID),
            "radio_type": \#("wifi-none")
            }
            """# .withoutSpacesAndNewLines

        let sha256 = jsonString.hmac(algorithm: .SHA256, key: sha256KEY)
        let signedBody = "\(sha256).\(jsonString)"
        let param = [
            "ig_sig_key_version": 5,
            "signed_body": signedBody,
            "d" : 0
            ] as [String : Any]
        let userManage = UserManage.default
        
        Alamofire.AF.request(requestUrl,
                             method: .post,
                             parameters: param,
                             encoding: JSONEncoding.default,
                             headers: HTTPHeaders.init(customUserCookies(userModel: userManage.currentUserModel))).responseData { (response) in
                                
                                switch response.result {
                                case .success(let data):
                                    let jsonData = JSON.init(from: data)
                                    let status = jsonData?["status"].string
                                    if status == "ok" {
                                        success()
                                    } else {
                                        
                                        if let feedbackTitle = jsonData?["feedback_title"].string, let feedbackContent = jsonData?["feedback_message"].string {
                                            accountError(feedbackTitle, feedbackContent)
                                            return
                                        }
                                        
                                        let statusCode = response.response?.statusCode.string ?? "0"
                                        let errorString = jsonData?["message"].string ?? ""
                                        let errorBody = jsonData?["errorBody"].string ?? ""
                                        failure(statusCode, errorString, errorBody)
                                    }
                                    break
                                    
                                case .failure(let error):
                                    
                                    let statusCode = response.response?.statusCode.string ?? "0"
                                    let errorString = error.errorDescription ?? ""
                                    failure(statusCode, errorString, "")
                                    break
                                }
        }
    }
    
    ///native love order reqeust
    static func requestNativeLoveOrder(orderID: Int,
                                       success: @escaping (_ data: Data) -> Void,
                                       failure: @escaping (_ errorString: String) -> Void) {
        let requestUrl = requestNativeURL + "/api/item/\(orderID.string).json?session=\(currentToken())".gsidURL
        Alamofire.AF.request(requestUrl, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
            
            switch response.result {
            case .success(let data):
//                let jsondata = JSON.init(from: data)
                success(data)
                break
                
            case .failure(let error):
                failure(error.errorDescription ?? "")
                break
            }
        }
    }
    
    ///love not found
    static func requestLoveNotFound(orderID: Int, mediaOwnerID: String, failReasonID: Int) {
        let requestUrl = reqeustIDefURL + "api/item/newapi/\(orderID)?session=\(currentToken())".gsidURL
        let param = [
            "mediaOwnerId": mediaOwnerID,
            "failReasonId": failReasonID
            ] as [String : Any]
        
        Alamofire.AF.request(requestUrl,
                             method: .put,
                             parameters: param,
                             encoding: JSONEncoding.default,
                             headers: nil).responseData { (response) in
                                switch response.result {
                                case .success(_):
//                                    debugPrint(JSON.init(from: data))
                                    break
                                    
                                case .failure(_):
//                                    debugPrint(error.errorDescription)
                                    break
                                }
        }
        
    }
    
    ///adhere not found
    static func requestAdhereNotFound(userID: Int, failMsg: String) {
        let requestUrl = reqeustIDefURL + "/api/fo\("llow")/\(userID).json?session=\(currentToken())&type=0".gsidURL
        let param = [
            "failMsg": failMsg
        ]
        Alamofire.AF.request(requestUrl,
                             method: .put,
                             parameters: param,
                             encoding: JSONEncoding.default,
                             headers: nil).responseData { (response) in
                                switch response.result {
                                case .success(_):
//                                    debugPrint(JSON.init(from: data))
                                    break
                                    
                                case .failure(_):
//                                    debugPrint(error.errorDescription)
                                    break
                                }
        }
    }
    
    static func reqeustLoveAndForeverError(failReasonID: Int,
                                           failMsg: String,
                                           orderID: String,
                                           success: @escaping (_ msg: String, _ sleepTime: Int) -> Void,
                                           failure: @escaping (_ errorString: String) -> Void) {
        let requestUrl = reqeustIDefURL + "/api/misc/reportinserror?session=\(currentToken())".gsidURL
        let param = [
                "failReasonId": failReasonID,
                "failMsg": failMsg,
                "orderId": orderID
            ] as [String : Any]
        
        Alamofire.AF.request(requestUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
            switch response.result {
            case .success(let data):
                
                let jsonData = JSON.init(from: data)
                let msg = jsonData?["msg"].string ?? ""
                let sleepTiem = jsonData?["sleepTime"].int ?? 0
                success(msg, sleepTiem)
                
//                debugPrint(JSON.init(from: data))
                break
                
            case .failure(let error):
                failure(error.errorDescription ?? "")
//                debugPrint(error.errorDescription)
                break
            }
        }
    }
    
    /// cookis
    static func customUserCookies(userModel: UserModel? = nil) -> [String : String] {
        let osVersion = Device.current.systemVersion?.components(separatedBy: ".").joined(separator: "_") ?? "13_5"
        var userAgent = "In\("stag")ram 121.0.0.29.119(iPhone 7,1; iOS 12_2; en_US; en; scale=2.61; 1080x1920) AppleWebKit/420+"
        
        if UIApplication.shared.inferredEnvironment != .debug {
            let deviceIdentifier = Device.identifier
            userAgent = "In\("stag")ram 121.0.0.29.119(\(deviceIdentifier)"
                        + "; iOS \(osVersion); \(Locale.current.identifier)"
                        + "; \(Locale.preferredLanguages.first ?? "en")"
                        + "; scale=\(UIScreen.main.nativeScale)"
                        + "; \(UIScreen.main.nativeBounds.width)x\(UIScreen.main.nativeBounds.height)"
                        + ") AppleWebKit/420+"
            
        }
        
        let cookie = userModel?.userCore_cookieString ?? ""
        let token = userModel?.userCore_csrftoken ?? ""
        let sessionid = userModel?.userCore_Session ?? ""
        
        let resultDic = [
            "Cookie" : cookie,
            "User-Agent" : userAgent,
            "ccode" : "US",
            "csrftoken" : token,
            "ds_user" : userModel?.userName ?? "",
            "ds_user_id" : userModel?.userCore_ID ?? "",
            "sessionid" : sessionid,
            "mid" : userModel?.userCore_mid ?? ""
        ]
        
        return resultDic
    }
}
