//
//  ViewController.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/2.
//

import UIKit
import RxCocoa
import RxSwift

class FreeCoinsViewController: UIViewController {

    let topView = TopUserCoinsView()
    let postView = PostView()
    let commitButton = AdHereOrLoveButton()
    var postManage: FreeCoinsPostManage = FreeCoinsPostManage.sharedInstance
    var skipButton = UIButton()
    let dlView = DaoliangView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(userlogin(notify:)), name: .GREDUserChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userIconChange(notify:)), name: .GREDUserCoinsChange, object: nil)
        self.view.backgroundColor = .black
        
        topView.backgroundColor = .black
        topView.enterStyle(styel: .nameAndCoins)
        topView.loadCurrentUserInfo()
        topView.coinsButtonClickCallBack = {
            NotificationCenter.default.post(name: .GREDJumpToStore, object: nil)
        }
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(currentDiviceIsFullSceen() ? 88 : 64)
        }
        
        dlView.isHidden = true
        self.view.addSubview(dlView)
        dlView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(topView.snp.bottom).offset(0)
            make.height.equalTo(66)
        }
        
        // post View
        self.postView.backgroundColor = .white
        self.postView.delegate = self
        self.view.addSubview(self.postView)
        
        
        if currentDiviceIsFullSceen() {
            self.postView.snp.makeConstraints { (make) in
                make.width.height.equalTo(230)
                make.centerY.equalTo(self.view)
                make.centerX.equalTo(self.view)
            }
        } else {
            self.postView.snp.makeConstraints { (make) in
                make.width.height.equalTo(230)
                make.top.equalTo(self.topView.snp.bottom).offset(120)
                make.centerX.equalTo(self.view)
            }
        }
            
        // commit view
        commitButton.delegate = self
        self.view.addSubview(commitButton)
        commitButton.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(40)
            make.top.equalTo(self.postView.snp.bottom).offset(23)
            make.centerX.equalTo(self.view)
        }
        
        skipButton.setBackgroundImage(UIImage(withBundleName: "get_coins_skip_ic"), for: .normal)
        self.view.addSubview(skipButton)
        skipButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.centerY.equalTo(commitButton.snp.centerY)
            make.right.equalTo(commitButton.snp.left).offset(-15)
        }
        
        self.skipButton.rx.tap.asObservable().debounce(.milliseconds(240), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] in
            
            DispatchQueue.main.async {

                guard let _ = UserManage.default.currentUserModel else {
                    LogInManage.showLoginView(controller: (UIViewController.currentViewController() ?? self)!)
                    return
                }
                
                HubManager.showHideMask()
                self?.postManage.showOrder()
                DispatchQueue.main.after(time: .now() + 0.5) {
                    HubManager.hide()
                }
            }
        })

        
        postManage.adhereCallback = {[weak self] item in
            self?.postView.showAdhere(model: item)
            self?.postView.changePlaceholder(isEmpty: item == nil ? true : false)
            self?.commitButton.typeAdhere(isEmpty: item == nil ? true : false)
        }
        
        postManage.loveCallback = {[weak self] item in
            self?.postView.showLove(model: item)
            self?.postView.changePlaceholder(isEmpty: item == nil ? true : false)
            self?.commitButton.typeLove(isEmpty: item == nil ? true : false)
        }
        
    }
    
    @objc func userIconChange(notify: Notification) {
        topView.loadCurrentUserInfo()
    }
    
    @objc func userlogin(notify: Notification) {
        topView.loadCurrentUserInfo()
        
        postManage.clearAllData()
        postManage.reqesutPostData()
        commitButton.getOneLoveAndAdhereCoins()
        
        showDaoLiang()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func showDaoLiang() {
        
        guard let userModel = UserManage.default.currentUserModel, let config = NativeConfigManage.default.config else {
            dlView.isHidden = true
            return
        }
        
        // 判断是否开启倒量
        if config.cfgDliangDakai == 0 {
            return
        }
        
        // 用户等级
        let userLevel = userModel.userLevel
                
        // 查找 def 倒量
        var daoliangArray = config.cfgDaoliangLevelScheme?.filter({ (model) -> Bool in
            return model.level == 0
        })
        
        // 开启 分级 倒量
        if config.cfgDliangUserlevelSwitch == 1 {
             var fenjidaoliangArray = config.cfgDaoliangLevelScheme?.filter({ (model) -> Bool in
                return model.level == userLevel
            })
            
            if (fenjidaoliangArray?.count ?? 0) > 0 {
                daoliangArray = fenjidaoliangArray
            }
        }
        
        // 如果 倒量 不存在 不显示
        if daoliangArray?.count == 0 {
            dlView.isHidden = true
            return
        }
        
        guard let daoliangModel = daoliangArray?[0] else {
            dlView.isHidden = true
            return
        }
        
        if dlView.isHidden {
            AdjustManage.sharedInstance.pointDaoliangImpression()
        }
        
        dlView.isHidden = false
        dlView.assignmentDaoliang(model: daoliangModel)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FreeCoinsViewController: AdHereOrLoveButtonDelegate, PostViewDelegate {
    func tipButtonClick() {
        
        let tipVC = UserMessageAlertViewController()
        tipVC.msgTitle = "Tips"
        tipVC.msgContent = "Please dont exit the app when you have orders running in background to earn coins.Otherwise it will stop working."
        self.presentOverfullScreenVC(presentVC:tipVC)
    }
    
    func skipButtonClick() {
        guard let _ = UserManage.default.currentUserModel else {
            LogInManage.showLoginView(controller: UIViewController.currentViewController() ?? self)
            return
        }
        
        postManage.showOrder()
    }
    
    func buttonClick() {
        guard let _ = UserManage.default.currentUserModel else {
            LogInManage.showLoginView(controller: UIViewController.currentViewController() ?? self)
            return
        }
        
        postManage.startOrder()
    }
    
    
}
