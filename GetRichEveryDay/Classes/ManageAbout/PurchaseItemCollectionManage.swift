//
//  PurchaseItemCollectionManage.swift
//  Adjust
//
//  Created by 薛忱 on 2020/7/31.
//

import UIKit
import SwiftyStoreKit
import AdSupport

class PurchaseItemCollectionManage: NSObject {
    
    static let `default` = PurchaseItemCollectionManage()
    var itemCollection: PurchaseItemModelCollection?
    var purchaseItem: PurchaseItemModel?
    var evironment: String {
        var value = "production"
        if UIApplication.shared.inferredEnvironment != .appStore {
            value = "sandbox"
        }
        return value
    }
    
    static func requestPurchase(complete: @escaping (_ error: Error?) -> Void) {
        
        if let pruchaseData = MarsCache.obtainPurchaseItems() {
            let model = PurchaseItemModelCollection.createModelCollection(json: pruchaseData)
            PurchaseItemCollectionManage.default.assignmentItemCollection(itemCollection: model)
        }
        
        RequestNetWork.requestPurchaseItems(success: { (model) in
            PurchaseItemCollectionManage.default.assignmentItemCollection(itemCollection: model)
            PurchaseItemCollectionManage.default.obtainLoactionPrice()
            complete(nil)
        }) { (error) in
            
            complete(error)
            debugPrint(error)
        }
    }
    
    private override init() {
    }
    
    /// 获取locatlized price 并赋值
    func obtainLoactionPrice() {
        let allArray = obtainItems(withPurchaseItemType: .ECoins_money, .Ef_money, .El_money)
        
        var idSet: Set<String> = []
        for model in allArray {
            idSet.insert(model.iapId!)
        }
        
        // 获得location价格
        
        SwiftyStoreKit.retrieveProductsInfo(idSet) { (result) in
            
            debugPrint(result)
            var localizedPriceDic: Dictionary<String, String> = [:]
            
            for product in result.retrievedProducts {
                
                localizedPriceDic[product.productIdentifier] = product.localizedPrice
                localizedPriceDic["currencyCode"] = product.priceLocale.currencyCode
            }
            MarsCache.assignmentPurchaseLoactionPrice(locationPrice: localizedPriceDic)
            
            for model in self.obtainAllItems() {
                
                if let iapID = model.iapId {
                    model.localizedPrice = localizedPriceDic[iapID] ?? ("$" + (model.costTotal ?? ""))
                    guard let currencyCode = localizedPriceDic["currencyCode"] else {
                        break
                    }
                    model.currencyCode = currencyCode
                }
            }
            
            NotificationCenter.default.post(name: .GREDReloadData, object: nil)
        }
    }
    
    func assignmentItemCollection(itemCollection: PurchaseItemModelCollection) {
        self.itemCollection = itemCollection
        
        self.itemCollection?.purchaseFMoneyArray.sort(by: { (item1, item2) -> Bool in
            return item1.itemCount! < item2.itemCount!
        })
        
        self.itemCollection?.purchaseFCoinsArray.sort(by: { (item1, item2) -> Bool in
            return item1.itemCount! < item2.itemCount!
        })
                
        self.itemCollection?.purchaseLMoneyArray.sort(by: { (item1, item2) -> Bool in
            return item1.itemCount! < item2.itemCount!
        })
        
        self.itemCollection?.purchaseLCoinsAray.sort(by: { (item1, item2) -> Bool in
            return item1.itemCount! < item2.itemCount!
        })
        
        self.itemCollection?.purchaseCoinsMoneyArray.sort(by: { (item1, item2) -> Bool in
            return item1.itemCount! < item2.itemCount!
        })
    }
    
    func obtainAllItems() -> Array<PurchaseItemModel> {
        var resultArray: Array<PurchaseItemModel> = []
        resultArray += itemCollection?.purchaseFMoneyArray ?? []
        resultArray += itemCollection?.purchaseFCoinsArray ?? []
        resultArray += itemCollection?.purchaseFGoldenMoneyArray ?? []
        resultArray += itemCollection?.purchaseFGoldenCoinsArray ?? []
        resultArray +=  itemCollection?.purchaseFVipWeeklyArray ?? []
        resultArray += itemCollection?.purchaseLMoneyArray ?? []
        resultArray += itemCollection?.purchaseLCoinsAray ?? []
        resultArray += itemCollection?.purchaseLVipMonthlyArray ?? []
        resultArray += itemCollection?.purchaseCoinsMoneyArray ?? []
        return resultArray
    }
    
    func obtainItems(withPurchaseItemType itemTypes: EPurchaseItemType...) -> Array<PurchaseItemModel> {
        var resultArray: Array<PurchaseItemModel> = []
        
        for type in itemTypes {
            switch type {
            case .Ef_money:
                resultArray += itemCollection?.purchaseFMoneyArray ?? []
                break
                
            case .Ef_coins:
                resultArray += itemCollection?.purchaseFCoinsArray ?? []
                break
                
            case .Ef_golden_money:
                resultArray += itemCollection?.purchaseFGoldenMoneyArray ?? []
                break
                
            case .Ef_golden_coins:
                resultArray += itemCollection?.purchaseFGoldenCoinsArray ?? []
                break
                
            case .Ef_vip_weekly:
                resultArray +=  itemCollection?.purchaseFVipWeeklyArray ?? []
                break
                
            case .El_money:
                resultArray += itemCollection?.purchaseLMoneyArray ?? []
                break
                
            case .El_coins:
                resultArray += itemCollection?.purchaseLCoinsAray ?? []
                break
                
            case .El_vip_monthly:
                resultArray += itemCollection?.purchaseLVipMonthlyArray ?? []
                break
                
            case .ECoins_money:
                resultArray += itemCollection?.purchaseCoinsMoneyArray ?? []
                break
                
            default:
                break
            }
        }
        
        return resultArray
    }
    
    func startBuy(purchase: PurchaseItemModel?, node: Node?, isAdheret: Bool?) {
                
        guard let purch = purchase else {
            return
        }
        self.purchaseItem = purch
        
        // 事件打点
        
        var type = ""
        
        switch purchase?.itemType {
        case .Ef_money:
            type = "f_money"
            break
            
        case .Ef_coins:
            type = "f_coins"
            break
            
        case .Ef_golden_money:
            type = "f_golden_money"
            break
            
        case .Ef_golden_coins:
            type = "f_golden_coins"
            break
            
        case .Ef_vip_weekly:
            type = "f_vip_weekly"
            break
            
        case .El_money:
            type = "l_money"
            break
            
        case .El_coins:
            type = "l_coins"
            break
            
        case .El_vip_monthly:
            type = "l_vip_monthly"
            break
            
        case .ECoins_money:
            type = "Coins_money"
            break
            
        default:
            type = "ERROR"
            break
        }
        
        let pamaDic: Dictionary<String, String> = [
            "costAvg" : purch.costAvg ?? "",
            "costTotal" : purch.costTotal ?? "",
            "iapId" : purch.iapId ?? "",
            "ID" : "\(purch.ID ?? 0)",
            "itemCount" : "\(purch.itemCount ?? 0)",
            "itemDiscounts" : "\(purch.itemDiscounts ?? 0.0)",
            "itemLimitation" : "\(purch.itemLimitation ?? 0)",
            "itemName" : purch.itemName ?? "",
            "itemType" : type,
            "productId" : purch.productId ?? "",
            "currentPrice" : "\(purch.currentPrice ?? 0.0)",
            "localizedPrice" : purch.localizedPrice,
            "localizedDescription" : purch.localizedDescription,
            "currencyCode" : purch.currencyCode,
            "goodName" : purch.goodName,
        ]
        
        /***********************************************************/
        
        if (UserManage.default.currentUserModel?.openWebBuy ?? 0) > 0 || NativeConfigManage.default.config?.cfgIslive == 0 {
            // web buy

            buyWebPurchse(purchase: purchase, node: node, isAdheret: isAdheret, completion: { (success, response) in
                if success, let verifyOrderID = response["number"] as? String {
                    self.verifyOrder(verifyOrderID: verifyOrderID)
                } else {
                    HubManager.hide()
                    HubManager.error("Buy Failure")
                    AdjustManage.sharedInstance.pointPurchaseFailTotal()
                }
            }) { [weak self] in
                // native buy
                self?.buyPurchase(purchase: purchase, node: node, isAdheret: isAdheret)
            }
        } else {
            // native buy
            buyPurchase(purchase: purchase, node: node, isAdheret: isAdheret)
        }
    }
    
    private func buyWebPurchse(purchase: PurchaseItemModel?,
                               node: Node?,
                               isAdheret: Bool?,
                               completion: @escaping ((Bool, [String: Any]) -> Void),
                               nativeBuyBlock: @escaping (() -> Void)) {
        guard let buyPurchaseItem = purchase, let productID = buyPurchaseItem.iapId else {
            return
        }
        
        var orderLoveMediaURL: String? = nil
        var orderLoveMediaID: String? = nil
        if isAdheret == false && isAdheret != nil {
            guard let Id = node?.ID, let url = node?.thumbnailSrc?.absoluteString else {
                HubManager.hide()
                HubManager.error("Purchase Failed")
                AdjustManage.sharedInstance.pointPurchaseFailTotal()
                return
            }
            
            orderLoveMediaURL = url
            orderLoveMediaID = Id
        }
        
        let currentUserModel = UserManage.default.currentUserModel
        guard let userID = currentUserModel?.userNativeID,
              let userSession = currentUserModel?.userNativeSession else {
            return
        }
        var price = (purchase?.localizedPrice)!
        let vc = WebPurchaseViewController.init(isDirectFans: isAdheret ?? false,
                                                userID: userID,
                                                token: userSession,
                                                productID: productID,
                                                promotionId: "",
                                                isPromotion: false,
                                                mediaUrl: orderLoveMediaURL ?? "",
                                                directFavorMediaId: orderLoveMediaID ?? "",
                                                price: price,
                                                originPrice: price.remove(at: price.startIndex).string,
                                                goodName: purchase?.goodName ?? "",
                                                num: purchase?.itemCount?.string ?? "",
                                                promoteRate: "",
                                                currencyCode: purchase?.currencyCode ?? "USD",
                                                idfa: ASIdentifierManager.shared().advertisingIdentifier.uuidString,
                                                completion: completion,
                                                iapBlock: nativeBuyBlock)
        UIApplication.rootController?.rootVC?.visibleVC?.presentFullScreen(vc)
    }
    
    private func buyPurchase(purchase: PurchaseItemModel?, node: Node?, isAdheret: Bool?) {
        
        guard let buyPurchaseItem = purchase, let productID = buyPurchaseItem.iapId else {
            return
        }
        HubManager.show()
        var orderLoveMediaURL: String? = nil
        var orderLoveMediaID: String? = nil
        if isAdheret == false && isAdheret != nil {
            guard let Id = node?.ID, let url = node?.thumbnailSrc?.absoluteString else {
                HubManager.hide()
                HubManager.error("Data error, please try again")
                return
            }
            
            orderLoveMediaURL = url
            orderLoveMediaID = Id
        }
        
        // 创建订单
        RequestNetWork.requestCreateOrder(isLucky: false,
                                          productID: productID,
                                          evironment: self.evironment,
                                          type: 0,
                                          promID: nil,
                                          isDirectForever: isAdheret,
                                          directOrderLoveMediaURL: orderLoveMediaURL,
                                          directOrderLoveMediaID: orderLoveMediaID,
                                          success: { (resultNumber) in
                                            
                                            
                                            //IAP buy
                                            SwiftyStoreKit.purchaseProduct(productID) { (purchaseResult) in
                                                debugPrint(purchaseResult)
                                                
                                                switch purchaseResult {
                                                case .success(purchase: let purchaseDetails):
                                                    debugPrint(purchaseDetails)
                                                    guard let receiptData = SwiftyStoreKit.localReceiptData else {
                                                        HubManager.hide()
                                                        HubManager.error("Data error, please try again")
                                                        AdjustManage.sharedInstance.pointPurchaseFailTotal()
                                                        return
                                                    }
                                                    
                                                    //更新订单
                                                    let receiptString = receiptData.base64EncodedString(options: [])
                                                    RequestNetWork.requestUpdateOrder(receipt: receiptString, number: resultNumber!, isLucky: false, promID: nil, success: { [weak self] (orderID) in
                                                        
                                                        guard let verifyOrderID = orderID else {
                                                            HubManager.hide()
                                                            HubManager.error("Data error, please try again")
                                                            AdjustManage.sharedInstance.pointPurchaseFailTotal()
                                                            return
                                                        }
                                                        
                                                        // 验证订单
                                                        self?.verifyOrder(verifyOrderID: verifyOrderID)
                                                        
                                                    }) { (error) in
                                                        HubManager.hide()
                                                        HubManager.error(error)
                                                    }
                                                    
                                                    break
                                                case .error(error: let error):
                                                    var errorStr = error.localizedDescription
                                                    switch error.code {
                                                    case .unknown:
                                                        errorStr = "Unknown error. Please contact support. If you are sure you have purchased it, please click the \"Restore\" button."
                                                        AdjustManage.sharedInstance.pointPurchaseFailTotal()
                                                        break
                                                    case .clientInvalid:
                                                        errorStr = "Not allowed to make the payment"
                                                        AdjustManage.sharedInstance.pointPurchaseFailTotal()
                                                        break
                                                    case .paymentCancelled:
                                                        errorStr = "Payment cancelled"
                                                        AdjustManage.sharedInstance.pointPurchaseCancel()
                                                        break
                                                    case .paymentInvalid:
                                                        errorStr = "The purchase identifier was invalid"
                                                        AdjustManage.sharedInstance.pointPurchaseFailTotal()
                                                        break
                                                    case .paymentNotAllowed:
                                                        errorStr = "The device is not allowed to make the payment"
                                                        AdjustManage.sharedInstance.pointPurchaseFailTotal()
                                                        break
                                                    case .storeProductNotAvailable:
                                                        errorStr = "The product is not available in the current storefront"
                                                        AdjustManage.sharedInstance.pointPurchaseFailTotal()
                                                        break
                                                    case .cloudServicePermissionDenied:
                                                        errorStr = "Access to cloud service information is not allowed"
                                                        AdjustManage.sharedInstance.pointPurchaseFailTotal()
                                                        break
                                                    case .cloudServiceNetworkConnectionFailed:
                                                        errorStr = "Could not connect to the network"
                                                        AdjustManage.sharedInstance.pointPurchaseFailTotal()
                                                        break
                                                    case .cloudServiceRevoked:
                                                        errorStr = "User has revoked permission to use this cloud service"
                                                        AdjustManage.sharedInstance.pointPurchaseFailTotal()
                                                        break
                                                    default: errorStr = (error as NSError).localizedDescription
                                                        AdjustManage.sharedInstance.pointPurchaseFailTotal()
                                                        break
                                                    }
                                                    
                                                    HubManager.hide()
                                                    HubManager.error(errorStr)
                                                    
                                                }
                                                
                                            }
        }) { (error) in
            debugPrint(error)
            HubManager.hide()
            HubManager.error(error)
        }
    }
    
    /// 验证订单
    func verifyOrder(verifyOrderID: String) {
        RequestNetWork.requestVerifyOrder(orderID: verifyOrderID) { (isSuccess) in
            HubManager.hide()
            if isSuccess {
                
                HubManager.success("Buy Success")
                UserManage.userInfoUpload(showHub: false)
                
                
                var price = (self.purchaseItem?.localizedPrice)!
                price.remove(at: price.startIndex)
                AdjustManage.sharedInstance.pointPurchaseSuccessTotal(price: price.double(),
                                                                      currencyCode: self.purchaseItem?.currencyCode)
            } else {
                HubManager.error("Buy Failure")
                AdjustManage.sharedInstance.pointPurchaseFailTotal()
            }
        }
    }
    
}

