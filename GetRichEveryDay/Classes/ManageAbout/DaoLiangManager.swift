//
//  DaoLiangManager.swift
//  Adjust
//
//  Created by 薛忱 on 2020/8/4.
//

import UIKit

enum EBuyDaoLiangType {
    case EAdherent
    case ELove
    case ECoins
}

class DaoLiangManager: NSObject {
    public static let `default` = DaoLiangManager()
    private override init() {
    }
    
    // 倒量
    func showDaoLiang() {
        
//        guard let userModel = UserManage.default.currentUserModel, let config = NativeConfigManage.default.config else {
//            return
//        }
//        
//        // 判断是否开启倒量
//        if config.cfgDliangDakai == 0 {
//            return
//        }
//        
//        // 用户等级
//        let userLevel = userModel.userLevel
//                
//        // 查找 def 倒量
//        var daoliangArray = config.cfgDaoliangLevelScheme?.filter({ (model) -> Bool in
//            return model.level == 0
//            
//        })
//        
//        // 开启 分级 倒量
//        if config.cfgDliangUserlevelSwitch == 1 {
//            daoliangArray = config.cfgDaoliangLevelScheme?.filter({ (model) -> Bool in
//                return model.level == userLevel
//            })
//        }
//        
//        // 如果 倒量 不存在 不显示
//        if daoliangArray?.count == 0 {
//            return
//        }
//        
//        guard let daoliangModel = daoliangArray?[0] else {
//            return
//        }
//        
//        let dlVC = DaoliangViewController.init()
//        dlVC.daoliangNobackTransfer = config.cfgNobackTransfer == 1 ? true : false
//        dlVC.assignmentDaoliang(model: daoliangModel)
//        UIViewController.currentViewController()?.presentOverfullScreenVC(presentVC: dlVC)
    }
    
    // 购买倒量
    func showBuyDaoLiang(type: EBuyDaoLiangType) {
        
        guard let userModel = UserManage.default.currentUserModel, let config = NativeConfigManage.default.config else {
            return
        }
        
        // 判断是否开启倒量
        if config.cfgBuyManualTransfer == 0 {
            return
        }
        
        // 用户等级
        let userLevel = userModel.userLevel
                
        // 查找 def 倒量
        var daoliangArray = config.cfgDaoliangScheme?.filter({ (model) -> Bool in
            return model.level == 0
        })
        
        // 开启 分级 倒量
        if config.cfgDliangUserlevelSwitch == 1 {
            daoliangArray = config.cfgDaoliangScheme?.filter({ (model) -> Bool in
                return model.level == userLevel
            })
        }
        
        // 如果 倒量 不存在 不显示
        if daoliangArray?.count == 0 {
            return
        }
        
        guard let daoliangModel = daoliangArray?[0] else {
            return
        }
        

        let dlVC = DaoliangViewController.init()
        dlVC.daoliangNobackTransfer = config.cfgNobackTransfer == 1 ? true : false
        dlVC.assignmentDaoliang(model: daoliangModel)
        UIViewController.currentViewController()?.presentOverfullScreenVC(presentVC: dlVC)
    }
}               

