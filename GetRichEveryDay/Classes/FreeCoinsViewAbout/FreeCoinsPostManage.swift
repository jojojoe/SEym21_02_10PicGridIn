import UIKit
import SwiftyJSON
import Alertift

typealias AdhereItemCallBack = (_ item: AdherePostModel?) -> Void
typealias LoveItemCallBack = (_ item: LovePostModel?) -> Void

class FreeCoinsPostManage: NSObject {
    
    private var adhereIsNewUser = false
    private var loveIsNewUser = false
    var adhereList: Array<AdherePostModel> = []
    var loveList: Array<LovePostModel> = []
    var cfgAdhereOrderShow = 0
    var cfgLoveOrderShow = 0
    var adhereShowed = 0
    var loveShowed = 0
    
    var showIndex = 0
    var showAdhereIndex = 0
    var adhereCallback: AdhereItemCallBack?
    var loveCallback: LoveItemCallBack?
    let group = DispatchGroup()
    
    var showingAdhereItem: AdherePostModel? = nil
    var showingLoveitem: LovePostModel? = nil
    var isAdhereOrder = false
        
    class var sharedInstance : FreeCoinsPostManage {
        struct Static {
            static let instance : FreeCoinsPostManage = FreeCoinsPostManage()
        }
        return Static.instance
    }
    
    // Initialization
    private override init() {
        super.init()
        clearAllData()
        getShowTime()
    }
    
    func getShowTime() {
        self.cfgAdhereOrderShow = NativeConfigManage.default.config?.cfgFollowOrderShowTimes ?? 0
        self.cfgLoveOrderShow = NativeConfigManage.default.config?.cfgLikeOrderShowTimes ?? 0
        
        self.showAdhereIndex = self.cfgAdhereOrderShow + self.cfgLoveOrderShow
    }

    func reqesutPostData() {
        self.requestLoveData(reload: true)
        self.requestAdherePost(reload: true)
        
        group.notify(queue: .main) { [weak self] in
            self?.showOrder()
        }
    }
    
    func requestAdherePost(reload: Bool) {
        group.enter()
        RequestNetWork.requestAdherePost(count: 10, reset: self.adhereIsNewUser, success: {[weak self] (data) in
            self?.adhereIsNewUser = false
            self?.adhereList += AdherePostModel.createData(data: data)
            self?.group.leave()
            
            if reload {
                self?.showingAdhereItem = self?.adhereList.first
                self?.isAdhereOrder = true
                self?.adhereCallback?(self?.showingAdhereItem)
                self?.adhereShowed += 1
            }
            
        }) {[weak self] (error) in
            print(error)
            self?.group.leave()
        }
    }
    
    func requestLoveData(reload: Bool) {
        group.enter()
        RequestNetWork.requestLovePost(reset: self.loveIsNewUser, success: {[weak self] (data) in
            self?.loveIsNewUser = false
            self?.loveList += LovePostModel.createData(data: data)
            
            if reload {
//                self?.showingLoveitem = self?.loveList.first
                self?.showOrder()
                
//                self?.isAdhereOrder = false
//                self?.loveShowed += 1
            }
            
            self?.group.leave()
        }) {[weak self] (error) in
            print(error)
            self?.group.leave()
        }
    }
    
    func clearAllData() {
        /// 用户是否变更, 影响订单请求是否重新获取
        self.loveIsNewUser = true
        self.adhereIsNewUser = true
        /**********************************/
        self.showingLoveitem = nil
        self.showingAdhereItem = nil
        self.adhereShowed = 0
        self.loveShowed = 0
        self.adhereList = []
        self.loveList = []
    }
    
    func showOrder() {
        
        if showIndex < showAdhereIndex - 1 {
            
            if let loveItem = self.loveList.first {
                
                let newItem = LovePostModel()
                newItem.ordertyep = loveItem.ordertyep
                newItem.orderID = loveItem.orderID
                newItem.orderOwner_fullName = loveItem.orderOwner_fullName
                newItem.orderOwner_userid = loveItem.orderOwner_userid
                newItem.orderOwner_ID = loveItem.orderOwner_ID
                newItem.orderOwner_profileUrl = loveItem.orderOwner_profileUrl
                newItem.media_low_resolution_url = loveItem.media_low_resolution_url
                newItem.media_thumbnail_url = loveItem.media_thumbnail_url
                newItem.media_id = loveItem.media_id
                self.showingLoveitem = newItem
                self.isAdhereOrder = false
                loveCallback?(newItem)
                self.loveList.removeFirst()
                showIndex += 1
            } else {
                if let adhereItem = self.adhereList.first {
                    let newAdhere = AdherePostModel()
                    newAdhere.managerBalance = adhereItem.managerBalance
                    newAdhere.adhereBanlance = adhereItem.adhereBanlance
                    newAdhere.repostBanlance = adhereItem.repostBanlance
                    newAdhere.banlance = adhereItem.banlance
                    newAdhere.userID = adhereItem.userID
                    newAdhere.instUserID = adhereItem.instUserID
                    newAdhere.instFullName = adhereItem.instFullName
                    newAdhere.profileUrl = adhereItem.profileUrl
                    adhereCallback?(newAdhere)
                    self.showingAdhereItem = newAdhere
                    self.isAdhereOrder = true
                    self.adhereList.removeFirst()
                    showIndex = 0
                } else {
                    loveCallback?(nil)
                }
            }
                        
        } else {
            if let adhereItem = self.adhereList.first {
                
                let newAdhere = AdherePostModel()
                newAdhere.managerBalance = adhereItem.managerBalance
                newAdhere.adhereBanlance = adhereItem.adhereBanlance
                newAdhere.repostBanlance = adhereItem.repostBanlance
                newAdhere.banlance = adhereItem.banlance
                newAdhere.userID = adhereItem.userID
                newAdhere.instUserID = adhereItem.instUserID
                newAdhere.instFullName = adhereItem.instFullName
                newAdhere.profileUrl = adhereItem.profileUrl
                self.showingAdhereItem = newAdhere
                self.isAdhereOrder = true
                adhereCallback?(newAdhere)
                self.adhereList.removeFirst()
                showIndex = 0
            } else {
                if let loveItem = self.loveList.first {
                    let newItem = LovePostModel()
                    newItem.ordertyep = loveItem.ordertyep
                    newItem.orderID = loveItem.orderID
                    newItem.orderOwner_fullName = loveItem.orderOwner_fullName
                    newItem.orderOwner_userid = loveItem.orderOwner_userid
                    newItem.orderOwner_ID = loveItem.orderOwner_ID
                    newItem.orderOwner_profileUrl = loveItem.orderOwner_profileUrl
                    newItem.media_low_resolution_url = loveItem.media_low_resolution_url
                    newItem.media_thumbnail_url = loveItem.media_thumbnail_url
                    newItem.media_id = loveItem.media_id
                    self.showingLoveitem = newItem
                    self.isAdhereOrder = false
                    loveCallback?(newItem)
                    self.loveList.removeFirst()
                    showIndex += 1
                } else {
                    adhereCallback?(nil)
                }
            }
        }
        
        if showIndex == showAdhereIndex - 1 {
            showIndex = showAdhereIndex - 1
        }
        
        if self.loveList.count < 2 {
            self.requestLoveData(reload: false)
        }
        
        if self.adhereList.count < 2 {
            self.requestAdherePost(reload: false)
        }
        

//        if self.loveShowed <= self.cfgLoveOrderShow {
//
//            if self.showingLoveitem != nil && self.loveList.count > 0 {
//                self.loveList.removeFirst()
//
//                if self.loveList.count < 1 {
//                    self.requestLoveData(reload: true)
//                }
//            }
//
//            self.showingLoveitem = self.loveList.first
//            loveCallback?(self.showingLoveitem)
//
//            self.isAdhereOrder = false
//            self.loveShowed += 1
//
//        } else if self.adhereShowed <= self.cfgAdhereOrderShow {
//
//            if self.showingAdhereItem != nil && self.adhereList.count > 0  {
//                self.adhereList.removeFirst()
//                if self.adhereList.count < 1 {
//                    self.requestAdherePost(reload: true)
//                }
//            }
//
//            self.showingAdhereItem = self.adhereList.first
//
//            self.isAdhereOrder = true
//            adhereCallback?(self.showingAdhereItem)
//
//            self.adhereShowed += 1
//
//        } else {
//            self.adhereShowed = 0
//            self.loveShowed = 0
//
//            if self.showingLoveitem != nil && self.loveList.count > 0  {
//                self.loveList.removeFirst()
//                if self.loveList.count < 1 {
//                    self.requestLoveData(reload: true)
//                }
//            }
//
//            self.showingLoveitem = self.loveList.first
//            loveCallback?(self.showingLoveitem)
//
//            self.isAdhereOrder = false
//        }
    }
        
    /// 销单
    func startOrder() {
        
        if let userSalesOrderModel = MarsCache.obtainUsersalesOrderLimitation() {
                        
            let timeInterval = Date().timeIntervalSince1970 - userSalesOrderModel.secondsTime
            if userSalesOrderModel.limitReached
                && userSalesOrderModel.sleepTime > 0
                && Int(timeInterval) < userSalesOrderModel.sleepTime * 60 {

                let v = UserBlockViewController()
                v.msg = userSalesOrderModel.msg
                v.customTime = Int(timeInterval)
                UIViewController.currentViewController()?.presentOverfullScreenVC(presentVC: v)
                
                return
            }
        }
        
        HubManager.showHideMask()
        if isAdhereOrder {
            orderAdhere()
        } else {
            orderLove()
        }
    }
    
    func orderAdhere() {
        
        guard let orderModel = self.showingAdhereItem else {
            showOrder()
            HubManager.hide()
            return
        }
        
        RequestNetWork.requestAdhereOrder(userID: orderModel.instUserID) {
            RequestNetWork.requestNativeAdhereOrder(orderID: orderModel.userID, success: { (resultData) in
                
                let jsonData = JSON.init(from: resultData)
                
                let limitationMsg = jsonData?["inslimitation"]["msg"].string ?? ""
                let limitationSleepTime = jsonData?["inslimitation"]["sleepTime"].int ?? 0
                let limitationReached = jsonData?["inslimitation"]["limitReached"].bool ?? false
                MarsCache.userSalesOrderLimitation(msg: limitationMsg,
                                                   sleepTime: limitationSleepTime,
                                                   limitReached: limitationReached)
                
                if let coinsNumber = jsonData?["balance"].int {                    
                    UserManage.default.changeCurrentUserCoins(coinsNum: coinsNumber)
                }
                self.showOrder()
                HubManager.hide()
                
            }) { (errorString) in

                self.showOrder()
                HubManager.hide()
            }
        } accountError: { (errorTitle, errorCount) in
            
            HubManager.hide()
            
            let v = UserMessageAlertViewController()
            v.msgTitle = errorTitle
            v.msgContent = errorCount
            UIViewController.currentViewController()?.presentOverfullScreenVC(presentVC: v)
            
        } failure: { (errorCode, errorSting) in
            self.showOrder()
            HubManager.hide()
            if errorCode == "400" {
                RequestNetWork.reqeustLoveAndForeverError(failReasonID: errorCode.int ?? 400,
                                                          failMsg: errorSting,
                                                          orderID: orderModel.userID.string,
                                                          success: { (msg, sleepTime) in
                }) { (error) in
                    debugPrint(error)
                }
            }
            
            if errorCode == "404" {
                RequestNetWork.requestAdhereNotFound(userID: UserManage.default.currentUserModel?.userNativeID?.int ?? 0,
                                                     failMsg: errorSting)
            }
        }
    }
    
    func orderLove() {
        
        guard let loveModel = self.showingLoveitem else {
            showOrder()
            HubManager.hide()
            return
        }
        let mediaID = loveModel.media_id
        let orderID = loveModel.orderID
        let userID = UserManage.default.currentUserModel?.userCore_ID?.int ?? 0
        
        RequestNetWork.requestLoveOrder(mediaID: mediaID, orderID: orderID, userID: userID) {
            RequestNetWork.requestNativeLoveOrder(orderID: orderID, success: { (resultData) in
                
                let jsonData = JSON.init(from: resultData)
                
                let limitationMsg = jsonData?["inslimitation"]["msg"].string ?? ""
                let limitationSleepTime = jsonData?["inslimitation"]["sleepTime"].int ?? 0
                let limitationReached = jsonData?["inslimitation"]["limitReached"].bool ?? false
                MarsCache.userSalesOrderLimitation(msg: limitationMsg,
                                                   sleepTime: limitationSleepTime,
                                                   limitReached: limitationReached)
                
                if let coinsNumber = jsonData?["balance"].int {
                    UserManage.default.changeCurrentUserCoins(coinsNum: coinsNumber)
                }
                self.showOrder()
                HubManager.hide()
                
            }) { (errorString) in

                self.showOrder()
                HubManager.hide()
            }
        } accountError: { (errorTitle, errorCount) in
            HubManager.hide()
            
            let v = UserMessageAlertViewController()
            v.msgTitle = errorTitle
            v.msgContent = errorCount
            UIViewController.currentViewController()?.presentOverfullScreenVC(presentVC: v)
            
        } failure: { (errorCode, errorSting, errorBody) in
            self.showOrder()
            HubManager.hide()
            if errorCode == "400" {
                RequestNetWork.reqeustLoveAndForeverError(failReasonID: errorCode.int ?? 400,
                                                          failMsg: errorSting,
                                                          orderID: orderID.string,
                                                          success: { (msg, sleepTime) in
                    
                }) { (error) in
                    debugPrint(error)
                }
            }
            
            if errorCode == "404" {
                RequestNetWork.requestLoveNotFound(orderID: orderID, mediaOwnerID: mediaID, failReasonID: errorCode.int ?? 404)
            }
        }
    }
    
    func skipPost() {
        showOrder()
    }
}
