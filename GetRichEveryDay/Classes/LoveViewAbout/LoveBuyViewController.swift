//
//  LoveBuyViewController.swift
//  GetRichEveryDay
//
//  Created by 薛忱 on 2020/12/8.
//

import UIKit
import Alertift

class LoveBuyViewController: UIViewController {

    let topView = TopUserCoinsView()
    var nodeModel: Node?
    let nodeImageView = UIImageView()
    let typeImageView = UIImageView()
    let loveNumLabel = UILabel()
    var fDataArray: Array<PurchaseItemModel> = []
    var selectPurchaseItem: PurchaseItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(userlogin(notify:)), name: .GREDUserChange, object: nil)
        self.fDataArray = PurchaseItemCollectionManage.default.obtainItems(withPurchaseItemType: .El_coins)
        self.selectPurchaseItem = self.fDataArray[0]
        topView.backgroundColor = .black
        topView.enterStyle(styel: .backAndCoins)
        topView.loadCurrentUserInfo()
        topView.backButtonClickCallBack = {
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                }
            }
        }
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(currentDiviceIsFullSceen() ? 88 : 64)
        }
        
        let tipPrivateLabel = UILabel()
        tipPrivateLabel.text = "This is a private account. If you want to purchase, please make your account public and post a post."
        tipPrivateLabel.isHidden = true
        tipPrivateLabel.textAlignment = .center
        tipPrivateLabel.textColor = UIColor.init(hexString: "#909090")
        tipPrivateLabel.font = UIFont(name: fontHiraginoSansW6, size: 12)
        tipPrivateLabel.numberOfLines = 0
        self.view.addSubview(tipPrivateLabel)
        tipPrivateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(35)
            make.right.equalTo(-35)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
        }
        
        let privateImageView = UIImageView()
        privateImageView.isHidden = true
        privateImageView.image = UIImage(withBundleName: "lock_post_ic")
        self.view.addSubview(privateImageView)
        privateImageView.snp.makeConstraints { (make) in
            make.width.equalTo(24)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(tipPrivateLabel.snp.top).offset(-20)
        }
        
        if ((UserManage.default.currentUserModel?.isPrivate) ?? false) {
            tipPrivateLabel.isHidden = false
            privateImageView.isHidden = false
            return
        }
        
        nodeImageView.layer.masksToBounds = true
        nodeImageView.contentMode = .scaleAspectFill
        nodeImageView.kf.indicatorType = .activity
        nodeImageView.kf.setImage(with: nodeModel?.displayUrl)
        self.view.addSubview(nodeImageView)
        nodeImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(200)
            make.top.equalTo(topView.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
        }
        
        typeImageView.contentMode = .scaleAspectFill
        nodeImageView.addSubview(typeImageView)
        typeImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.top.equalTo(3)
            make.right.equalTo(-3)
        }
        
        loveNumLabel.text = "💖" + String(digitalFormat(num: nodeModel?.edgeLoveBy ?? 0))
        loveNumLabel.backgroundColor = UIColor.init(hexString: "#000000", transparency: 0.6)
        loveNumLabel.textAlignment = .center
        loveNumLabel.textColor = .white
        loveNumLabel.font = UIFont(name: fontHiraginoSansW6, size: 16)
        nodeImageView.addSubview(loveNumLabel)
        loveNumLabel.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(33)
        }
        
        let tipLabel = UILabel()
        tipLabel.text = "During the adding of like, make sure that the Instagram account is not a private account, otherwise the redemption will fail."
        tipLabel.textAlignment = .center
        tipLabel.textColor = UIColor.init(hexString: "#515151")
        tipLabel.font = UIFont(name: fontHiraginoSansW3, size: 12)
        tipLabel.numberOfLines = 0
        self.view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nodeImageView.snp.bottom).offset(24)
            make.left.equalTo(56)
            make.right.equalTo(-56)
        }
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.init(hexString: "#191919")
        pickerView.layer.cornerRadius = 16
        self.view.addSubview(pickerView)
        pickerView.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(32)
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.height.equalTo(104)
        }
        
        let exchangeButton = UIButton()
        exchangeButton.titleLabel?.font = UIFont(name: fontHiraginoSansW6, size: 16)
        exchangeButton.setTitle("Exchange", for: .normal)
        exchangeButton.addTarget(self, action: #selector(exchangeButtonClick(button:)), for: .touchUpInside)
        exchangeButton.setBackgroundImage(UIImage(withBundleName: "get_coins_like_btn_bg_ic"), for: .normal)
        self.view.addSubview(exchangeButton)
        exchangeButton.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.top.equalTo(pickerView.snp.bottom).offset(32)
            make.centerX.equalTo(self.view)
        }
    }
    
    @objc func exchangeButtonClick(button: UIButton) {
        guard let currentUserModel = UserManage.default.currentUserModel else {
            LogInManage.showLoginView(controller: UIViewController.currentViewController() ?? self)
            
            return
        }
        
        if self.fDataArray.count == 0 {
            Alertift.alert(title: "NOTE: You must publish a post to purchase the item", message: nil)
            .action(.cancel("OK")) { _, _, _ in
            }
            .show(on: visibleVC, completion: nil)
            return
        }
        
        if currentUserModel.isPrivate {
            
            Alertift.alert(title: "NOTE: Please turn off \"Private Account\" \nbefore starting receive l\("ik")es.", message: nil)
            .action(.cancel("OK")) { _, _, _ in
            }
            .show(on: visibleVC, completion: nil)
            return
        }
        
        guard let selectPurchModel = self.selectPurchaseItem, let currentNode = self.nodeModel else {
            return
        }
        
        if selectPurchModel.itemType == EPurchaseItemType.El_money {
            
            PurchaseItemCollectionManage.default.startBuy(purchase: selectPurchModel,
                                                          node: currentNode, isAdheret: false)
        } else {
            
            buy(userMoel: currentUserModel,
                itemModel: selectPurchModel,
                buyType: selectPurchModel.itemType,
                userNode: currentNode)
        }
    }
    
    func buy(userMoel: UserModel, itemModel: PurchaseItemModel, buyType: EPurchaseItemType?, userNode: Node) {
        
        switch buyType {
        case .El_money:
            break
            
        case .El_coins:
            
            let node = userNode // 获得当前选中的帖子
            guard let coinsNum = itemModel.costTotal?.int,
                  let itemNum = itemModel.itemCount,
                  let mediaID = node.ID,
                  let nodeUrl = node.thumbnailSrc else {
                    
                  return
            }
            
            if (userMoel.userNativeCoinsNum ?? 0) >= coinsNum {
                HubManager.show()
                RequestNetWork.requestCoinsLove(mediaID: mediaID,
                                                thumbnailUrl: nodeUrl.absoluteString,
                                                lowResolutionUrl: nodeUrl.absoluteString,
                                                isPromotion: false,
                                                loveSize: itemNum,
                                                success: {
                                                    // 用户资料变更
                                                    HubManager.success("Buy Success")
                                                    UserManage.userInfoUpload()
                                                    AdjustManage.sharedInstance.pointExchangeSuccessLikeTotal()
                                                    
                                                    DispatchQueue.main.async {
                                                        self.dismiss(animated: true) {
                                                        }
                                                    }
                                                    
                }) { (error) in
                    Alertift.alert(title: error.localizedDescription, message: nil)
                    .action(.cancel("OK")) { _, _, _ in
                    }
                    .show(on: self.visibleVC, completion: nil)
                }
                
            } else {
                Alertift.alert(title: "Coins Shortage", message: nil)
                .action(.cancel("OK")) { _, _, _ in
                    
                    DispatchQueue.main.async {
                        let storeVC = StoreViewController()
                        storeVC.topViewIsBack = true
                        storeVC.modalTransitionStyle = .crossDissolve
                        storeVC.modalPresentationStyle = .fullScreen
                        self.present(storeVC, animated: true) {
                        }
                    }
                    
                }
                .show(on: visibleVC, completion: nil)
            }
            break
        default:
            break
        }
    }
    
    @objc func userlogin(notify: Notification) {
        topView.loadCurrentUserInfo()
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

extension LoveBuyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.fDataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let itemModel = fDataArray[row]
        
        var label = view as? UILabel
        if label == nil {
            label = UILabel()
            label?.font = UIFont(name: fontHiraginoSansW6, size: 24)
            label?.textAlignment = .center
            label?.textColor = .white
        }
        label?.text = "🌟\(String(itemModel.costTotal!)) ➡️ 💖" + (itemModel.itemCount?.toString())!
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectPurchaseItem = fDataArray[row]
    }
}
