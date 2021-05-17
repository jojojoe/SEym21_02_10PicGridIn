//
//  PurchaseItemModel.swift
//  Adjust
//
//  Created by 薛忱 on 2020/7/30.
//

import UIKit
import SwiftyJSON
import SwiftyStoreKit

enum EPurchaseItemType {
    case Ef_money
    case Ef_coins
    case Ef_golden_money
    case Ef_golden_coins
    case Ef_vip_weekly
    case El_money
    case El_coins
    case El_vip_monthly
    case ECoins_money
    case EError
}

class PurchaseItemModelCollection {
    
    /// f_money
    var purchaseFMoneyArray: Array<PurchaseItemModel> = []
    /// f_coins
    var purchaseFCoinsArray: Array<PurchaseItemModel> = []
    /// f_golden_money
    var purchaseFGoldenMoneyArray: Array<PurchaseItemModel> = []
    /// f_golden_coins
    var purchaseFGoldenCoinsArray: Array<PurchaseItemModel> = []
    /// f_vip_weekly
    var purchaseFVipWeeklyArray: Array<PurchaseItemModel> = []
    
    /// l_money
    var purchaseLMoneyArray: Array<PurchaseItemModel> = []
    /// l_coins
    var purchaseLCoinsAray: Array<PurchaseItemModel> = []
    /// l_vip_monthly
    var purchaseLVipMonthlyArray: Array<PurchaseItemModel> = []
    
    /// coins_money
    var purchaseCoinsMoneyArray: Array<PurchaseItemModel> = []
    
    /// error type
    var errprItemArray: Array<PurchaseItemModel> = []
    
    class func createModelCollection(json: Data) -> PurchaseItemModelCollection {
        
        let purchaseItemCollection = PurchaseItemModelCollection()
        let jsonData = JSON.init(json)
        
        let localizedPriceDic = MarsCache.obtainPurchaseLoactionPrice()
        
        for subJson in jsonData["items"].array ?? [] {
            let model = PurchaseItemModel.init()
            model.costAvg = subJson["costAvg"].string
            model.iapId = subJson["iapId"].string
            model.ID = subJson["id"].int
            model.itemCount = subJson["itemCount"].int
            model.itemDiscounts = subJson["itemLimitation"].float == nil ? 1 : subJson["itemLimitation"].float
            model.itemLimitation = subJson["itemLimitation"].int
            model.itemName = subJson["itemName"].string
            model.itemType = purchaseType(strType: subJson["itemType"].string!)
            model.goodName = purchaseGoodName(strType: model.itemType!)
            model.costTotal = subJson["costTotal"].string
            model.productId = subJson["productId"].string
            model.currentPrice =  Float(model.costTotal!)! * Float(model.itemDiscounts!)
            if let iapID = model.iapId, let localizedPrice = localizedPriceDic?[iapID] {
                model.localizedPrice = localizedPrice
            } else {
                model.localizedPrice = ("$" + (model.costTotal ?? ""))
            }
                        
            switch model.itemType {
            case .Ef_money:
                purchaseItemCollection.purchaseFMoneyArray.append(model)
                break
                
            case .Ef_coins:
                purchaseItemCollection.purchaseFCoinsArray.append(model)
                break
                
            case .Ef_golden_money:
                purchaseItemCollection.purchaseFGoldenMoneyArray.append(model)
                break
                
            case .Ef_golden_coins:
                purchaseItemCollection.purchaseFGoldenCoinsArray.append(model)
                break
                
            case .Ef_vip_weekly:
                purchaseItemCollection.purchaseFVipWeeklyArray.append(model)
                break
                
            case .El_money:
                purchaseItemCollection.purchaseLMoneyArray.append(model)
                break
                
            case .El_coins:
                purchaseItemCollection.purchaseLCoinsAray.append(model)
                break
                
            case .El_vip_monthly:
                purchaseItemCollection.purchaseLVipMonthlyArray.append(model)
                break
                
            case .ECoins_money:
                purchaseItemCollection.purchaseCoinsMoneyArray.append(model)
                break
                
            default:
                purchaseItemCollection.errprItemArray.append(model)
                break
            }
        }
        
        return purchaseItemCollection
    }
    
    class func purchaseGoodName(strType: EPurchaseItemType) -> String {
        let fKey = String.init(utf8String: uStrf)!
        let lKey = String.init(utf8String: uStrl)!
        
        switch strType {
        case .Ef_money:
            return "Fo\("llowe")rs"
            
        case .Ef_coins:
            return ""
            
        case .Ef_golden_money:
            return ""
            
        case .Ef_golden_coins:
            return ""
            
        case .Ef_vip_weekly:
            return ""
            
        case .El_money:
            return "Li\("ke")s"
            
        case .El_coins:
            return ""
            
        case .El_vip_monthly:
            return ""
            
        case .ECoins_money:
            return "Coins"
            
        default:
            
            return ""
        }
    }
    
    class func purchaseType(strType: String) -> EPurchaseItemType {
        let fKey = String.init(utf8String: uStrf)!
        let lKey = String.init(utf8String: uStrl)!
        
        switch strType {
        case fKey + "_money":
            return EPurchaseItemType.Ef_money
            
        case fKey + "_coins":
            return EPurchaseItemType.Ef_coins
            
        case fKey + "_golden_money":
            return EPurchaseItemType.Ef_golden_money
            
        case fKey + "_golden_coins":
            return EPurchaseItemType.Ef_golden_coins
            
        case fKey + "_vip_weekly":
            return EPurchaseItemType.Ef_vip_weekly
            
        case lKey + "_money":
            return EPurchaseItemType.El_money
            
        case lKey + "_coins":
            return EPurchaseItemType.El_coins
            
        case lKey + "_vip_monthly":
            return EPurchaseItemType.El_vip_monthly
            
        case "coins_money":
            return EPurchaseItemType.ECoins_money
            
        default:
            print("strType: " + strType)
            return EPurchaseItemType.EError
        }
    }
}

class PurchaseItemModel: NSObject {
    
    var costAvg: String?
    var costTotal: String?
    var iapId: String?
    var ID: Int?
    var itemCount: Int?
    var itemDiscounts: Float?
    /// vip love 添加的图片数量
    var itemLimitation: Int?
    var itemName: String?
    var itemType: EPurchaseItemType?
    var productId: String?
    /// costTotal * itemDiscounts
    var currentPrice: Float?
    var localizedPrice: String = ""
    var localizedDescription: String = ""
    var currencyCode: String = "USD"
    var goodName: String = ""
}
